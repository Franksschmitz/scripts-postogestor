-- Comandos para remover configurações fiscais - por grupo

-- Grupo simples

UPDATE item_cfgfiscal SET ch_excluido = 'T'
    WHERE ch_excluido IS NULL
    AND ch_tipocfg = 'P'
    AND id_item IN ( SELECT id_item FROM item WHERE id_grupoitem IN ('','',''));

-- Quando for grupo pai

UPDATE item_cfgfiscal SET ch_excluido = 'T'
    WHERE ch_excluido IS NULL
    AND ch_tipocfg = 'P'
    AND id_item IN ( SELECT id_item FROM item WHERE id_grupoitem IN (SELECT id_grupoitem FROM grupoitem WHERE id_pai IN ('128-5','179-5') );

-- Grupo simples e grupo pai

UPDATE item_cfgfiscal SET ch_excluido = 'T'
    WHERE ch_excluido IS NULL
    AND ch_tipocfg = 'P'
    AND id_item IN ( SELECT id_item FROM item 
                        WHERE id_grupoitem IN (SELECT id_grupoitem FROM grupoitem 
                                                  WHERE id_pai IN ('271-5','265-5') ) OR id_grupoitem IN ('267-5','268-5','236-9'));



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Alteração de número da prioridade da config fiscal no item

-- Comando para verificar quantos itens estão com aquela prioridade configurada

SELECT COUNT(*) FROM item_cfgfiscal
    WHERE ch_tipocfg = 'P'
    AND nr_prioridade = 2
    AND ch_excluido IS NULL
    AND id_item NOT IN ( SELECT id_item FROM item WHERE ch_combustivel = 'T' );
    
-- Comando para alterar a prioridade

UPDATE item_cfgfiscal SET nr_prioridade = 10
    WHERE ch_tipocfg = 'P'
    AND nr_prioridade = 2
    AND ch_excluido IS NULL
    AND id_item NOT IN ( SELECT id_item FROM item WHERE ch_combustivel = 'T' );


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------