--Comandos para rastreio de entrega futura:

--Consultar nota que gerou estoque da entrega futura:

SELECT 
    id_docfiscal,
    * 
FROM entregafutura 
    WHERE id_entregafutura = '65-2' 
    AND ch_excluido IS NULL

--Consultar notas de saida que usaram o saldo da entrega futura:

SELECT 
    id_docfiscal,
    * 
FROM entregafutura_bai 
    WHERE id_entregafutura = '65-2' 
    AND ch_excluido IS NULL

--Somar notas de saida que usaram o saldo da entrega futura:

SELECT 
    sum(qt_baixa) 
FROM entregafutura_bai 
    WHERE id_entregafutura = '65-2' 
    AND ch_excluido IS NULL