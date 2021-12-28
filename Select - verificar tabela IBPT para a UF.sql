
--comando verificar ibpt no estado e ncm


select VL_PERIMPTOT, VL_PERIMPTOT_EST, VL_PERIMPTOT_MUN, DS_CHAVE, DT_INICIO 
from IBPT_CLASSFISCAL ic 
where ic.ID_CLASSFISCAL = :ID_CLASSFISCAL and 
      ic.ID_ESTADO = :ID_ESTADO 
       
order by DT_FIM desc
{limit} 1