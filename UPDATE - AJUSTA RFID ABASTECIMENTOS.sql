/*  APENAS CBC.
Para os casos que o frentista está usando a TAG RFID mas a TAG ainda nao está cadastrada no PostoGestor. Este UPDATE irá ler a STRING da automação e setar as ID dos RFID nos abastecimentos conforme retornado na STRGING CBC.
Só pra melhorar o contexto: Os Frentistas estao com as tags deles la abastecendo normal, caiu 200 abastecimentos no banco, ID_RFID_OPERADOR em branco. Entao o pessoal cadastrou os cartoes no sistema e agora quer ajustar para os abastecimentos ficarem com frentista identificado. É o que essa query ira fazer, ler o numero da TAG retornado na STRING CBC, buscar as ID de Cartao RFID para aqueles numeros de TAG e inserir nos abastecimentos um por vez.
 
 */

DO $$DECLARE 
  l_empresa INTEGER;
  l_id_rfid FK;
  l_id_abastecimento FK; 
BEGIN

  FOR l_id_rfid, l_id_abastecimento IN 
    SELECT r.ID_RFID, a.ID_ABASTECIMENTO
    FROM ABASTECIMENTO a 
    JOIN RFID r ON ((SUBSTRING(a.DS_LINHA_AUT FROM 86 FOR 16)) = r.NR_TAG)
    WHERE ID_RFID_OPERADOR IS NULL
  LOOP

    UPDATE ABASTECIMENTO SET
      ID_RFID_OPERADOR = l_id_rfid
    WHERE ID_ABASTECIMENTO = l_id_abastecimento;

  END LOOP;
END$$;

/*

SELECT DS_LINHA_AUT,  
SUBSTRING(DS_LINHA_AUT FROM 86 FOR 16) RFID_FRENTISTA, *
FROM ABASTECIMENTO 
WHERE ID_RFID_OPERADOR IS NULL
AND CH_SITUAC = 'P'

Caso queira saber numero da tag retornada. A tag ta na posição 86 e tem 16 caracteres

*/