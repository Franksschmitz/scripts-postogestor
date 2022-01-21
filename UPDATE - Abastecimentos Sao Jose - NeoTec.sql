DO $$
DECLARE
  l_id_empresa INTEGER;
  idabast FK;
BEGIN
  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;

    FOR idabast IN

        SELECT id_abastecimento FROM abastecimento
            WHERE dh_emissao_aut BETWEEN '2009-01-05' AND '2009-01-13 23:59:59'
            AND ch_excluido IS NULL

    LOOP

        UPDATE abastecimento SET ch_ativo = 'T'
            WHERE id_abastecimento = idabast
            AND ch_ativo = 'F'
            AND dh_emissao_aut BETWEEN '2009-01-05' AND '2009-01-13 23:59:59';
        
        UPDATE abastecimento SET dt_emissao = '2022-01-05 06:02:02', dh_emissao_aut = '2022-01-05 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-05' AND '2009-01-05 23:59:59';

        UPDATE abastecimento SET dt_emissao = '2022-01-06 06:02:02', dh_emissao_aut = '2022-01-06 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-06' AND '2009-01-06 23:59:59';

        UPDATE abastecimento SET dt_emissao = '2022-01-07 06:02:02', dh_emissao_aut = '2022-01-07 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-07' AND '2009-01-07 23:59:59';

        UPDATE abastecimento SET dt_emissao = '2022-01-08 06:02:02', dh_emissao_aut = '2022-01-08 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-08' AND '2009-01-08 23:59:59';

        UPDATE abastecimento SET dt_emissao = '2022-01-09 06:02:02', dh_emissao_aut = '2022-01-09 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-09' AND '2009-01-09 23:59:59';

        UPDATE abastecimento SET dt_emissao = '2022-01-13 06:02:02', dh_emissao_aut = '2022-01-13 06:02:02'
            WHERE id_abastecimento = idabast
            AND dh_emissao_aut BETWEEN '2009-01-13' AND '2009-01-13 23:59:59';

    END LOOP;
END$$;