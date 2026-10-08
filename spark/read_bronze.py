import csv
import json
import os
import time
from pathlib import Path
from pyspark.sql import SparkSession

scale = os.environ.get("LAB_SCALE", "sf1")
if scale != "sf1":
    raise ValueError("Для этой практической выбран только SF1: LAB_SCALE=sf1.")
factor = 1
spark = SparkSession.builder.appName(f"p1-q16-{scale}-bronze").getOrCreate()
out = Path("/opt/spark/results") / scale
out.mkdir(parents=True, exist_ok=True)
counts = {}
for table, expected in [("part", 200000), ("partsupp", 800000), ("supplier", 10000)]:
    expected *= factor
    counts[table] = spark.table(f"bronze.{scale}.{table}").count()
    print(f"Bronze {table}: {counts[table]} строк", flush=True)
    if counts[table] != expected:
        raise RuntimeError(f"Неверный масштаб или неполная загрузка {table}")
spark.table(f"bronze.{scale}.part").select("partkey", "brand", "type", "size").show(10, False)
query = """
SELECT p.brand, p.type, p.size, count(DISTINCT ps.suppkey) AS supplier_cnt
FROM bronze.lakehouse.partsupp ps
JOIN bronze.lakehouse.part p ON p.partkey = ps.partkey
WHERE p.brand <> 'Brand#45'
  AND p.type NOT LIKE 'MEDIUM POLISHED%'
  AND p.size IN (49, 14, 23, 45, 19, 3, 36, 9)
  AND ps.suppkey NOT IN (
    SELECT suppkey FROM bronze.lakehouse.supplier
    WHERE comment LIKE '%Customer%Complaints%'
  )
GROUP BY p.brand, p.type, p.size
ORDER BY supplier_cnt DESC, p.brand, p.type, p.size
""".replace("bronze.lakehouse.", f"bronze.{scale}.")
started = time.perf_counter()
rows = spark.sql(query).collect()
seconds = time.perf_counter() - started
with (out / "spark_q16.csv").open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["brand", "type", "size", "supplier_cnt"])
    writer.writerows([list(row) for row in rows])
expected_file = out / "q16_expected.json"
matched = None
if expected_file.exists():
    expected_rows = json.loads(expected_file.read_text(encoding="utf-8"))
    matched = [list(row) for row in rows] == expected_rows
    if not matched:
        raise RuntimeError("Результат Spark не совпал с эталонным Q16 Trino")
summary = {"scale": scale, "source": f"bronze.{scale}", "counts": counts,
           "q16_seconds_without_spark_startup": seconds, "result_rows": len(rows),
           "matches_trino": matched}
(out / "spark_summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
print(json.dumps(summary, ensure_ascii=False, indent=2), flush=True)
spark.stop()
