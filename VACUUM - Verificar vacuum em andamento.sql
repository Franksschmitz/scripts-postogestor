Comando ver vacuns rodando nas bases:

select 
    *, 
    case 
        when HEAP_BLKS_TOTAL > 0 then (HEAP_BLKS_SCANNED::real / HEAP_BLKS_TOTAL::real) * 100.0 
        else 0 
    end as porcentagem_scaneada
from pg_stat_progress_vacuum



Comando para ver o pid:

select pid, datname, query from pg_stat_activity where query like 'autovacuum%';



Comando para matar o processo pelo pid:

select pg_cancel_backend(pid_retornado_da_query_anterior);