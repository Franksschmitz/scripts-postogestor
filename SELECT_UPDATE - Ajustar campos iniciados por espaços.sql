-- Para buscar campos iniciados por espaços em branco:

select * from planoconta where ds_planoconta <> ltrim(ds_planoconta)


-- Para ajustar os espaços no inicio do campo:

update planoconta set ds_planoconta = ltrim(ds_planoconta)
where ds_planoconta <> ltrim(ds_planoconta)

-------------------

select * from item where ds_item <> ltrim(ds_item)



update item set ds_item = ltrim(ds_item)
where ds_item <> ltrim(ds_item)