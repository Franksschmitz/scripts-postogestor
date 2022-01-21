select l.DH_LANC,
       l.ID_PLANOCONTA, 
       p.NR_PLANOCONTA,
       p.DS_PLANOCONTA,
       coalesce(det.VL_VALOR, l.VL_VALOR) as VL_VALOR, 
       l.ID_LANC, 
       coalesce(l_ori.NR_DOCUME, l.NR_DOCUME) as NR_DOCUME, 
       l.ID_HISTORICO, 
       l.DS_HISTORICO,
       p.CH_ENTIDADE, 
       coalesce(p_ori.CH_CONT_FIN, reparc.CH_RECPAG) as CH_RECPAG, 
       coalesce(l_ori.ID_ENTIDADE, reparc.ID_ENTIDADE, l.ID_ENTIDADE) as ID_ENTIDADE,
       l.ID_RECTOPAGTO, 
       l.ID_REPARC,
       ent.DS_ENTIDADE,
       ent.ID_HISTORICO_C as ID_HISTORICO_ENTIDADE_C,
       h_ec.DS_HISTORICO as DS_HISTORICO_ENTIDADE_C,
       ent.ID_HISTORICO_D as ID_HISTORICO_ENTIDADE_D,
       h_ed.DS_HISTORICO as DS_HISTORICO_ENTIDADE_D,
       cam.DS_IDENT as DS_IDENT_CAMPO,
       esp_ori.CH_TIPO as CH_ESPECIE_ORI,
       l.CH_DEBCRE,
       l.ID_CONCILIACAO,
       case when l.ID_CONCILIACAO is not null then
         (select ID_CARTAOTEF 
         from CARTAOTEF ct
         where ct.ID_PLANOCONTA = l.ID_PLANOCONTA and
               ct.CH_EXCLUIDO is null and
               ct.CH_ATIVO = 'T'
         limit 1)
       else null end as ID_CARTAOTEF,
       case when l.ID_CONCILIACAO is not null then
         (select ct.ID_HISTORICO 
         from CARTAOTEF ct
         where ct.ID_PLANOCONTA = l.ID_PLANOCONTA and
               ct.CH_EXCLUIDO is null and
               ct.CH_ATIVO = 'T'
         limit 1)
       else null end as ID_HISTORICO_CARTAO,
       case when l.ID_CONCILIACAO is not null then
         (select h.DS_HISTORICO 
         from CARTAOTEF ct   
         left join HISTORICO h on h.ID_HISTORICO = ct.ID_HISTORICO
         where ct.ID_PLANOCONTA = l.ID_PLANOCONTA and
               ct.CH_EXCLUIDO is null and
               ct.CH_ATIVO = 'T'
         limit 1)
       else null end as DS_HISTORICO_CARTAO,
       l_ori.DH_LANC as DH_LANC_ORI,
       coalesce(d.NR_DOCFISCAL, nt.NR_NOTAFI) as NR_DOCFISCAL,
       case when det.ID_LANC_DET is not null then 'T' else 'F' end as LANC_BAIXA,
       (select l_.ID_PLANOCONTA from LANC l_ 
        where l_.CH_EXCLUIDO is null and
              l_.ID_AGRU = l.ID_AGRU and 
              l_.ID_LANC <> l.ID_LANC and 
              l_.CH_DEBCRE <> l.CH_DEBCRE
        order by l_.ID_SEQ
        limit 1
        ) as ID_PLANOCONTA_CONTRA,  
       (select p_.DS_PLANOCONTA from LANC l_
        left join PLANOCONTA p_ on p_.ID_PLANOCONTA = l_.ID_PLANOCONTA  
        where l_.CH_EXCLUIDO is null and
              l_.ID_AGRU = l.ID_AGRU and 
              l_.ID_LANC <> l.ID_LANC and 
              l_.CH_DEBCRE <> l.CH_DEBCRE
        order by l_.ID_SEQ
        limit 1
        ) as DS_PLANOCONTA_CONTRA,
        (select p_.CH_ENTIDADE from LANC l_
        left join PLANOCONTA p_ on p_.ID_PLANOCONTA = l_.ID_PLANOCONTA  
        where l_.CH_EXCLUIDO is null and
              l_.ID_AGRU = l.ID_AGRU and 
              l_.ID_LANC <> l.ID_LANC and 
              l_.CH_DEBCRE <> l.CH_DEBCRE
        order by l_.ID_SEQ
        limit 1
        ) as CH_ENTIDADE_CONTRA,
        (select count(1) from LANC l_ where l_.ID_AGRU = l.ID_AGRU and l_.CH_EXCLUIDO is null and l_.CH_DEBCRE = 'C') as QT_CREDITOS,
        (select count(1) from LANC l_ where l_.ID_AGRU = l.ID_AGRU and l_.CH_EXCLUIDO is null and l_.CH_DEBCRE = 'D') as QT_DEBITOS,
        ent.DS_CPFCNPJ as DS_CPFCNPJ_ENT                 
from LANC l
left join LANC_DET det on det.ID_LANC = l.ID_LANC
left join PLANOCONTA p on p.ID_PLANOCONTA = l.ID_PLANOCONTA
left join LANC l_ori on l_ori.ID_LANC = det.ID_LANC_BAI
left join REPARC reparc on reparc.ID_REPARC = l.ID_REPARC
left join RETORNOBAN ret on ret.ID_RETORNOBAN = l.ID_RETORNOBAN
left join ENTIDADE ent on ent.ID_ENTIDADE = coalesce(l_ori.ID_ENTIDADE, reparc.ID_ENTIDADE, l.ID_ENTIDADE)
left join HISTORICO h_ec on h_ec.ID_HISTORICO = ent.ID_HISTORICO_C
left join HISTORICO h_ed on h_ed.ID_HISTORICO = ent.ID_HISTORICO_D
left join PLANOCONTA p_ori on p_ori.ID_PLANOCONTA = l_ori.ID_PLANOCONTA
left join CAMPO cam on cam.ID_CAMPO = det.ID_CAMPO
left join ESPECIE esp_ori on esp_ori.ID_ESPECIE = coalesce(l_ori.ID_ESPECIE, l.ID_ESPECIE)
left join DOCFISCAL d on d.ID_DOCFISCAL = coalesce(l_ori.ID_DOCFISCAL, l.ID_DOCFISCAL)
left join NFT nt on nt.ID_NFT = coalesce(l_ori.ID_NFT, l.ID_NFT)  
where l.DH_LANC between :DT_INI and :DT_FIM and
      l.CH_EXCLUIDO is null and
      det.CH_EXCLUIDO is null and
      coalesce(det.VL_VALOR, l.VL_VALOR) > 0
     and l.ID_FILIAL in ('2') and ((l.ID_PLANOCONTA in ('561-1')) or 
     (exists(select 1 from LANC l_ where l_.ID_AGRU = l.ID_AGRU and l_.CH_EXCLUIDO is null and l_.ID_PLANOCONTA in ('561-1'))))
order by l.DH_LANC, l.ID_SEQ, det.ID_SEQ