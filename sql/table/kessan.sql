CREATE VIEW Kessan AS
SELECT "K" AS ViewType, id, Name,
(Jan+Feb+Mar+Apr+May+Jun+Jul+Aug+Sep+Oct+Nov+Dec)/12 AS FiscalYear,
(Jan+Feb+Mar+Apr+May+Jun)/6 AS FirstFiscal,
(Jul+Aug+Sep+Oct+Nov+Dec)/6 AS SecondFiscal,
(Jan+Feb+Mar)/3 AS JanMar, 
(Apr+May+Jun)/3 AS AprJun, 
(Jul+Aug+Sep)/3 AS JulSep,
(Oct+Nov+Dec)/3 AS OctDec
FROM HimokuGroupView WHERE id>=1;
