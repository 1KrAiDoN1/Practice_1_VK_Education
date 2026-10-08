SET SESSION silver.compression_codec = 'ZSTD';
CREATE TABLE silver.sf1.part_supplier_clean
WITH (format = 'PARQUET') AS
SELECT p.partkey, ps.suppkey, p.brand, p.type, p.size
FROM bronze.sf1.partsupp ps
JOIN bronze.sf1.part p ON p.partkey = ps.partkey
WHERE p.brand <> 'Brand#45'
  AND p.type NOT LIKE 'MEDIUM POLISHED%'
  AND p.size IN (49, 14, 23, 45, 19, 3, 36, 9)
  AND ps.suppkey NOT IN (
    SELECT suppkey FROM bronze.sf1.supplier
    WHERE comment LIKE '%Customer%Complaints%'
  );

SET SESSION gold.compression_codec = 'ZSTD';
CREATE TABLE gold.sf1.q16_supplier_counts
WITH (format = 'PARQUET') AS
SELECT brand, type, size, count(DISTINCT suppkey) AS supplier_cnt
FROM silver.sf1.part_supplier_clean
GROUP BY brand, type, size;

SELECT * FROM gold.sf1.q16_supplier_counts
ORDER BY supplier_cnt DESC, brand, type, size;
