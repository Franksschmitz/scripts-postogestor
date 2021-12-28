				select 
				   a.id_item CODIGO,
				   e.ds_item DESCRICAO,
				   case
					  when a.id_classfiscal is not null   then f.nr_ncm
				   end NCM_NOTA,
                  (
						select 
						   z.nr_cst
						from docfiscal_item t
						left join docfiscal u on t.id_docfiscal = u.id_docfiscal
						left join docfiscal_eletro v on u.id_docfiscal = v.id_docfiscal
						left join docfiscal_item_imposto x on t.id_docfiscal_item = x.id_docfiscal_item
						left join cst z on x.id_cst = z.id_cst
						where t.id_docfiscal_item = a.id_docfiscal_item
						and v.ch_sitnfe = 'R'
						and x.id_imposto = '1-1'
						and u.ch_excluido is null
						and t.ch_excluido is null
                   )  ICMS,
				   case
					  when g.id_imposto = '4-1'           then g.nr_cst
				   end PIS,
                  (
						select 
						   z.nr_cst
						from docfiscal_item t
						left join docfiscal u on t.id_docfiscal = u.id_docfiscal
						left join docfiscal_eletro v on u.id_docfiscal = v.id_docfiscal
						left join docfiscal_item_imposto x on t.id_docfiscal_item = x.id_docfiscal_item
						left join cst z on x.id_cst = z.id_cst
						where t.id_docfiscal_item = a.id_docfiscal_item
						and v.ch_sitnfe = 'R'
						and x.id_imposto = '5-1'
						and u.ch_excluido is null
						and t.ch_excluido is null
                   )  COFINS,
				   case
					  when e.id_classfiscal is not null   then f.nr_ncm
				   end NCM_CADASTRO,
				   case
					  when h.id_natrec is not null        then i.nr_natrec
					  else 'NAO CONFIGURADO'
				   end NAT_RECEITA     
				from docfiscal_item a
				left join docfiscal b on a.id_docfiscal = b.id_docfiscal
				left join docfiscal_eletro c on b.id_docfiscal = c.id_docfiscal
				left join docfiscal_item_imposto d on a.id_docfiscal_item = d.id_docfiscal_item
				left join item e on a.id_item = e.id_item
				left join classfiscal f on e.id_classfiscal = f.id_classfiscal
				left join cst g on d.id_cst = g.id_cst
				left join item_natrec h on e.id_item = h.id_item
				left join natrec i on h.id_natrec = i.id_natrec
				where c.ch_sitnfe = 'R'
				and c.ds_motivo_rej like '%NCM%'
				and d.id_imposto = '4-1'
				and a.ch_excluido is null
				and b.ch_excluido is null
				and c.ch_excluido is null
				and d.ch_excluido is null
				and h.ch_excluido is null

				Group by 1,2,3,4,5,6,7,8
				order by 2

