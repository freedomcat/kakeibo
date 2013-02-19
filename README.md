# kakeibo
## これは何？
家計簿集計のsqlite3 DBを作成/繰越金計算

* 一年分の家計簿データの集計を行う
  費目別/月別集計
  費目別予算に対する残高集計
  費目決算集計
  月別繰越金算出
  費目グループ/月別集計
  決算集計
* データは全インポートのみ。差分インポートはなし。複数のデータ元のインポートは結合インポートとして扱われる

## なんちゃってER図

![なんちゃってER図](https://www.dropbox.com/s/4dscrjm7bytdazk/Document_2013-02-15_15-10-09.jpeg)

## 設定
### 費目設定ファイル
*./conf\[/user\]/himoku.csv*
columns= id,Name,HimokuGroupid
|id| 一意のキー.数字.|
|Name|費目名.残額メモではタグと呼ばれるもの.|
|HimokuGroupid|費目の対応する費目グループid.1-4までのいずれかの数字.|

* 費目グループ
|費目グループid|名前|
|1|収入|
|2|税金他|
|3|純生活費|
|4|預貯金|

収入-税金他が可処分所得.

### 予算設定ファイル
*./conf\[/user\]/yosanYYYY.csv*
columns = Himokuid,Yosan
|Himokuid|費目id|
|Yosan|費目の一ヶ月の予算|

* 予算は費目に対する通年予算を12で割った金額を一ヶ月予算とする.

## 家計簿DBの作成 
*./data\[/user\]/YYYYkakeibo.sqlite3*
家計簿DBは./data\[/user\]に"YYYYkakeibo.sqlite3"ファイルとして作成される.

 "Usage: ./install.sh -y YYYY \[-k 前年度繰越金\] \[-u user\[-h\] \[-b\]\]"

|-y|YYYY|家計簿年|
|-k|数字|前年度繰越金.defaul.任意の英数t 0|
|-u|user|ユーザ名.任意の英数文字|
|-h|フラグ|-u、-hがある場合、conf/user/配下の費目設定ファイルを読み込む default conf/himoku.csv|
|-b|フラグ|-u、-bがある場合、conf/user/配下の予算設定ファイルを読み込む default conf/yosan.csv|

## 家計簿DBへのデータインポート
### インポート元データ準備
残額メモのエクスポートデータのうち、zanmemo.dat2をdata\[/user\]ディレクトリに入れる.

### インポート
import.shを実行する.データのインポートと繰越金計算を行っている.
-yオプション省略時は当年家計簿で処理を行う.

 "Usage: ./import.sh \[-y YYYY\]"

*当座テーブル(touza)*

インポートされたデータは、当座テーブルに格納される。

 SELECT * FROM Touza;
 id,Date,Desc,Amount,Himoku

|id|プライマリキー|
|Date|YYYY-MM-DD形式 sqlite3の日付形式で検索可能|
|Desc|摘要.残額メモのタイトル|
|Amount|金額.収入はマイナス、支出は自然数|
|Himoku|費目名.残額メモのタグ|

## 家計簿DBへのログイン

login.shを実行する.-yオプション省略時は当年家計簿にログインする.

 ./login.sh \[-y YYYY\] \[-u user\] \[-i importtype\] \[-j\]

|-y|YYYY|家計簿年|
|-u|user|ユーザ名.任意の英数文字|
|-i|importtype|default.zanmemo|
|-j|フラグ|複数のインポートデータがある場合は先に登録されたデータに対して結合して登録する|

## 使用例

 sh ./build.sh -y 2013 -u shino -h -b
 sh ./import.sh -y 2013 -u shino
 sh ./login.sh -y 2013 -u shino

独自のmyデータとzanmemoデータがある
(あらかじめ独自データインポートのsql/import.my.sqlを作成する)

 sh ./build.sh -y 2012 -u shino -h
 sh ./import.sh -y 2012 -u shino -i my
 sh ./import.sh -y 2012 -u shino -j
 sh ./login.sh -y 2012 -u shino

## 集計参照

### 費目集計

 SELECT * FROM HimokuView;
 ViewType,id,Name,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec

|ViewType|HV|
|id|費目id|
|Name|費目名|
|Total|費目別年間合計|
|Jan-Dec|1月から12月の費目ごとの集計金額|

### 費目別予算残額集計(予算を立てた人)

 SELECT * FROM Zangaku;
 ViewType,id,Name,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec
 
|ViewType|Z|
|id|費目id|
|Name|費目名|
|Total|費目別年間予算残額合計|
|Jan-Dec|1月から12月の費目ごとの予算対する残額金額.残額が予算超過（赤字)はマイナス.  繰越タイプが収入(1)の費目は予算に対する不足金額がマイナス.  |

*応用 特定月の費目と予算に対する赤字/黒字を知りたい*(1月の場合)

 SELECT h.name AS himoku,h.Jan AS Jan,z.Jan AS zangaku
 FROM HimokuView AS h,Zangaku AS z
 WHERE h.id=z.id;

 himoku,Jan,zangaku

### 月別繰越金集計
 SELECT * FROM HimokuGroupView;
 ViewType,id,Name,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec

|ViewType|HGV|
|id|費目グループid|
|Name|費目グループ名|
|Total|費目グループ別年間合計|
|Jan-Dec|1月から12月の費目グループ別集計金額.前月繰越金は、前月の"前月繰越金+収入-(純生活費-税金他-預貯金)"|

繰越金集計の*翌月の前月繰越金*が、実際の*当月の赤字/黒字*を示している.

*応用 費目集計と繰越金集計を一気に知りたい.*

 SELECT * FROM HimokuView 
 UNION
 SELECT * FROM HimokuGroupView 
 ORDER BY ViewType,id;

### 決算

費目別決算と収入、税金他など費目グループの決算が取得できる.

* 費目別決算
 SELECT * FROM HimokuKessan;
* 決算
 SELECT * FROM Kessan;

項目は共通
 Name,Total,FiscalYear,FirstFiscal,SecondFiscal,JanMar,AprJun,JulSep,OctDec 

|Name|費目名または費目グループ名（収入、税金他、純生活費、預貯金)|
|FiscalYear|12ヶ月決算(1-12月)|
|FirstFiscal|上半期決算(1-6月)|
|SecondFiscal|下半期決算(7-12月)|
|JanMar|四半期決算(1-3月)|
|AprJun|四半期決算(4-6月)|
|JulSep|四半期決算(7-9月)|
|OctDec|四半期決算(10-12月)|

### 次年度繰越金取得
次年度繰越金を取得する.

 SELECT NextKurikoshi FROM Kakeibo;

|NextKurikoshi|次年度繰越金|

# ライセンスについて

CC BY-NC

