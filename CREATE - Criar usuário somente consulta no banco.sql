--Comando padrão para criar usuários somente de leitura para consulta para TI de Postos ou terceiros como 

--Empresa de BI:

CREATE USER CONSULTA WITH PASSWORD '19983101';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO CONSULTA;


--já temos esse modelo na Rede Galo, e teremos tbm na Rede Brasil e Rede Mahle