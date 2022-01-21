-- Comandos para ajustes referentes ao erro de "NR_VOUCHER not found"


UPDATE docfiscal SET ch_excluido = 'T', ch_situac = 'C'
    WHERE id_docfiscal = '166-1';

UPDATE docfiscal_item SET ch_excluido = 'T'
    WHERE id_docfiscal = '166-1';

UPDATE docfiscal_docref SET ch_excluido = 'T'
    WHERE id_docfiscal = '166-1';
