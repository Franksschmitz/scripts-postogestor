
-- Em casos onde aparecem registros duplicados de cartão na conferência de caixa, porém só existiu uma transação, deverá ser efetuado o passo a passo abaixo.

-- Para localizar o lançamento a ser ajustado, deverá localizar o cupom fiscal na rotina DOCUMENTOS FISCAIS e utilizar o botão RASTREAR>LANCAMENTOS
-- Você irá notar que serão exibidos 6 linhas de lançamentos, sendo 2 delas para a conta do cartão que está duplicado. Você irá escolher uma delas para ser excluída e após isso, irá rodar os 2 comandos abaixo, um de cada vez.
-- LEMBRANDO QUE O REGISTRO SELECIONADO PARA SER EXCLUIDO DEVERÁ TER O SEU CÓDIGO PREENCHIDO NOS 2 COMANDOS ABAIXO.


UPDATE lanc SET ch_excluido = 'T', ch_ativo = 'F'
    WHERE id_agru IN ( SELECT id_agru FROM LANC WHERE id_lanc = 'ID LANC CARTAO DUPLICADO' );


UPDATE concirecpag SET ch_excluido = 'T', ch_ativo = 'F'
    WHERE id_lanc = 'ID LANC CARTAO DUPLICADO';



-- Após rodar os comandos acima, terá que ser ajustado o valor do totalizador da especie da conferencia de caixa, utilizando o comando abaixo:


UPDATE caixapdv_fec SET vl_valor = 'COLOCAR O VALOR', vl_valor_ori = 'COLOCAR O VALOR'
    WHERE id_caixapdv = 'ID DO CAIXA NA CONFERENCIA DE CAIXA'
    AND id_especie = 'ID DA ESPECIE DA DUPLICIDADE'



-- Caso o cliente utilize Caixa Compartilhado, terá que alterar também na tabela CAIXAPDV_FECUSU

UPDATE caixapdv_fecusu SET vl_valor = 'COLOCAR O VALOR', vl_valor_ori = 'COLOCAR O VALOR'
    WHERE id_caixapdv = 'ID DO CAIXA NA CONFERENCIA DE CAIXA'
    AND id_usuario = 'ID DO USUARIO DO CAIXA'
    AND id_caixapdv_fec = 'ID DO TOTALIZADOR DA ESPECIE DA DUPLICIDADE QUE FOI ALTERADO NO COMANDO ANTERIOR'