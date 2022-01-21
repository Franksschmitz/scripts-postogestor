select 
    ds_tipo_ope,
    ds_cartao,
    nr_bandeira,
    ds_carteiradig,
    nr_carteiradig,
    a.nr_operatef,
    b.ds_operatef,
    count(*) 
from tef_ope a
left join operatef b on a.id_operatef = b.id_operatef
    where a.id_cartaotef = '1-1'
    and ds_ope <> 'ADM'
group by 1,2,3,4,5,6,7
order by 2

--------------------

SELECT id_cartaotef,id_operatef,id_planoconta,* FROM lanc
  WHERE ch_excluido IS NULL
  AND ch_tipo_especie = 'T'
  AND id_docfiscal = '588-2'

-------------------

SELECT COUNT(*) FROM lanc
  WHERE ch_excluido IS NULL
  AND id_planoconta IS NULL
  AND id_docfiscal IN ( SELECT id_docfiscal FROM docfiscal_baixa 
                          WHERE id_cartaotef IS NULL
                          AND id_operatef IS NULL
                          AND ch_tipo_especie = 'T'
                          AND ch_operac = 'B'
                          AND ch_excluido IS NULL )

-------------------

SELECT COUNT(*) FROM docfiscal_baixa
  WHERE ds_usuario = 'POSTGRES'
  AND ch_excluido IS NULL
  AND id_cartaotef IS NULL
  AND ch_operac = 'B'
  AND ch_tipo_especie = 'T'