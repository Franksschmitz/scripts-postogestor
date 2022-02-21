-- Comando para forçar a atualizar os gerados, caso dê erro via configurador

SELECT proc_atualiza_geradores();


-- Exemplo de erro onde seria necessário utilizar o comando acima: 

duplicate key value violates unique constraint "pk_abastecimento"
