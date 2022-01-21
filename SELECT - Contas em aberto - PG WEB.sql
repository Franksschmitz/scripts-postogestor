SELECT  
    rp.ds_placa,
    d.ds_mot, 
    rp.VL_VALOR, 
    e.DS_ESPECIE, 
    emp.DS_EMPRESA, 
    rp.DT_VENCIM, 
    rp.DH_LANC DT_EMISSA, 
    rp.NR_DOCUME
FROM especie e, EMPRESA emp, PLANOCONTA p, LANC rp, DOCFISCAL_BAIXA db, docfiscal d
    WHERE rp.ID_ESPECIE = e.ID_ESPECIE 
    AND emp.ID_EMPRESA = rp.ID_EMPRESA
    AND p.ID_PLANOCONTA = rp.ID_PLANOCONTA
    AND db.ID_DOCFISCAL_BAIXA = rp.ID_DOCFISCAL_BAIXA
    AND db.ID_DOCFISCAL = d.ID_DOCFISCAL
    AND p.CH_CONT_FIN = 'R' 
    AND rp.CH_SITUAC = 'A' 
    AND rp.ID_ENTIDADE IN ('$in') 
    AND rp.CH_EXCLUIDO is null