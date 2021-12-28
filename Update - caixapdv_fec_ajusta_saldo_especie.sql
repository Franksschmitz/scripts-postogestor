/*
    AJUSTA SALDO DO TOTAL DA ESPECIE NA CONFERENCIA DO CAIXA
    QUANDO O VALOR TOTAL DO DETALHAMENTO FOR DIFERENTE DO 
    VALOR TOTAL DO RESUMO DE ESPECIES
*/

DO $$
DECLARE 
    l_id_empresa_lo INTEGER;
    l_id_caixapdv FK;
    l_id_especie FK;
    l_vl_total_especie VALOR;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' INTO l_id_empresa_lo;

    l_id_caixapdv = '' -- Informar codigo do caixa que deseja reprocessar
    l_id_especie = '' -- Informar CODIGO da especie que deseja reprocessar
    l_vl_total_especie = (
        SELECT SUM(l.VL_VALOR) FROM LANC l 
        WHERE l.CH_EXCLUIDO IS NULL
        AND l.ID_CAIXAPDV = l_id_caixapdv 
        AND l.ID_ESPECIE = l_id_especie
        AND l.CH_MOVCAIXA = 'T'
        AND l.CH_DEBCRE = (SELECT p.CH_NATUREZA FROM PLANOCONTA p WHERE p.ID_PLANOCONTA = l.ID_PLANOCONTA)
    ); 

    UPDATE CAIXAPDV_FEC cf SET 
    VL_VALOR = l_vl_total_especie,
    VL_VALOR_ORI = l_vl_total_especie
    WHERE cf.ID_CAIXAPDV = l_id_caixapdv
    AND cf.ID_ESPECIE = l_id_especie;

END$$;


