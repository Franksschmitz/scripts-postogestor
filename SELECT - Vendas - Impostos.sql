SELECT
   CASE
    WHEN gi.ch_tipo = 'T' THEN 'EMPRESA'
    WHEN ic.ch_tipo = 'T' THEN 'EMPRESA'
    ELSE 'GERAL'
   END AS CONFIGURACAO,
   CASE
    WHEN gi.ch_tipo = 'T' THEN (SELECT ds_empresa FROM empresa WHERE id_empresa = gi.id_empresa)
    WHEN ic.ch_tipo = 'T' THEN (SELECT ds_empresa FROM empresa WHERE id_empresa = ic.id_filial)
    ELSE 'TODAS'
   END AS EMPRESA,
   a.id_item AS CODIGO,
   c.ds_item AS ITEM,
   c.id_grupoitem,
   g.ds_grupoitem AS GRUPO,
   a.id_classfiscal,
   d.nr_ncm AS NCM,
   f.id_cfgfiscal,
   i.id_imposto,
   z.ds_imposto AS IMPOSTO,
   i.id_cst,
   j.nr_cst AS CST,
   i.al_imposto AS ALIQUOTA   
FROM docfiscal_item a 
LEFT JOIN docfiscal b ON a.id_docfiscal = b.id_docfiscal
LEFT JOIN item c ON a.id_item = c.id_item
LEFT JOIN classfiscal d ON a.id_classfiscal = d.id_classfiscal
LEFT JOIN empresa e ON b.id_filial = e.id_empresa
LEFT JOIN grupoitem g ON c.id_grupoitem = g.id_grupoitem
LEFT JOIN docfiscal_item_cfgfiscal f ON a.id_docfiscal_item = f.id_docfiscal_item
LEFT JOIN cfgfiscal h ON f.id_cfgfiscal = h.id_cfgfiscal
LEFT JOIN cfgfiscal_imposto i ON h.id_cfgfiscal = i.id_cfgfiscal
LEFT JOIN cst j ON i.id_cst = j.id_cst
LEFT JOIN imposto z ON i.id_imposto = z.id_imposto
LEFT JOIN item_cfgfiscal ic ON a.id_item = ic.id_item
LEFT JOIN grupoitem_cfgfiscal gi ON c.id_grupoitem = gi.id_grupoitem
  WHERE b.ch_situac = 'F' 
  AND b.ch_sitpdv = 'F' 
  AND b.ch_tipo <> 'NFE'
  AND c.ch_ativo = 'T'
  AND ic.ch_tipocfg = 'P'
  AND gi.ch_tipocfg = 'P'
  AND b.ch_excluido IS NULL
  AND c.ch_excluido IS NULL
  AND f.ch_excluido IS NULL
  AND i.ch_excluido IS NULL
  AND ic.ch_excluido IS NULL
  AND gi.ch_excluido IS NULL

 
{IF param_Empresa} AND CASE
                          WHEN e.ch_vinculada = 'T'  THEN e.id_filial IN (:Empresa)
                          WHEN e.ch_vinculada <> 'T' THEN b.id_filial IN (:Empresa) 
                        END {endif}
{IF param_Grupo} AND g.id_grupoitem IN (:Grupo) {ENDIF}
{IF param_Item} AND c.id_item IN (:Item) {ENDIF} 
{IF param_NCM} AND d.id_classfiscal IN (:NCM) {ENDIF}   
{IF param_Imposto} AND z.id_imposto IN (:Imposto) {ENDIF}
{IF param_CST} AND e.nr_cst IN (:CST) {ENDIF}                    
{IF param_Emissao_ini} AND b.dt_emissa BETWEEN :Emissao_ini AND :Emissao_fim {ENDIF}

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
ORDER BY 6,4 ASC