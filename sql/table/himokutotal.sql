CREATE VIEW HimokuTotal AS 
SELECT HimokuMaster.hid AS hid, 
KakeiboMonth.mid AS mid, 
SUM(Touza.Amount) AS Amount 
FROM HimokuMaster,KakeiboMonth,Touza ON HimokuMaster.Name=Touza.Himoku 
WHERE Touza.Date glob KakeiboMonth.Date
GROUP BY HimokuMaster.hid,KakeiboMonth.mid 
ORDER BY HimokuMaster.hid,KakeiboMonth.mid;
