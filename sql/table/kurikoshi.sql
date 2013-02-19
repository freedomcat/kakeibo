CREATE TABLE Kurikoshi(hgid INTEGER CHECK (hgid=0),mid INTEGER,Amount INTEGER,PRIMARY KEY(hgid,mid));
INSERT INTO Kurikoshi(hgid,mid,Amount) SELECT 0,KM.mid,0 FROM KakeiboMonth AS KM;
