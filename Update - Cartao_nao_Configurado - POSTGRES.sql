do $$declare
  declare IdEmpresa integer;
  declare IdCartaoCorreto fk;
  declare DescricaoCartao nomes;
  declare IdDocFiscalBaixa fk;
  declare IdBandeiraTef fk;
  declare IdCartaoErrado fk;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into IdEmpresa;
  
  DescricaoCartao = ''; --descricao do cartao retornado pelo sitef EX: VISA CREDITO
  IdCartaoCorreto = ''; --codigo do modelo de cartao que ser� atribuido
  IdCartaoErrado = ''; --id do cartao a ser substituido

  IdBandeiraTef = (select sct.ID_BANDEIRATEF from CARTAOTEF sct where sct.ID_CARTAOTEF = IdCartaoCorreto);     
  
  for IdDocFiscalBaixa in select db.ID_DOCFISCAL_BAIXA
    from tef_ope  t
    left join docfiscal_baixa db on db.ID_DOCFISCAL_BAIXA = t.ID_DOCFISCAL_BAIXA
    left join CARTAOTEF ct on ct.ID_CARTAOTEF = t.ID_CARTAOTEF
    left join CARTAOTEF ct2 on ct2.ID_CARTAOTEF = db.ID_CARTAOTEF 
    where t.CH_EXCLUIDO is null  and
          db.CH_EXCLUIDO is null and 
          t.DS_OPE = 'CRT' and 
          t.ID_DOCFISCAL_BAIXA is not null and      
          ct.CH_PADRAO = 'T' and
          ct2.CH_PADRAO = 'T' and
          t.DS_CARTAO = DescricaoCartao
    order by t.DH_EMISSAO, t.ID_SEQ
  loop
    update DOCFISCAL_BAIXA udb set ID_CARTAOTEF = IdCartaoCorreto, 
                               ID_BANDEIRATEF = IdBandeiraTef
    where ID_DOCFISCAL_BAIXA = IdDocFiscalBaixa and 
          ID_CARTAOTEF = IdCartaoErrado;
    update CONCIRECPAG crp set ID_CARTAOTEF = IdCartaoCorreto,
                           ID_BANDEIRATEF = IdBandeiraTef
    where ID_DOCFISCAL_BAIXA = IdDocFiscalBaixa and
          CH_EXCLUIDO is null and
          ID_CARTAOTEF = IdCartaoErrado;       
  end loop;
end$$;