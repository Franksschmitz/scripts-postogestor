select r.ID_REPARC, r.ID_GERAFAT, r.ID_ENTIDADE, e.DS_ENTIDADE, e.DS_OBSFATURAS, r.DT_EMISSA, 
       r.VL_DESCON, r.VL_OUTRAS, r.VL_JURATR, r.VL_TOTSEL,
       r.VL_TOTAL, r.CH_TIPO, r.DS_OBS, cp1.DS_CONDPAG1,
       r.DS_PLACA, r.NR_FROTA, mot.DS_MOT, (select ev.DS_VEIC from ENTIDADE_VEIC ev where ev.CH_EXCLUIDO is null and ev.ID_ENTIDADE = r.ID_ENTIDADE and ev.DS_PLACA = r.DS_PLACA) as DS_VEIC,
       entemp.DS_RAZAO as DS_EMPRESA, eendemp.DS_ENDERECO as ENDER_EMPRESA, eendemp.DS_NUMERO as NUME_EMPRESA,
       eendemp.DS_BAIRRO as BAIRRO_EMPRESA, eendemp.DS_CEP as CEP_EMPRESA, cidemp.DS_CIDADE as CIDADE_EMPRESA, estemp.DS_SIGLA as UF_EMPRESA,
       entemp.DS_CPFCNPJ as CNPJ_EMPRESA, entemp.DS_IE as IE_EMPRESA,
       eend.DS_ENDERECO as ENDER_ENTID, eend.DS_NUMERO as NUME_ENTID,
       eend.DS_BAIRRO as BAIRRO_ENTID, eend.DS_CEP as CEP_ENTID, cid.DS_CIDADE as CIDADE_ENTID, est.DS_SIGLA as UF_ENTID,
       e.DS_CPFCNPJ as CPFCNPJ_ENTID, e.DS_IE as IE_ENTID, econ.DS_CODAREA as DDD_ENTID, econ.DS_FONE as FONE_ENTID,
       r.VL_TOTAL as VL_TOTAL_EXTENSO, r.VL_ACRES,
       entemp.ID_ENTIDADE as ID_ENTIDADE_EMPRESA,
       emp.CH_EXIBE_CONTARELFAT
from REPARC r
left join ENTIDADE e on e.ID_ENTIDADE = r.ID_ENTIDADE
left join ENTIDADE_ENDERECO eend on eend.ID_ENTIDADE = e.ID_ENTIDADE
left join CIDADE cid on cid.ID_CIDADE = eend.ID_CIDADE
left join ESTADO est on est.ID_ESTADO = cid.ID_ESTADO
left join ENTIDADE_CONTATO econ on econ.ID_ENTIDADE = e.ID_ENTIDADE
left join CONDPAG1 cp1 on cp1.ID_CONDPAG1 = r.ID_CONDPAG1
left join ENTIDADE_MOT mot on mot.ID_ENTIDADE_MOT = r.ID_ENTIDADE_MOT
left join EMPRESA emp on emp.ID_EMPRESA = r.ID_FILIAL
left join ENTIDADE entemp on entemp.ID_ENTIDADE = emp.ID_ENTIDADE
left join ENTIDADE_ENDERECO eendemp on eendemp.ID_ENTIDADE = entemp.ID_ENTIDADE
left join CIDADE cidemp on cidemp.ID_CIDADE = eendemp.ID_CIDADE
left join ESTADO estemp on estemp.ID_ESTADO = cidemp.ID_ESTADO
    where r.CH_EXCLUIDO is null
    and r.CH_TIPO = 'F'
    and eendemp.CH_PRINCIPAL = 'T' 
    and eendemp.CH_EXCLUIDO is null
    and econ.CH_PRINCIPAL = 'T' 
    and econ.CH_EXCLUIDO is null
    and eend.CH_PRINCIPAL = 'T'
    and eend.CH_EXCLUIDO is null
    and r.ID_GERAFAT in ('2205-5')
order by e.DS_ENTIDADE, r.DT_EMISSA, r.ID_REPARC

-------------------------------------------------------------------------------------------

select r.NR_DOCUME, r.DT_VENCIM, r.VL_VALOR, esp.DS_ESPECIE, r.ID_LANC
from LANC r
left join ESPECIE esp on esp.ID_ESPECIE = r.ID_ESPECIE
left join PLANOCONTA p on p.ID_PLANOCONTA = r.ID_PLANOCONTA  
where r.ID_REPARC = :ID_REPARC and
      (p.CH_NATUREZA = r.CH_DEBCRE) and p.CH_CONT_FIN in ('P', 'R')
