

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    identidade FK;
    idpolitica FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idpolitica = 'CODIGO_POLITICA'; -- INFORMAR A POLITICA DE FATURAMENTO DESEJADA
    
    FOR identidade IN
        SELECT id_entidade FROM entidade 
            WHERE id_grupoentidade = 'CODIGO_GRUPO' -- INFORMAR O GRUPO DE ENTIDADE DESEJADO
            AND ch_ativo = 'T' 
            AND ch_excluido IS NULL
    
    LOOP

        idseq = NEXTVAL('gen_regrafat_filtro');

        INSERT INTO REGRAFAT_FILTRO (ID_REGRAFAT_FILTRO, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_REGRAFAT, CH_TIPO_FIL, ID_FILIAL, ID_GRUPOENTIDADE, ID_ENTIDADE, ID_ESPECIE)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', idpolitica, 'E', empresa_lo, NULL, identidade, NULL);

    END LOOP;
END$$;