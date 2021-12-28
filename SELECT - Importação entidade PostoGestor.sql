select
    a.id_entidade,
    a.ds_entidade,
    case 
        when a.ch_cliente = 'T' then 'C'
    end as TIPO,
    a.ds_cpfcnpj,
    a.ds_rg,
    a.ds_ie,
    a.ds_im,
    b.id_pais,
    g.ds_sigla,
    d.ds_cidade,
    b.ds_endereco,
    b.ds_numero,
    b.ds_bairro,
    b.ds_cep,
    c.ds_fone,
    c.ds_celular,
    c.ds_cargo,
    c.ds_email,
    case
        when c.ch_principal = 'T' then 'P'
    end as TIPO_2,
    d.nr_ibge,
    a.id_grupoentidade,
    sum(e.vl_limcre),
    f.id_filial,
    'Politica de Vendas',
    'Politica de Faturamento',
    case
        when a.ch_veic_obri = 'T' then 'S'
        else 'N'
    end as VEIC_OBRI,
    case
        when a.ch_placa_obri = 'T' then 'S'
        else 'N'
    end as PLACA_OBRI,
    case
        when a.ch_veic_cad = 'T' then 'S'
        else 'N'
    end as VEIC_CAD,
    case
        when a.ch_kmhm_obri = 'T' then 'S'
        else 'N'
    end as KMHM_OBRI,
    case
        when a.ch_frota_obri = 'T' then 'S'
        else 'N'
    end as FROTA_OBRI,
    case
        when a.ch_mot_obri = 'T' then 'S'
        else 'N'
    end as MOT_OBRI,
    case
        when a.ch_mot_cad = 'T' then 'S'
        else 'N'
    end as MOT_CAD,
    case
        when a.ch_comb_obri = 'T' then 'S'
        else 'N'
    end as COMB_OBRI,
    case
        when a.ch_veicmot_obri = 'T' then 'S'
        else 'N'
    end as VEICMOT_OBRI,
    case
        when a.ch_ident_obri = 'T' then 'S'
        else 'N'
    end as IDENT_OBRI
from entidade a
left join entidade_endereco b on (a.id_entidade = b.id_entidade)
left join entidade_contato c on (a.id_entidade = c.id_entidade)
left join cidade d on (b.id_cidade = d.id_cidade)
left join entidade_cred e on (a.id_entidade = e.id_entidade)
left join entidade_filial f on (a.id_entidade = f.id_entidade)
left join estado g on (b.id_estado = g.id_estado) 
    where a.ch_excluido is null
    and a.ch_ativo = 'T'
    and b.ch_excluido is null
    and c.ch_excluido is null
    and d.ch_excluido is null
    and e.ch_excluido is null
    and f.ch_excluido is null

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,31,32,33,34,35
order by 2 asc