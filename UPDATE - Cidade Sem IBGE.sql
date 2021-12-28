update ENTIDADE_ENDERECO ee set 
    ID_CIDADE = coalesce((
        select c.ID_CIDADE from CIDADE c 
        where c.ID_CIDADE <> ee.ID_CIDADE
        and c.NR_IBGE is not null 
        and unaccent(c.DS_CIDADE) = (
            select upper(unaccent(_c.DS_CIDADE)) from CIDADE _c 
            where _c.ID_CIDADE = ee.ID_CIDADE
        ) 
        limit 1), ID_CIDADE)
where ee.ID_CIDADE in (select ID_CIDADE from CIDADE where NR_IBGE is null)

-- rodar primeiro
select count(1) from ENTIDADE_ENDERECO ee 
where ee.ID_CIDADE in (select ID_CIDADE from CIDADE where NR_IBGE is null)