SELECT
    z.*
FROM (
				select 
					x.operador,
					case
						when x.mes in ('1','2','3','4','5','6','7','8','9') then '0' || x.dia || '/' || '0' || x.mes
						when x.dia in ('1','2','3','4','5','6','7','8','9') then '0' || x.dia || '/' || x.mes
						else x.dia || '/' || x.mes
					end as DATA_AUTOMACAO,
					x.qtd,
					x.total					
				from (

								select 
								  extract('day' from (date_trunc('day', a.dh_emissao_aut))) as DIA, 
								  extract('month' from (date_trunc('month', a.dh_emissao_aut))) as MES,
								  sum(a.qt_abastecimento) as QTD,
								  sum (a.vl_abastecimento) AS TOTAL, 
								  a.id_rfid_operador as ID_RFID,
								  b.nr_tag as NR_RFID,
								  c.ds_entidade as OPERADOR  
								from abastecimento a
								left join rfid b on a.id_rfid_operador = b.id_rfid
								left join entidade c on b.id_entidade = c.id_entidade
									where a.ch_excluido is null 
									and a.ch_ativo='T' 
									and a.dh_emissao_aut between '2020-11-01' and '2020-11-06 23:59:59'
									group by 1,2,5,6,7
									order by 7,2,1
					) x
					
					
		) z