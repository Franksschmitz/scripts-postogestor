/*
* INSERIR ENTIDADE_ESPECIE APENAS PARA ENTIDADES VINCULADAS A POLITICAS DE FATURAMENTO
*/

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    identidade FK;
    idespecie FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idespecie = '3-1';

    FOR identidade IN
        select id_entidade from entidade_cred 
        where ch_especie = 'T'
        and id_especie = '3-1' 
        and ch_excluido is null
    LOOP 

        idseq = NEXTVAL('gen_entidade_esp');

        INSERT INTO ENTIDADE_ESP (ID_ENTIDADE_ESP, ID_EMPRESA, ID_SEQ, ID_ENTIDADE, ID_ESPECIE, CH_LIBERADO)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, identidade, idespecie, 'T');

    END LOOP;

END$$;