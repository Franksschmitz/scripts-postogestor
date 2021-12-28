DO $$
DECLARE
BEGIN

    DELETE FROM transftitulo;
    DELETE FROM conciliacao_movi;
    DELETE FROM conciliacao;
    DELETE FROM lanc_det;
    DELETE FROM compcheq_recpag;
    DELETE FROM compcheq;
    DELETE FROM docfiscal_item_comp;
    DELETE FROM docfiscal_item_cfgfiscal;
    DELETE FROM docfiscal_item_comiss;
    DELETE FROM docfiscal_item_infadic;
    DELETE FROM docfiscal_item_imposto;
    DELETE FROM docfiscal_item_plano;
    DELETE FROM docfiscal_reparc;
    DELETE FROM docfiscal_prevenda;
    DELETE FROM docfiscal_obs;
    DELETE FROM docfiscal_imposto;
    DELETE FROM docfiscal_infadic;
    DELETE FROM docfiscal_baixa_hist;
    DELETE FROM docfiscal_baixa_parc;
    DELETE FROM rectopagto_recpag;
    DELETE FROM tef_ope;
    DELETE FROM tef;
    DELETE FROM rectopagto_baixa;
    DELETE FROM docfiscal;
    DELETE FROM docfiscal_docref;
    DELETE FROM docfiscal_eletro;
    DELETE FROM docfiscal_item;
    DELETE FROM rectopagto;
    DELETE FROM reparc_recpag;
    DELETE FROM reparc_obs;
    DELETE FROM reparc_cencus;
    DELETE FROM reparc_docfiscal;
    DELETE FROM reparc;
    DELETE FROM lanc_comiss_bai;
    DELETE FROM lanc_comiss;
    DELETE FROM lanc_hist;
    DELETE FROM lanc_ban;
    DELETE FROM lanc;

END$$;