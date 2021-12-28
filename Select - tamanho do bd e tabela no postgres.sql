-- TAMANHO DE BANCO DE DADOS

-- TAMANHO DE BANCO DE DADOS SEM ARREDONDAMENTO

postgres=# SELECT pg_database_size('xx_teste');

-- TAMANHO DE BANCO DE DADOS COM ARREDONDAMENTO

postgres=# SELECT pg_size_pretty(pg_database_size('xx_teste'));

-- TAMANHO DE BANCO DE DADOS REAL NO DISCO, COM ARREDONDAMENTO

postgres=# SELECT pg_size_pretty(pg_database_size('xx_teste')) As fulldbsize;

-- TAMANHO DE TABELA

postgres=# SELECT pg_size_pretty(pg_total_relation_size('docfiscal_eletro'));

-- TAMANHO DE TODAS AS TABELAS EM ORDEM DECRESCENTE

SELECT
 TABLE_NAME,
 (CAST(pg_total_relation_size(TABLE_NAME) AS DECIMAL(18,3)) / 1024) SIZE_KB,
 (CAST(pg_total_relation_size(TABLE_NAME) AS DECIMAL(18,3)) / 1024 / 1024) SIZE_MB,
 (CAST(pg_total_relation_size(TABLE_NAME) AS DECIMAL(18,3)) / 1024 / 1024 / 1024) SIZE_GB 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'public'
ORDER BY 2 DESC;


