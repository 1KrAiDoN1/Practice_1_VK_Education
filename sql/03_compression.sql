-- Две одинаковые по данным копии Bronze для сравнения кодеков.
-- Основной Bronze и остальные слои сохраняются.
CREATE SCHEMA IF NOT EXISTS bronze.sf1_gzip;
CREATE SCHEMA IF NOT EXISTS bronze.sf1_zstd;

SET SESSION bronze.compression_codec = 'GZIP';
CREATE TABLE bronze.sf1_gzip.part WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.part;
CREATE TABLE bronze.sf1_gzip.partsupp WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.partsupp;
CREATE TABLE bronze.sf1_gzip.supplier WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.supplier;

SET SESSION bronze.compression_codec = 'ZSTD';
CREATE TABLE bronze.sf1_zstd.part WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.part;
CREATE TABLE bronze.sf1_zstd.partsupp WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.partsupp;
CREATE TABLE bronze.sf1_zstd.supplier WITH (format = 'PARQUET')
AS SELECT * FROM tpch.sf1.supplier;
