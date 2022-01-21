select
    l.DS_OBS, l.ID_PLANOCONTA, l.NR_DOCUME, l.CH_SITUAC, l.VL_VALOR, l.VL_SALDO,
    l.ID_FILIAL, ig.NR_GRID, p.NR_PLANOCONTA,
    asm.CONTA_CREDITAR as AS_CONTA_CREDITAR,
    asm.GRID as AS_GRID
from LANC l
inner join IMPGRID ig on (l.ID_LANC = ig.NEW_ID)
inner join PLANOCONTA p on (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
inner join (
                select * from dblink(
                                        'host=172.20.27.120 user=postgres password=12qw!@QW port=5432 dbname=rioverde', '
                                        select m.grid, m.conta_creditar, m.conta_debitar
                                        from movto m
                                        left join pessoa emp on emp.grid = m.empresa
                                        where m.child = 0
                                        and emp.codigo = 13
                                    ') as_movto (grid int8, conta_creditar text, conta_debitar text)) asm on (ig.NR_GRID = asm.GRID)
    where l.ID_PLANOCONTA = :l_id_planoconta
    and l.ID_FILIAL = :l_id_filial