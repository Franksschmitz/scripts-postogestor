/* avenida */ 
execute block as

begin

UPDATE NFT_ITEM_IMPOSTO SET CH_APRCRE='T' 

WHERE ch_aprcre='F'
AND id_imposto IN ('1-1','3-1')
AND id_cst in ('1-1','3-1')

AND ID_NFT IN 
(SELECT a.id_nft FROM NFT a
JOIN NFT_ITEM_IMPOSTO b ON (A.ID_NFT=B.ID_NFT)
JOIN NFT_ITEM c ON (b.id_nft=c.id_nft)
WHERE b.ch_aprcre='F'
AND b.id_cst IN ('1-1','3-1')
AND b.id_imposto IN ('1-1','3-1')
AND a.CH_EXCLUIDO IS NULL)

end;
---------------------------------------------------------

SELECT 
--a.id_nft, b.id_nft_item_imposto, c.id_nft_item, c.id_item, b.id_cst, b.id_imposto, a.nr_notafi,b.ch_aprcre
count(*)

FROM NFT_ITEM_IMPOSTO b
JOIN NFT a ON (A.ID_NFT=B.ID_NFT)
JOIN NFT_ITEM c ON (b.id_nft=c.id_nft)

WHERE ch_aprcre='F'
AND a.CH_EXCLUIDO IS NULL
AND id_imposto IN ('1-1','3-1')
AND id_cst IN  ('1-1','3-1')
AND a.id_nft IN 

(SELECT a.id_nft FROM NFT a
JOIN NFT_ITEM_IMPOSTO b ON (A.ID_NFT=B.ID_NFT)
JOIN NFT_ITEM c ON (b.id_nft=c.id_nft)
WHERE ch_aprcre='F'
AND a.CH_EXCLUIDO IS NULL
AND b.id_imposto IN ('1-1','3-1')
AND b.id_cst IN ('1-1','3-1'))


















