-- Все три результата проверки должны быть 0.
SELECT count(*) AS null_keys
FROM silver.sf1.part_supplier_clean
WHERE partkey IS NULL OR suppkey IS NULL OR brand IS NULL OR type IS NULL OR size IS NULL;

SELECT count(*) AS duplicated_pairs
FROM (
  SELECT partkey, suppkey
  FROM silver.sf1.part_supplier_clean
  GROUP BY partkey, suppkey HAVING count(*) > 1
);

SELECT count(*) AS broken_references
FROM bronze.sf1.partsupp ps
LEFT JOIN bronze.sf1.part p ON p.partkey = ps.partkey
LEFT JOIN bronze.sf1.supplier s ON s.suppkey = ps.suppkey
WHERE p.partkey IS NULL OR s.suppkey IS NULL;
