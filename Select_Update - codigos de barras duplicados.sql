select count(1), 
nr_codbar 
from item
where id_item 
like '%-5'
and (nr_codbar <> '' or nr_codbar is not null)
group by nr_codbar
having count(nr_codbar) > 1


UPDATE ITEM i SET i.NR_CODBAR = null WHERE i.ID_ITEM in 
( 
  select
  a.id_item
  from item a
  join item b on (b.nr_codbar=a.nr_codbar)
  where a.id_item like '%-5%'
  and b.id_item like '%-1%'
  and a.nr_codbar <> ''
  and a.nr_codbar is not null  
)