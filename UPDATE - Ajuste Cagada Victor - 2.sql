-- AJUSTA CARTOES NAO CONFIGURADOS ATRAVES DO CODIGO INTERNO (Nº Bandeira)

DO $$
DECLARE
    l_id_empresalo INTEGER;
    l_id_docfiscal_baixa FK;
    l_id_docfiscal FK;
    l_id_cartaotef FK;
    l_id_operatef FK;
    l_id_planoconta FK;
    l_id_bandeiratef FK;
    l_nr_bandeira VARCHAR(25);
    l_nr_carteiradig VARCHAR(25);
BEGIN

    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresalo;


    FOR l_id_docfiscal_baixa, l_nr_bandeira, l_nr_carteiradig IN 
        SELECT tp.ID_DOCFISCAL_BAIXA, tp.NR_BANDEIRA, tp.NR_CARTEIRADIG FROM TEF_OPE tp
            WHERE tp.ID_DOCFISCAL_BAIXA IS NOT NULL 
            AND tp.CH_EXCLUIDO IS NULL
            AND tp.ID_CARTAOTEF = '1-1'
            AND tp.DS_CARTAO = 'CARDSE'
            AND tp.ds_ope <> 'ADM'
        ORDER BY tp.DH_EMISSAO, tp.ID_SEQ
    LOOP

        l_id_cartaotef = ( SELECT ct_.ID_CARTAOTEF FROM CARTAOTEF ct_ WHERE ct_.ID_CARTAOTEF = ( SELECT cto_.ID_CARTAOTEF FROM CARTAOTEF_OPE cto_ WHERE cto_.NR_INTERNO = l_nr_carteiradig OR cto_.NR_INTERNO = l_nr_bandeira LIMIT 1 ));

        l_id_operatef = ( SELECT cto_.ID_OPERATEF FROM CARTAOTEF_OPE cto_ WHERE cto_.NR_INTERNO = l_nr_carteiradig OR cto_.NR_INTERNO = l_nr_bandeira LIMIT 1 );

        l_id_planoconta = ( SELECT ct_.ID_PLANOCONTA FROM CARTAOTEF ct_ WHERE ct_.ID_CARTAOTEF = ( SELECT cto_.ID_CARTAOTEF FROM CARTAOTEF_OPE cto_ WHERE cto_.NR_INTERNO = l_nr_carteiradig OR cto_.NR_INTERNO = l_nr_bandeira LIMIT 1 ));

        l_id_bandeiratef = ( SELECT ct_.ID_BANDEIRATEF FROM CARTAOTEF ct_ WHERE ct_.ID_CARTAOTEF = ( SELECT cto_.ID_CARTAOTEF FROM CARTAOTEF_OPE cto_ WHERE cto_.NR_INTERNO = l_nr_carteiradig OR cto_.NR_INTERNO = l_nr_bandeira LIMIT 1 ));

    
        UPDATE DOCFISCAL_BAIXA SET 
            ID_CARTAOTEF = l_id_cartaotef,
            ID_OPERATEF = l_id_operatef,
            ID_BANDEIRATEF = l_id_bandeiratef
        WHERE ID_DOCFISCAL_BAIXA = l_id_docfiscal_baixa;

        UPDATE CONCIRECPAG SET
            ID_CARTAOTEF = l_id_cartaotef,
            ID_OPERATEF = l_id_operatef,
            ID_BANDEIRATEF = l_id_bandeiratef
        WHERE ID_DOCFISCAL_BAIXA = l_id_docfiscal_baixa;

        UPDATE LANC SET 
            ID_PLANOCONTA = l_id_planoconta,
            ID_CARTAOTEF = l_id_cartaotef,
            ID_OPERATEF = l_id_operatef
        WHERE ID_DOCFISCAL_BAIXA = l_id_docfiscal_baixa
        AND CH_DEBCRE = 'D';

        UPDATE TEF_OPE SET 
            ID_CARTAOTEF = l_id_cartaotef,
            ID_OPERATEF = l_id_operatef,
            ID_PLANOCONTA = l_id_planoconta,
            ID_BANDEIRATEF = l_id_bandeiratef
        WHERE ID_DOCFISCAL_BAIXA = l_id_docfiscal_baixa;
              
    END LOOP;
END$$;
