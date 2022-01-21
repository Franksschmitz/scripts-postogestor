/*
Agora na tabela REP$LOG o campo DS_ORIGEM fica gravado o mesmo valor que aparece lá na tela de login da máquina
ele gera um número aleatório a primeira vez que inicia o app na máquina e depois mantem
sql para verificar, trocar a data conforme necessário  */


SELECT DS_ORIGEM, json_data->>'id_pontovenda' AS id_pontovenda FROM REP$LOG 
WHERE DS_ORIGEM LIKE 'PDVMOVEL:%' AND json_data->>'id_pontovenda' IS NOT NULL AND dt_log >= '2021-07-01'
GROUP BY 1, 2

--esse sql só funciona na filial onde foi gerado o log