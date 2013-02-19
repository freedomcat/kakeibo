CREATE VIEW HimokuGroupTotal AS SELECT
HGM.hgid AS hgid,
HT.mid AS mid,
SUM(HT.Amount) AS Amount
FROM HimokuTotal AS HT, HimokuMaster AS HM, HimokuGroupMaster AS HGM
ON HT.hid=HM.hid AND HM.hgid=HGM.hgid
GROUP BY HT.mid,HGM.hgid
ORDER BY HT.mid,HGM.hgid;
