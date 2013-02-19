CREATE TABLE KakeiboMonth  (mid INTEGER PRIMARY KEY,Date text);
INSERT INTO KakeiboMonth SELECT Month.mid AS mid, Kakeibo.Year||"-"||Month.Date||"-*" AS Date FROM Kakeibo,Month;
