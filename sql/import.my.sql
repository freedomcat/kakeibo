BEGIN;
CREATE TABLE Tmp (id TEXT PRIMARY KEY,Date TEXT,Desc TEXT, Amount INTEGER,Himoku TEXT);
INSERT INTO Tmp 
SELECT "P"||My.ID,replace(My.Date,"/","-") AS Date,My.Desc,My.Amount ,My.Himoku FROM my.TOUZA AS My;
CREATE INDEX TmpDateIDX ON Tmp(Date);
END;
