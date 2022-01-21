/* TIPO ENTIDADE
  2   = C -> CLIENTE
  3,4 = U -> FUNCIONARIO 
  5   = F -> FORNECEDOR
  6   = V -> VENDEDOR  
*/

SELECT --p.ID_PESSOA,
       p.codigo,
       p.NOME,
       CASE 
          WHEN ((SELECT s.ID_PESSOA FROM CLASSIFICACAO_PESSOA s WHERE s.ID_PESSOA = p.ID_PESSOA LIMIT 1) IS NOT NULL) 
            THEN (
                  SELECT 
                    CASE 
                      WHEN cp.ID_TIPO_CLASSIFICACAO_PESSOA = 3 THEN 'U'
                      WHEN cp.ID_TIPO_CLASSIFICACAO_PESSOA = 4 THEN 'U'
                      WHEN cp.ID_TIPO_CLASSIFICACAO_PESSOA = 5 THEN 'F'
                      WHEN cp.ID_TIPO_CLASSIFICACAO_PESSOA = 6 THEN 'V'
                      ELSE 'C'
                    END TIPO
                  FROM CLASSIFICACAO_PESSOA cp
                  WHERE cp.ID_PESSOA = p.ID_PESSOA LIMIT 1          
                )
          ELSE 'C'
       END TIPO_CADASTRO,
       p.CNPJ_CPF,
       p.NUM_RG,
       p.INSCRICAO_ESTADUAL,
       p.INSCRICAO_MUNICIPAL,
       'BRASIL' PAIS,
       uf.SIGLA ESTADO,
       UPPER(M.NOME) CIDADE,
       ep.LOGRADOURO,
       ep.NUMERO,
       ep.BAIRRO,
       ep.CEP,
       P.CELULAR TELEFONE,
       P.CELULAR,
       m.CODIGO_IBGE,
       concat_ws(',',email_comercial,email_cobranca,email_nfe) as email
FROM PESSOA p
LEFT JOIN MUNICIPIO m ON (p.ID_MUNICIPIO = m.ID_MUNICIPIO)--SELECT * FROM MUNICIPIO
LEFT JOIN UF ON (m.ID_UF = uf.ID_UF)--SELECT * FROM UF
LEFT JOIN ENDERECO_PESSOA ep ON (p.ID_PESSOA = ep.ID_PESSOA)--SELECT * FROM ENDERECO_PESSOA
WHERE ep.REGISTRO_ATIVO = 'S'
