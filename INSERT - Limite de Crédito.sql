
    /* 

    CH_TIPO:  (Se CH_TIPO = F, preencher o campo ID_FILIAL com o número da empresa desejada)
    F para FILIAL
    G para GERAL

    CH_LIMCRE 
    A para APROVADO
    B para BLOQUEADO
    D para DESBLOQUEADO

    Se CH_ESPECIE = T, preencher o campo ID_ESPECIE com o código da espécie desejada)

    DS_MOTIVO: texto livre com limite de 100 caracteres

    */

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;

BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idseq = NEXTVAL('gen_entidade_cred');
    INSERT INTO ENTIDADE_CRED (ID_ENTIDADE_CRED, ID_EMPRESA, ID_SEQ, DS_USUARIO, CH_EXCLUIDO, ID_ENTIDADE, CH_TIPO, ID_FILIAL, CH_SITCRE, VL_LIMCRE, CH_ESPECIE, ID_ESPECIE, DS_MOTIVO) 
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, 'POSTGRES', NULL, 'CODIGO ENTIDADE', 'F', CODIGO EMPRSA, 'B', '1000', 'T', 'CODIGO ESPECIE', 'PORQUE SIM');
    idseq = NEXTVAL('gen_entidade_cred');
    INSERT INTO ENTIDADE_CRED (ID_ENTIDADE_CRED, ID_EMPRESA, ID_SEQ, DS_USUARIO, CH_EXCLUIDO, ID_ENTIDADE, CH_TIPO, ID_FILIAL, CH_SITCRE, VL_LIMCRE, CH_ESPECIE, ID_ESPECIE, DS_MOTIVO) 
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, 'POSTGRES', NULL, 'CODIGO ENTIDADE', 'G', NULL, 'B', '10000', 'T', 'CODIGO ESPECIE', 'DEUS QUIS ASSIM');


END$$;