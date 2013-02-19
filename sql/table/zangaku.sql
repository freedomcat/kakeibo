CREATE VIEW Zangaku AS
select "Z" AS ViewType, id, HM.Name AS Name,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Total-(YM.AMOUNT*12) ELSE (YM.Amount*12)-HV.Total END) AS Total,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Jan-YM.Amount ELSE YM.Amount-HV.Jan END) AS Jan,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Feb-YM.Amount ELSE YM.Amount-HV.Feb END) AS Feb,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Mar-YM.Amount ELSE YM.Amount-HV.Mar END) AS Mar,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Apr-YM.Amount ELSE YM.Amount-HV.Apr END) AS Apr,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.May-YM.Amount ELSE YM.Amount-HV.May END) AS May,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Jun-YM.Amount ELSE YM.Amount-HV.Jun END) AS Jun,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Jul-YM.Amount ELSE YM.Amount-HV.Jul END) AS Jul,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Aug-YM.Amount ELSE YM.Amount-HV.Aug END) AS Aug,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Sep-YM.Amount ELSE YM.Amount-HV.Sep END) AS Sep,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Oct-YM.Amount ELSE YM.Amount-HV.Oct END) AS Oct,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Nov-YM.Amount ELSE YM.Amount-HV.Nov END) AS Nov,
	SUM(CASE WHEN HGM.incomeflg=1 THEN HV.Dec-YM.Amount ELSE YM.Amount-HV.Dec END) AS Dec
FROM HimokuGroupMaster AS HGM, HimokuMaster AS HM, HimokuView AS HV, YosanMaster AS YM
ON HM.hgid=HGM.hgid AND HM.hid=HV.id AND HM.hid=YM.hid
GROUP BY HM.hid;
