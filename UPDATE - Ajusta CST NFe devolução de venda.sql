/* UPDATE para alterar CST, valor, base e aliquota do imposto desejado */

update docfiscal_item_imposto set id_cst = '180-1', vl_imposto = '0', vl_base= '0', al_imposto = '0'
where id_imposto = '5-1'
and id_docfiscal_item_imposto in ( select a.id_docfiscal_item_imposto from docfiscal_item_imposto a
                                      left join docfiscal b on a.id_docfiscal = b.id_docfiscal
                                      where b.id_tipolanc = '1-1'
                                      and a.id_cst in ('115-1','148-1')
                                      and b.dh_emissa between '2021-06-01' and '2021-06-30 23:59:59'    )