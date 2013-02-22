#!/bin/sh
# kakeibo login.sh
# Author	:shino@freedomcat.com
# Date		:2013/02/09
# License	:CC BY-NC-SA
CMDNAME=$0
year=$(date +%Y)
while getopts y:u: OPT
do
	case $OPT in
		"y" ) FLG_YEAR="TRUE";year="$OPTARG";;
		"u" ) FLG_USER="TRUE";user="$OPTARG";;
	esac
done
datadir=$(pwd)'/data'
if [ "$FLG_USER" = "TRUE" ];then
	sqlitefile=${datadir}'/'${user}'/'${year}'kakeibo.sqlite3'
else
	sqlitefile=${datadir}'/'${year}'kakeibo.sqlite3'
fi
if [ -f ${sqlitefile} ];then
	echo "$year 年 家計簿にログインします."
	sqlite3 -separator , -header ${sqlitefile}
else
	echo "${sqlitefile}が存在しません."
	exit 1
fi
