/* ESSE INSERT DEVE SER UTILIZADO APENAS QUANDO JÁ EXISTEM CARTOES CADASTRADOS E QUE NÃO POSSUAM SALDOOU QUALQUER REGISTRO NA TABELA CARTAO_MOV */

DO $$
DECLARE 
    empresa_lo INTEGER;  
    idseq BIGINT;
    dt_emi DATE;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;
    perform set_config('myvars.ID_EMPRESA', empresa_lo::text, true);

    dt_emi = '2021-07-13';

    idseq = NEXTVAL('gen_cartao_mov');  
            INSERT INTO CARTAO_MOV (ID_CARTAO_MOV, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_CARTAO, CH_OPERAC, VL_VALOR, VL_SALDO, DH_MOVIME, ID_DOCFISCAL_BAIXA, ID_DOCFISCAL, ID_FIDELIDADECFG, ID_RECTOPAGTO, ID_RECTOPAGTO_BAIXA, ID_FILIAL, DS_HISTORICO, CH_AVULSA, CH_TIPO, ID_CARTAO_TRANSF, ID_DOCFISCAL_ITEM, ID_LANC, CH_BRINDE, DT_VENCIM, CH_BLOQUEADO)
            VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', '9-1', 'C', '9', '9', dt_emi, NULL, NULL, NULL, NULL, NULL, empresa_lo, 'IMPORTAÇÃO', 'T', 'A', NULL, NULL, NULL, NULL, NULL, NULL);
    idseq = NEXTVAL('gen_cartao_mov');  
            INSERT INTO CARTAO_MOV (ID_CARTAO_MOV, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_CARTAO, CH_OPERAC, VL_VALOR, VL_SALDO, DH_MOVIME, ID_DOCFISCAL_BAIXA, ID_DOCFISCAL, ID_FIDELIDADECFG, ID_RECTOPAGTO, ID_RECTOPAGTO_BAIXA, ID_FILIAL, DS_HISTORICO, CH_AVULSA, CH_TIPO, ID_CARTAO_TRANSF, ID_DOCFISCAL_ITEM, ID_LANC, CH_BRINDE, DT_VENCIM, CH_BLOQUEADO)
            VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', '1550-1', 'C', '4328', '4328', dt_emi, NULL, NULL, NULL, NULL, NULL, empresa_lo, 'IMPORTAÇÃO', 'T', 'A', NULL, NULL, NULL, NULL, NULL, NULL);
    idseq = NEXTVAL('gen_cartao_mov');  
            INSERT INTO CARTAO_MOV (ID_CARTAO_MOV, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_CARTAO, CH_OPERAC, VL_VALOR, VL_SALDO, DH_MOVIME, ID_DOCFISCAL_BAIXA, ID_DOCFISCAL, ID_FIDELIDADECFG, ID_RECTOPAGTO, ID_RECTOPAGTO_BAIXA, ID_FILIAL, DS_HISTORICO, CH_AVULSA, CH_TIPO, ID_CARTAO_TRANSF, ID_DOCFISCAL_ITEM, ID_LANC, CH_BRINDE, DT_VENCIM, CH_BLOQUEADO)
            VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', '1551-1', 'C', '492', '492', dt_emi, NULL, NULL, NULL, NULL, NULL, empresa_lo, 'IMPORTAÇÃO', 'T', 'A', NULL, NULL, NULL, NULL, NULL, NULL);

END$$;