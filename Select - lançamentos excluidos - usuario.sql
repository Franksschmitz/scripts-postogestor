

select
  a.dh_lanc DIA,
  a.id_lanc CODIGO,
  case 
     when a.ch_excluido = 'T'  then 'SIM'
	 when a.ch_excluido <> 'T' then 'NAO'
  end EXCLUIDO,	
  b.ds_nome NOME_USUARIO,
  b.ds_login LOGIN_USUARIO,  
  c.ds_tipolanc TIPO_LANCTO,
  d.ds_especie ESPECIE,
  a.vl_valor VALOR  
from lanc a
left join usuario b on (a.id_usuario_m = b.id_usuario)
left join tipolanc c on (a.id_tipolanc = c.id_tipolanc)
left join especie d on (a.id_especie = d.id_especie)
where a.id_tipolanc = 'CODIGO TIPO LANCTO'
and a.id_especie = 'CODIGO ESPECIE'
and a.vl_valor between 'VALOR INI' and 'VALOR FIM'
and dh_lanc between 'DATA INI' and 'DATA FIM'


