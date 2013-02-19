BEGIN;
INSERT INTO Touza (Date ,Desc,Amount,Himoku)
SELECT Tmp.Date,Tmp.Desc,Tmp.Amount,Tmp.himoku FROM Tmp 
WHERE Tmp.Date BETWEEN (SELECT Year||"-01-01" FROM Kakeibo) 
AND (SELECT date((SELECT Year||"-01-01" FROM Kakeibo),"13 mONth"));
DROP TABLE Tmp;
END;
