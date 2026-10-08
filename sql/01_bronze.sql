-- Основные данные sf1. Выполнять один раз на пустых схемах.
CREATE SCHEMA IF NOT EXISTS bronze.sf1;
CREATE SCHEMA IF NOT EXISTS silver.sf1;
CREATE SCHEMA IF NOT EXISTS gold.sf1;

SET SESSION bronze.compression_codec = 'ZSTD';
CREATE TABLE bronze.sf1.part WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.part;
CREATE TABLE bronze.sf1.partsupp WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.partsupp;
CREATE TABLE bronze.sf1.supplier WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.supplier;

SELECT 'part' AS table_name, count(*) AS rows FROM bronze.sf1.part
UNION ALL SELECT 'partsupp', count(*) FROM bronze.sf1.partsupp
UNION ALL SELECT 'supplier', count(*) FROM bronze.sf1.supplier;
