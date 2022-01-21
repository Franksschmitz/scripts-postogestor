do $$declare
 declare ID_PIS fk;
 declare ID_COFINS fk;
 declare ID_CST_PIS fk;
 declare ID_CST_COFINS fk;
 declare ALIQUOTA_PIS decimal(10,4);
 declare ALIQUOTA_COFINS decimal(10,4);
begin

-- INFORMAR ID DO IMPOSTO, ID CST E ALIQUOTA (PREENCHER PONTO NO LUGAR DE VIRGULA NA ALIQUOTA) 

 ID_PIS = '4-1'; 
 ID_COFINS = '5-1';
 ID_CST_PIS = '118-1';
 ID_CST_COFINS = '151-1';
 ALIQUOTA_PIS = 0; 
 ALIQUOTA_COFINS = 0;
 
  update DOCFISCAL_ITEM_IMPOSTO a set
    ID_CST = ID_CST_PIS,
    AL_IMPOSTO = ALIQUOTA_PIS,
    VL_IMPOSTO = (
      select cast(b.VL_BASE * ALIQUOTA_PIS / 100 as decimal(5,2))
      from DOCFISCAL_ITEM_IMPOSTO b
      where b.ID_DOCFISCAL_ITEM_IMPOSTO = a.ID_DOCFISCAL_ITEM_IMPOSTO
    )
  where a.ID_IMPOSTO = ID_PIS and
        a.ID_DOCFISCAL_ITEM in (
          select di.ID_DOCFISCAL_ITEM 
          from DOCFISCAL_ITEM di
          join ITEM i on i.ID_ITEM = di.ID_ITEM 
          where i.CH_EXCLUIDO is null 
          and i.id_grupoitem in ('2-1','3-1','4-1')
        );
  
  update DOCFISCAL_IMPOSTO a set
    VL_IMPOSTO = (
      select sum(b.VL_IMPOSTO)   
      from DOCFISCAL_ITEM_IMPOSTO b 
      where b.ID_DOCFISCAL = a.ID_DOCFISCAL
      and b.ID_IMPOSTO = ID_PIS
    ) 
  where a.ID_IMPOSTO = ID_PIS and 
        a.ID_DOCFISCAL in (
          select di.ID_DOCFISCAL 
          from DOCFISCAL_ITEM di
          join ITEM i on i.ID_ITEM = di.ID_ITEM 
          where i.CH_EXCLUIDO is null
          and i.id_grupoitem in ('2-1','3-1','4-1')
        ); 

  update DOCFISCAL_ITEM_IMPOSTO a set
    ID_CST = ID_CST_COFINS,
    AL_IMPOSTO= ALIQUOTA_COFINS,
    VL_IMPOSTO = (
      select cast(b.VL_BASE * ALIQUOTA_COFINS / 100 as decimal(5,2))
      from DOCFISCAL_ITEM_IMPOSTO b
      where b.ID_DOCFISCAL_ITEM_IMPOSTO = a.ID_DOCFISCAL_ITEM_IMPOSTO
    )
  where a.ID_IMPOSTO = ID_COFINS and 
        a.ID_DOCFISCAL_ITEM in (
          select di.ID_DOCFISCAL_ITEM 
          from DOCFISCAL_ITEM di
          join ITEM i on i.ID_ITEM = di.ID_ITEM 
          where i.CH_EXCLUIDO is null
          and i.id_grupoitem in ('2-1','3-1','4-1')
        );
      
  update DOCFISCAL_IMPOSTO a set
    VL_IMPOSTO = (
      select sum(b.VL_IMPOSTO) 
      from DOCFISCAL_ITEM_IMPOSTO b 
      where b.ID_DOCFISCAL = a.ID_DOCFISCAL
      and b.ID_IMPOSTO = ID_COFINS
    ) 
  where a.ID_IMPOSTO = ID_COFINS and 
        a.ID_DOCFISCAL in (
          select di.ID_DOCFISCAL 
          from DOCFISCAL_ITEM di
          join ITEM i on i.ID_ITEM = di.ID_ITEM 
          where i.CH_EXCLUIDO is null
          and i.id_grupoitem in ('2-1','3-1','4-1')
        );
 
end$$;