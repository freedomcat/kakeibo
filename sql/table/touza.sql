CREATE TABLE Touza (id INTEGER PRIMARY KEY AUTOINCREMENT,Date TEXT,Desc TEXT, Amount integer,Himoku TEXT);
CREATE INDEX TouzaDateIDX ON Touza(Date);
CREATE INDEX TouzaHimokuIDX ON Touza(Himoku);
CREATE INDEX TouzaAmountIDX ON Touza(Amount);
CREATE TRIGGER TouzaDELETE DELETE ON Touza
BEGIN
UPDATE Kakeibo SET NextKurikoshi=0;
UPDATE Kurikoshi SET Amount=0;
END;
