/*
* Seta como excluido ITEM_PRECO duplicados.
* Logica:
*   se o primeiro preço encontrado estiver 0 : exclui;
*   se não : exclui o segundo preço encontrado;
*/
UPDATE ITEM_PRECO i SET 
    CH_EXCLUIDO = 'T'
WHERE i.CH_EXCLUIDO IS NULL AND 
    i.ID_FILIAL = :ID_FILIAL AND 
    i.ID_ITEM_PRECO IN (
        SELECT s.ITEM_PRECO
        FROM (
            SELECT 
                COUNT(ip.ID_TIPOPRECO), ip.ID_ITEM, ip.ID_FILIAL,
                (
                    SELECT 
                        CASE 
                            WHEN (ip.VL_PRECO = 0) THEN ip.ID_ITEM_PRECO
                            ELSE (                                
                                SELECT _ip.ID_ITEM_PRECO FROM ITEM_PRECO _ip 
                                WHERE _ip.ID_ITEM = ip.ID_ITEM AND _ip.ID_TIPOPRECO = ip.ID_TIPOPRECO 
                                AND _ip.CH_EXCLUIDO IS NULL AND _ip.ID_FILIAL = ip.ID_FILIAL
                                ORDER BY __ip.ID_SEQ DESC LIMIT 1
                            )
                        END ID_ITEM_PRECO
                    FROM ITEM_PRECO ip WHERE ip.ID_ITEM = ip.ID_ITEM AND _ip.CH_EXCLUIDO IS NULL
                    AND ip.ID_TIPOPRECO = ip.ID_TIPOPRECO AND ip.ID_FILIAL = ip.ID_FILIAL
                    ORDER BY _ip.ID_SEQ ASC LIMIT 1
                ) ITEM_PRECO
            FROM ITEM_PRECO ip
            WHERE ip.CH_EXCLUIDO IS NULL 
            AND ip.ID_FILIAL = i.ID_FILIAL
            GROUP BY 2,3,4
            HAVING COUNT(ip.ID_TIPOPRECO) > 1
        ) s
    );