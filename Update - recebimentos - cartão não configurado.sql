Comandos para ajustar recebimentos com cartões não configurados:


update lanc set id_planoconta = '15-1'
where id_lanc = '45253-2';

update rectopagto_baixa set id_cartaotef = '21-1'
where id_rectopagto in (select id_rectopagto from lanc where id_lanc = '45253-2')
and id_cartaotef = '1-1';