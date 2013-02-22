#!/bin/sh
# kakeibo import.sh
# Author	:shino@freedomcat.com
# Date		:2013/02/09
# License	:CC BY-NC-SA
CMDNAME=$0
usage="Usage: ${CMDNAME} [-y YYYY][-u user][-i importtype][-j]";
while getopts :y:u:i:j OPT
do
	case $OPT in
		"y" ) FLG_YEAR="TRUE";year="$OPTARG";;
		"u" ) FLG_USER="TRUE";user="$OPTARG";;
		"i" ) FLG_IMPORT="TRUE";type="$OPTARG";;
		"j" ) FLG_JOIN="TRUE";;
		: ) echo $usage 1>&2
			exit 1;;
		¥? ) echo $usage 1>&2
			exit 1;;
		* ) echo $usage 1>&2
			exit 1;;
	esac
done

if [ "$FLG_YEAR" != "TRUE" ];then 
	year=$(date +%Y)
fi
if [ "$FLG_USER" = "TRUE" ];then
	datadir=$(pwd)'/data/'${user}
else
	datadir=$(pwd)'/data'
fi
if [ "$FLG_IMPORT" = "TRUE" ];then
	case "$type" in
	"my" ) importsql=$(pwd)'/sql/import.my.sql';attachfile=${datadir}'/2012.sqlite3';;
	* ) echo "-i importtype error" 1>&2
		echo $usage 1>&2
		exit 1;;
	esac
else
	type="zanmemo";
	importsql=$(pwd)'/sql/import.sql';
	attachfile=${datadir}'/zanmemo.dat2';
fi

sqlitefile=${datadir}'/'${year}'kakeibo.sqlite3'
if [ ! -f ${sqlitefile} ];then
	echo "家計簿ファイルが存在しません."
	echo "${sqlitefile}"
	echo "先にbuild.shを実行してください."
	echo "インポートできませんでした."
	exit 1
fi
if [ ! -f ${attachfile} ];then
	echo "インポートファイルが存在しません."
	echo "${attachfile}"
	echo "インポートできませんでした."
	exit 1
fi

#.echo on
#.read sql/nextkurikoshi.sql
if [ "$FLG_JOIN" = "TRUE" ];then
	echo "$year 年 家計簿を結合インポートします."
	echo "From:	${attachfile}"
	echo "To:	${sqlitefile}"
else
	echo "$year 年 家計簿をインポートします(前のデータが削除されインデックスが再構築されます)."
	echo "From:	${attachfile}"
	echo "To:	${sqlitefile}"
sqlite3 ${sqlitefile}<<EOF
DELETE FROM Touza;
EOF
fi
sqlite3 ${sqlitefile}<<EOF
attach "${attachfile}" as "${type}";
.read "${importsql}"
.read "sql/import.tmp.sql"
VACUUM;
REINDEX;
.read "sql/transaction/nextkurikoshi.sql"
EOF
exit 0