order by r.ID_SEQ

-------------------------------------------------------------------------------------------

select b.NR_BANCO,
       b.DS_BANCO,
       ec.NR_AGENCIA, 
       ec.NR_CONTA,
       ec.DS_TITULAR,
       ec.DS_CPFCNPJ 
from ENTIDADE_CONTA ec
left join BANCO b on b.ID_BANCO = ec.ID_BANCO
where ec.CH_EXCLUIDO is null and
      ec.ID_ENTIDADE = :ID_ENTIDADE_EMPRESA

-------------------------------------------------------------------------------------------

select gob.DS_TEXTOOBS
from REPARC r
inner join GERAFAT_OBS gob on gob.ID_GERAFAT = r.ID_GERAFAT
where r.CH_EXCLUIDO is null and
      gob.CH_EXCLUIDO is null and
      r.ID_REPARC = :ID_REPARC
order by gob.ID_SEQ

-------------------------------------------------------------------------------------------

select rd.ID_REPARC_DOCFISCAL,
       d.DS_PLACA as DS_AGRUPADOR,
       d.NR_DOCFISCAL,
       d.DT_EMISSA,
       d.HR_EMISSA,
       d.DS_PLACA,
       d.DS_MOT,
       d.DS_VEIC,
       sum(di.QT_ITEM) as QT_ITEM,
       d.VL_KMHM_ANT,
       d.VL_KMHM,
       case when i.CH_COMBUSTIVEL = 'T' then (cast(d.VL_KMHM - coalesce(d.VL_KMHM_ANT,0) as decimal(18,4)) / di.QT_ITEM) else 0 end as MediaKM_L,
       di.DS_ITEM,
       di.VL_UNITAR,
       sum(di.VL_DESCON_ITEM) as VL_DESCON_ITEM,
       sum(di.VL_ACRES_ITEM) as VL_ACRES_ITEM,
       sum(di.VL_CONTABIL) as VL_CONTABIL,
       string_agg(cast((
         select string_agg(coalesce(o.NR_ORDABAST, o.ID_ORDABAST), ',')
         from DOCFISCAL_ITEM_ORDABAST d_
         left join ORDABAST_ITEM oi on oi.ID_ORDABAST_ITEM = d_.ID_ORDABAST_ITEM
         left join ORDABAST o on o.ID_ORDABAST = oi.ID_ORDABAST
         where d_.ID_DOCFISCAL_ITEM = di.ID_DOCFISCAL_ITEM and
               d_.CH_EXCLUIDO is null
       ) as varchar(1000)), ',') as NR_ORDABAST,
       d.NR_PEDIDO
from REPARC_DOCFISCAL rd
left join DOCFISCAL d on d.ID_DOCFISCAL = rd.ID_DOCFISCAL
left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
left join ITEM i on i.ID_ITEM = di.ID_ITEM 
where rd.ID_REPARC = :ID_REPARC and
      rd.CH_EXCLUIDO is null and
      di.CH_EXCLUIDO is null
group by 1,2,3,4,5,6,7,8,10,11,12,13,14,19
      
union all

select rp.ID_REPARC_RECPAG,
       r.DS_PLACA as DS_AGRUPADOR,
       cast(null as integer) as NR_DOCFISCAL,
       cast(r.DH_LANC as DATE),
       cast(r.DH_LANC as TIME),
       r.DS_PLACA,
       cast(null as nomes) as DS_MOT,
       cast(null as nomes) as DS_VEIC,
       cast(null as quantidade) as QT_ITEM,
       cast(null as quantidade) as VL_KMHM_ANT,
       cast(null as quantidade) as VL_KMHM,
       cast(null as quantidade) as MediaKM_L,
       cast(e.DS_ESPECIE as nomes) as DS_ITEM,
       cast(null as valor_unit) as VL_UNITAR,
       cast(null as valor_unit) as VL_DESCON_ITEM,
       cast(null as valor_unit) as VL_ACRES_ITEM,
       r.VL_VALOR as VL_CONTABIL,
       cast(null as varchar(1000)) as NR_ORDABAST,
       cast(null as varchar(1000)) as NR_PEDIDO
