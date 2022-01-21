select
 c.ch_excluido EXCLUIDO,
 c.id_rectopagto ID_BAIXA,
 a.dh_lanc DATA_VENDA,
 a.dt_vencim VENCIMENTO,
 c.dt_operac DATA_OPERACAO,
 a.id_entidade CLIENTE,
 a.nr_docume DOCUMENTO,
 a.vl_valor VALOR,
 e.ds_especie ESPECIE,
 a.ch_devolvido DEVOLVIDO,
 a.id_usuario_m COD_USUARIO,
 d.ds_login USUARIO
from lanc a 
left join rectopagto_recpag b on a.id_lanc = b.id_lanc
left join rectopagto c on b.id_rectopagto = c.id_rectopagto
left join usuario d on a.id_usuario_m = d.id_usuario
left join especie e on a.id_especie = e.id_especie
    where a.id_usuario_m = '76-1'
    and b.id_empresa = '44'
    and a.id_especie in ('1-1','1-33')
    and c.dt_operac between '2019-01-01' and '2022-12-31'
    and a.id_lanc in (  select rp.id_lanc from rectopagto_recpag rp
                        left join rectopagto rc on rp.id_rectopagto = rc.id_rectopagto
                        where rp.id_empresa = '44' and rc.ch_excluido = 'T')
order by a.dt_vencim, a.nr_docume, c.id_rectopagto, c.dt_operac asc