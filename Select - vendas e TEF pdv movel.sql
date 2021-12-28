-- QUERY VENDAS E TEF PDV MOVEL:

-- OP. TEF:

select tt.* 
from tef t
join tef_ope tt on tt.id_tef = t.id_tef
where t.id_pontovenda in (select id_pontovenda from pontovenda where ch_tipo_pdv = 'M')


-- VENDAS:

select *
from docfiscal d
where d.id_pontovenda in (select id_pontovenda from pontovenda where ch_tipo_pdv = 'M')