--Comando para conferir antes: 

select vl_perimptot, * from ibpt_classfiscal where id_classfiscal in (select id_classfiscal from classfiscal where nr_ncm = '27101921')

--comando para alterar pelo NCM Desejado:

update ibpt_classfiscal set vl_perimptot = '1.92' where id_classfiscal in (select id_classfiscal from classfiscal where nr_ncm = '27101921')
