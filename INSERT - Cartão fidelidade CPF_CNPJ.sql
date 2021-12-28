/*
    Percorre todas entidades cadastradas na base.
    Se não existir cartão fidelidade para entidade : insere
    Numero do cartão será o CPF/CNPJ da entidade
*/

DO $$
DECLARE 
    empresa_lo INTEGER;  
    idseq BIGINT;
    entidade FK;
    cpf_cnpj CPFCNPJ;
    data_validade DATE;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    data_validade = 'dd/mm/yyyy'; -- Informar data de validade dos cartões

    FOR entidade, cpf_cnpj IN 
        SELECT e.ID_ENTIDADE, e.DS_CPFCNPJ 
        FROM ENTIDADE e WHERE e.CH_EXCLUIDO IS NULL AND e.DS_CPFCNPJ IS NOT NULL
        AND e.CH_ATIVO = 'T' AND NOT EXISTS (
            SELECT 1 FROM CARTAO c WHERE c.CH_EXCLUIDO IS NULL 
            AND c.ID_ENTIDADE = e.ID_ENTIDADE
        )        
    LOOP 

        idseq = NEXTVAL('gen_cartao');

        INSERT INTO CARTAO 
            (ID_CARTAO, ID_EMPRESA, ID_SEQ, NR_CARTAO, ID_ENTIDADE, DH_CADASTRO, CH_TIPO, DT_VALIDADE, CH_ATIVO, CH_UTISENHA)
        VALUES 
            (idseq || '-' || empresa_lo, empresa_lo, idseq, cpf_cnpj, entidade, CURRENT_TIMESTAMP, 'F', data_validade, 'T', 'F');

    END LOOP;
END$$;