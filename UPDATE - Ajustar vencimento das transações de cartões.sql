/*
    ESSE COMANDO IRÁ AJUSTAR OS VENCIMENTOS NAS TABELAS DOCFISCAL_BAIXA E CONCIRECPAG, PARA AS TRANSAÇÕES ONDE O VENCIMENTO REGISTRADO FOI IGUAL A DATA DE EMISSAO, 
    DEVIDO A NÃO TER VENCIMENTO CONFIGURADO NO MODELO DE CARTÃO.
*/

DO $$
DECLARE
    empresa_lo INTEGER;
    idfilial INTEGER;
    diasvenc INTEGER;
    iddocbaixa FK;
    idcartao FK;
    idconci FK;

BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idcartao = '10-1'; -- INSERIR O CODIGO DO MODELO DE CARTAO QUE DESEJA AJUSTAR
    idfilial = 5;      -- INSERIR O CODIGO DA EMPRESA QUE DESEJA AJUSTAR
    diasvenc = '30';   -- INSERIR A QUANTIDADE DE DIAS DE VENCIMENTO QUE DEVE SER APLICADO 


    FOR idconci, iddocbaixa IN 
        SELECT id_concirecpag, id_docfiscal_baixa FROM concirecpag 
            WHERE id_cartaotef = idcartao 
            AND ch_excluido IS NULL
            AND dt_vencim = dt_emissa
            AND ch_situac = 'A'
            AND id_empresa = idfilial

    
    LOOP 
        UPDATE docfiscal_baixa SET 
            dt_vencim = CAST((dt_emissa + diasvenc) AS DATE)
        WHERE id_cartaotef = idcartao
        AND id_docfiscal_baixa = iddocbaixa
        AND ch_excluido IS NULL;


        UPDATE concirecpag SET 
            dt_vencim = CAST((dt_emissa + diasvenc) AS DATE)
        WHERE id_cartaotef = idcartao
        AND id_docfiscal_baixa = iddocbaixa
        AND id_concirecpag = idconci
        AND ch_excluido IS NULL;


    END LOOP;
END$$;