#!/bin/bash

# 参数：目录的绝对路径；例如：'西==瓜[[豆==芽'
# 功能：生成'西==瓜[[豆==芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
	G_PARAM1=${1//[[//}
	G_PARAM=${G_PARAM1//==/\\ }	
	G_PREFIX=$1

	G_LIST=`echo $1 | awk -F '\\\[\\\[' '{for(i=NF; i>(NF-4>0?NF-4:0); i--) {print $i}}'`
	G_STR=''
	for i in $G_LIST; do
		G_STR=$i'[['$G_STR
	done
	G_FILENAME=${G_STR%[[*}
	echo $G_FILENAME

# 将路径前缀存入文件的首行
	echo $G_PREFIX > $G_FILENAME.file
	echo $G_PARAM | xargs bypy list > tmp
	sed -i 1d tmp
	sed -i s/\ $//g tmp
	sed -i s/\ /==/g tmp
	cat tmp | awk -F == '{$NF=$(NF-1)=$(NF-2)=""; print $0}' &>> $G_FILENAME.file && rm -f tmp
}

# 参数：西__瓜[[豆__芽
# 功能：生成'西__瓜[[豆__芽.file'中每一行目录对应的文件
function recursion() {
	genSubdirOfNameToFile $1

	R_LIST=`echo $1 | awk -F '\\\[\\\[' '{for(i=NF; i>(NF-4>0?NF-4:0); i--) {print $i}}'`
	R_STR=''
	for i in $R_LIST; do
		R_STR=$i'[['$R_STR
	done
	R_FILE=${R_STR%[[*}.file

	sed 1d $R_FILE | while read line; do
		R_FLAG=${line:0:1}
		R_DIRNAME1=${line:2}
		# 特殊字符处理
		R_DIRNAME2=${R_DIRNAME1// /==}
		R_DIRNAME3=${R_DIRNAME2////[[}
		R_DIRNAME4=${R_DIRNAME3//\'/\\\'}
		R_DIRNAME=${R_DIRNAME4//-/\\-}

		R_LIST=`echo $1 | awk -F '\\\[\\\[' '{for(i=NF; i>(NF-4>0?NF-4:0); i--) {print $i}}'`
		R_STR=''
		for i in $R_LIST; do
			R_STR=$i'[['$R_STR
		done
		R_FILENAME=${R_STR%[[*}

		R_PREFIX=`head -1 $R_FILENAME.file`

		if [ $R_FLAG == 'D' ]; then
			R_WHOLEDIRNAME=$R_PREFIX[[${R_DIRNAME//\ /\\ }
			recursion $R_WHOLEDIRNAME
		else
			echo $R_PREFIX[[$line | awk '{$NF=""; print $0}' >> /opt/$ROOTDIR`date +%Y%m%d`.txt
		fi
	done
}

ROOTDIR=$1
if [ ! -d /opt/$ROOTDIR-tmp ]; then
	mkdir /opt/$ROOTDIR-tmp
fi
pushd /opt/$ROOTDIR-tmp
recursion $ROOTDIR
popd
