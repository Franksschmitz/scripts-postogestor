--Ajustar Data para Atual para sefaz aceitar o XML:

--Testar um documento:
update docfiscal set dh_emissa='2021-01-18 10:00:00',dt_emissa='2021-01-18',hr_emissa='10:00:00' where id_docfiscal='650-1'


update docfiscal set 
    dh_emissa = CURRENT_TIMESTAMP, 
    dt_emissa = CURRENT_DATE, 
    hr_emissa = CURRENT_TIME,
    dt_saida = CURRENT_DATE,
    hr_saida = CURRENT_TIME
where id_docfiscal in (select id_docfiscal from docfiscal_eletro where ch_sitnfe= 'R')
and id_filial = :id_filial


-- Alterar todos rejeitados para data atual:
update docfiscal set dh_emissa='2021-01-18 13:48:00',dt_emissa='2021-01-18',hr_emissa='13:48:00' where id_docfiscal in (select id_docfiscal from docfiscal_eletro where ch_sitnfe='R')