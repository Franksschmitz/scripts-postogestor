select
  b.id_nft_ct,
  cast((a.nr_notafi) as numeric(30)),
  a.dt_saicheg
from nft a
left join nft_ctnf b on a.id_nft = b.id_nft_ct
    where a.id_filial =:Empresa
    and a.nr_notafi =:Numero_CTE
    and a.ch_excluido is null
    and b.ch_excluido is null