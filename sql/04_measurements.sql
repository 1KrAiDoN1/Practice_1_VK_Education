-- Размер активных файлов данных в MiB. Метаданные и старые снапшоты отдельно.
SELECT 'bronze.part' AS table_name, count(*) AS data_files,
       sum(record_count) AS records_in_files,
       CAST(sum(file_size_in_bytes) AS DOUBLE) / 1048576.0 AS data_mib
FROM bronze.sf1."part$files" WHERE content = 0
UNION ALL
SELECT 'bronze.partsupp', count(*), sum(record_count), CAST(sum(file_size_in_bytes) AS DOUBLE) / 1048576.0
FROM bronze.sf1."partsupp$files" WHERE content = 0
UNION ALL
SELECT 'bronze.supplier', count(*), sum(record_count), CAST(sum(file_size_in_bytes) AS DOUBLE) / 1048576.0
FROM bronze.sf1."supplier$files" WHERE content = 0
UNION ALL
SELECT 'silver.part_supplier_clean', count(*), sum(record_count), CAST(sum(file_size_in_bytes) AS DOUBLE) / 1048576.0
FROM silver.sf1."part_supplier_clean$files" WHERE content = 0
UNION ALL
SELECT 'gold.q16_supplier_counts', count(*), sum(record_count), CAST(sum(file_size_in_bytes) AS DOUBLE) / 1048576.0
FROM gold.sf1."q16_supplier_counts$files" WHERE content = 0;

SELECT 'silver' AS layer, count(*) AS rows FROM silver.sf1.part_supplier_clean
UNION ALL SELECT 'gold', count(*) FROM gold.sf1.q16_supplier_counts;

SHOW CREATE TABLE silver.sf1.part_supplier_clean;
SHOW STATS FOR silver.sf1.part_supplier_clean;