from REPARC_RECPAG rp      
left join LANC r on r.ID_LANC = rp.ID_LANC
left join ESPECIE e on e.ID_ESPECIE = r.ID_ESPECIE
where rp.ID_REPARC = :ID_REPARC and
      r.ID_DOCFISCAL is null and
      rp.CH_EXCLUIDO is null

union all
      
select distinct null,
       d.DS_PLACA as DS_AGRUPADOR,
       d.NR_DOCFISCAL,
       d.DT_EMISSA,
       d.HR_EMISSA,
       d.DS_PLACA,
       d.DS_MOT,
       d.DS_VEIC,
       di.QT_ITEM,
       d.VL_KMHM_ANT,
       d.VL_KMHM,
       case when i.CH_COMBUSTIVEL = 'T' then (cast(d.VL_KMHM - coalesce(d.VL_KMHM_ANT,0) as decimal(18,4)) / di.QT_ITEM) else 0 end as MediaKM_L,
       di.DS_ITEM,
       di.VL_UNITAR,
       di.VL_DESCON_ITEM,
       di.VL_ACRES_ITEM,
       di.VL_CONTABIL,
       cast((
         select string_agg(coalesce(o.NR_ORDABAST, o.ID_ORDABAST), ',')
         from DOCFISCAL_ITEM_ORDABAST d_
         left join ORDABAST_ITEM oi on oi.ID_ORDABAST_ITEM = d_.ID_ORDABAST_ITEM
         left join ORDABAST o on o.ID_ORDABAST = oi.ID_ORDABAST
         where d_.ID_DOCFISCAL_ITEM = di.ID_DOCFISCAL_ITEM and
               d_.CH_EXCLUIDO is null
       ) as varchar(1000)) as NR_ORDABAST,
       d.NR_PEDIDO
from REPARC_RECPAG rp
left join LANC r on r.ID_LANC = rp.ID_LANC
left join DOCFISCAL d on d.ID_DOCFISCAL = r.ID_DOCFISCAL
left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
left join ITEM i on i.ID_ITEM = di.ID_ITEM 
where rp.ID_REPARC = :ID_REPARC and
      rp.CH_EXCLUIDO is null and
      di.CH_EXCLUIDO is null and
      r.ID_DOCFISCAL is not null and
      not exists (select 1 from REPARC_DOCFISCAL rd where rd.id_reparc = rp.id_REPARC and rd.id_docfiscal = r.id_docfiscal and rd.CH_EXCLUIDO is null)
        
order by DS_PLACA asc,NR_DOCFISCAL asc

-------------------------------------------------------------------------------------------

select ID_ITEM,
       DS_ITEM,
       sum(QT_ITEM) as QT_ITEM,
       sum(VL_CONTABIL) as VL_CONTABIL
from (
  select di.ID_ITEM,
         di.DS_ITEM,
         di.QT_ITEM as QT_ITEM,
         di.VL_CONTABIL as VL_CONTABIL
  from REPARC_DOCFISCAL rd
  left join DOCFISCAL d on d.ID_DOCFISCAL = rd.ID_DOCFISCAL
  left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL 
  where rd.ID_REPARC = :ID_REPARC and
        rd.CH_EXCLUIDO is null and
        di.CH_EXCLUIDO is null
        
  union all
  
  select ID_ITEM,
         DS_ITEM,
         QT_ITEM,
         VL_CONTABIL
  from (    
    select distinct di.ID_DOCFISCAL_ITEM,
                    di.ID_ITEM,
                    di.DS_ITEM,
                    di.QT_ITEM,
                    di.VL_CONTABIL
    from REPARC_RECPAG rp
    left join LANC r on r.ID_LANC = rp.ID_LANC
    left join DOCFISCAL d on d.ID_DOCFISCAL = r.ID_DOCFISCAL
    left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
    left join ITEM i on i.ID_ITEM = di.ID_ITEM 
    where rp.ID_REPARC = :ID_REPARC and
          rp.CH_EXCLUIDO is null and
          di.CH_EXCLUIDO is null and
          r.ID_DOCFISCAL is not null and
          not exists(select 1 from REPARC_DOCFISCAL rd
                     where rd.id_reparc = rp.id_REPARC and
                           rd.id_docfiscal = r.id_docfiscal and
                           rd.CH_EXCLUIDO is null)
  ) as doc_ja_ref
) sub
group by 1,2
order by 2