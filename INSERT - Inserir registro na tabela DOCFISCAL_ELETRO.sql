DO $$
DECLARE
    empresa_lo INTEGER;
    idseq BIGINT;
    iddoc FK;
BEGIN
    SELECT id_empresa$lo FROM empresa$lo WHERE ch_local = 'T' LIMIT 1 INTO empresa_lo;

    iddoc = '43-1';

    idseq = NEXTVAL('gen_docfiscal_eletro');

    INSERT INTO docfiscal_eletro (id_docfiscal_eletro, id_empresa, id_seq, ch_excluido, ds_usuario, id_docfiscal, ch_sitnfe, nr_recibo, dh_recibo, cd_status, id_lote_eletro, ds_chave, nr_aleatorio, ds_motivo, ds_digest, dh_recibo_can, nr_recibo_can, bl_xmlnfe, bl_xmlprot, bl_xmlpedcan, bl_xmlretcan, ds_link_nfce, ch_modoemi, ch_cancelar, bl_xmlpedepec, bl_xmlretepec, dh_recibo_epec, nr_recibo_epec, ch_conc_epec, ch_sitepec, ch_email_enviado, ch_envia_email, ds_motivo_rej, ds_md5_paf, ch_cont_off, ds_ass_qrcode, ds_ass_qrcode_can, nr_serie_sat, nr_tentativa, dt_ult_tentativa, ch_canc_fiscal, ch_erro, ds_erro, nr_msg, ds_msg)
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', iddoc, 'R', NULL, '2022-01-02 15:55:04', '871', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'O', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'F', NULL, NULL, 'T', NULL, NULL, NULL, '5', '2022-01-03 14:00:00', NULL, NULL, NULL, NULL, NULL);
        
END$$