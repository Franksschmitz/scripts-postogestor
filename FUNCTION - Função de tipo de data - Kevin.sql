create or replace function isdate(dt text) 
returns text as $$
begin
     if (dt is null) then
         return 'F';
     end if;     
     perform dt::date;     
     return 'T';
exception when others then
     return 'F';
end;
$$ language plpgsql;

-----------

select * 
from LANC l 
where l.CH_EXCLUIDO is null and 
    l.VL_SALDO > 0 and 
    --l.DS_OBS = 'REGISTRO IMPORTADO' and 
    isdate(l.DH_LANC::text) = 'F'
limit 10