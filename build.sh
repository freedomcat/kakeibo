#!/bin/sh
# kakeibo install.sh
# Author	:shino@freedomcat.com
# Date		:2013/02/09
# License	:CC BY-NC
CMDNAME=$0
while getopts y:u:k:hb OPT
do
	case $OPT in
		"y" ) FLG_YEAR="TRUE";year="$OPTARG";;
		"u" ) FLG_USER="TRUE";user="$OPTARG";;
		"k" ) FLG_KURIKOSHI="TRUE";kurikoshi="$OPTARG";;
		"h" ) FLG_HIMOKU="TRUE";;
		"b" ) FLG_YOSAN="TRUE";;
		* ) echo "Usage: $CMDNAME -y YYYY [-k 前年度繰越金] [-u user][-h use user himoku.csv] [-b use usery osan.csv]" 1>&2
			exit 1;;
	esac
done
if [ "$FLG_YEAR" = "TRUE" ];then 
	echo "$year 年 家計簿を作成します."
else
	echo "Usage: $CMDNAME -y YYYY [-k 前年度繰越金] [-u user][-h use user himoku.csv] [-b use usery osan.csv]" 1>&2
	exit 1
fi
if [ "$FLG_KURIKOSHI" != "TRUE" ];then
	kurikoshi="0"
fi
echo "前年度繰越金 ${kurikoshi} 円を設定します.  "
if [ "$FLG_HIMOKU" = "TRUE" -a "$FLG_USER" = "TRUE" ];then
	himokucsv=$(pwd)'/conf/'$user'/himoku.csv'
else
	himokucsv=$(pwd)'/conf/himoku.csv'
fi
if [ ! -f ${himokucsv} ];then
	echo "費目設定ファイル${himokucsv} が存在しません."
	exit 1
else
	echo "費目 ${himokucsv} を設定します."
fi
if [ "$FLG_YOSAN" = "TRUE" -a "$FLG_USER" = "TRUE" ];then
	yosancsv=$(pwd)'/conf/'$user'/yosan'$year'.csv'
else
	yosancsv=$(pwd)'/conf/yosan.csv'
fi
if [ ! -f ${yosancsv} ];then
	echo "予算設定ファイル${yosancsv} が存在しません."
	exit 1
else
	echo "予算 ${yosancsv} を設定します."
fi

if [ "$FLG_USER" = "TRUE" ];then
	userdir=$(pwd)'/data/'${user}
	if [ ! -d ${userdir} ];then
		mkdir ${userdir}
	fi	
	sqlitefile=${userdir}'/'${year}'kakeibo.sqlite3'

else
	sqlitefile=$(pwd)'/data/'${year}'kakeibo.sqlite3'
fi

echo "${sqlitefile}"
if [ -f ${sqlitefile} ];then
	rm ${sqlitefile}
fi
sqlite3 ${sqlitefile}<<EOF
.separator ,
.echo ON
CREATE TABLE Kakeibo (Year INTEGER PRIMARY KEY CHECK(Year=${year}) , PrevKurikoshi INTEGER,NextKurikoshi INTEGER);
INSERT INTO Kakeibo VALUES(${year},${kurikoshi},0);
.read sql/table/month.sql
.read sql/table/kakeibomonth.sql
.read sql/table/himokugroupmaster.sql
.read sql/table/himokumaster.sql
.import ${himokucsv} HimokuMaster
.read sql/table/yosanmaster.sql
.import ${yosancsv} YosanMaster
.read sql/table/touza.sql
.read sql/table/himokutotal.sql
.read sql/table/himokuview.sql
.read sql/table/himokukessan.sql
.read sql/table/zangaku.sql
.read sql/table/himokugrouptotal.sql
.read sql/table/kurikoshi.sql
.read sql/table/himokugroupview.sql
.read sql/table/kessan.sql
.exit
EOF

echo "${sqlitefile} を作成しました."

exit 0
