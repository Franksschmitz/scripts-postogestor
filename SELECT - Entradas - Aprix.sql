select 
    a.ID_ABASTECIMENTO as ID_ABASTECIMENTO,
    a.ID_EMPRESA as ID_EMPRESA,
    a.ID_SEQ as ID_SEQ,
    a.REC_VERSION as REC_VERSION,
    a.ID_BICO as ID_BICO,
    a.QT_ABASTECIMENTO as QT_ABASTECIMENTO,
    a.VL_ABASTECIMENTO as VL_ABASTECIMENTO,
    a.VL_PRECO as VL_PRECO,
    a.DT_EMISSAO as DT_EMISSAO,
    a.QT_ENCERRANTE_INI as QT_ENCERRANTE_INI,
    a.QT_ENCERRANTE_FIM as QT_ENCERRANTE_FIM,
    a.NR_SEQUENCIAL_AUT as NR_SEQUENCIAL_AUT,
    a.ID_ITEM as ID_ITEM,
    a.ID_RFID_OPERADOR as ID_RFID_OPERADOR,
    a.ID_RFID_CLIENTE as ID_RFID_CLIENTE,
    a.QT_TEMPO_SEG as QT_TEMPO_SEG,
    a.CH_SITUAC as CH_SITUAC,
    i.DS_ITEM_RED as DS_ITEM_RED,
    a.ID_BOMBA as ID_BOMBA,
    eo.DS_ENTIDADE as DS_ENTIDADE_OPE,
    ec.DS_ENTIDADE as DS_ENTIDADE_CLI,
    a.NR_BICO as NR_BICO,
    ro.ID_ENTIDADE as ID_ENTIDADE_OPE,
    ec.ID_ENTIDADE as ID_ENTIDADE_CLI,
    case 
        when a.ID_RFID_OPERADOR is not null
            then (
                select u.ID_USUARIO
                from USUARIO u
                where u.ID_ENTIDADE = eo.ID_ENTIDADE
                    and u.CH_EXCLUIDO is null
                    and u.CH_ATIVO = 'T'
                order by u.ID_SEQ limit 1
            )
        else null
    end as ID_USUARIO,
    case 
        when a.ID_RFID_OPERADOR is not null
            then (
                select u.DS_LOGIN
                from USUARIO u
                where u.ID_ENTIDADE = eo.ID_ENTIDADE
                    and u.CH_EXCLUIDO is null
                    and u.CH_ATIVO = 'T'
                order by u.ID_SEQ limit 1
            )
        else null
    end as DS_LOGIN,
    ev.ID_ENTIDADE_VEIC as ID_ENTIDADE_VEIC,
    ev.DS_PLACA as DS_PLACA,
    mot.DS_MOT as DS_MOT,
    a.NR_NFMANUAL as NR_NFMANUAL,
    a.DS_SERIE_NFMANUAL as DS_SERIE_NFMANUAL,
    a.DS_MODELO_NFMANUAL as DS_MODELO_NFMANUAL,
    rc.ID_ENTIDADE_MOT as ID_ENTIDADE_MOT,
    a.CH_SITMOVEL as CH_SITMOVEL,
    a.DH_EMISSAO_AUT as DH_EMISSAO_AUT,
    a.ID_LOCALARM as ID_LOCALARM
from ABASTECIMENTO a
left join ITEM i on i.ID_ITEM = a.ID_ITEM
left join RFID ro on ro.ID_RFID = a.ID_RFID_OPERADOR
left join RFID rc on rc.ID_RFID = a.ID_RFID_CLIENTE
left join ENTIDADE eo on eo.ID_ENTIDADE = ro.ID_ENTIDADE
left join ENTIDADE ec on ec.ID_ENTIDADE = coalesce(rc.ID_ENTIDADE, a.ID_ENTIDADE)
left join LOCALARM l on l.ID_LOCALARM = a.ID_LOCALARM
left join BOMBA bo on bo.ID_BOMBA = a.ID_BOMBA
left join BICO bi on bi.ID_BICO = a.ID_BICO
left join ENTIDADE_VEIC ev on ev.ID_ENTIDADE_VEIC = coalesce(rc.ID_ENTIDADE_VEIC, a.ID_ENTIDADE_VEIC)
left join ENTIDADE_MOT mot on mot.ID_ENTIDADE_MOT = rc.ID_ENTIDADE_MOT
where (a.CH_EXCLUIDO is null)
  and (
    a.CH_SITUAC = 'P'
    and a.CH_ATIVO = 'T'
    and bo.ID_FILIAL = :ID_FILIAL
    )
order by a.DT_EMISSAO desc