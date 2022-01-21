SELECT
    a.ds_entidade AS NOME,
    b.ds_endereco || ', ' || b.ds_numero AS ENDERECO,
    b.ds_bairro AS BAIRRO,
    e.ds_cidade || ' - ' || f.ds_sigla AS CIDADE, 
    b.ds_cep AS CEP
FROM entidade a
LEFT JOIN entidade_endereco b ON a.id_entidade = b.id_entidade 
LEFT JOIN lanc d ON a.id_entidade = d.id_entidade
LEFT JOIN cidade e ON b.id_cidade = e.id_cidade
LEFT JOIN estado f ON b.id_estado = f.id_estado
    WHERE d.id_lanc IN (:ID)