#!/bin/bash

# 参数：目录的绝对路径；例如：'西==瓜[[豆==芽'
# 功能：生成'西==瓜[[豆==芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
	G_PARAM1=${1//[[//}
	G_PARAM=${G_PARAM1//==/\\ }	
	G_PREFIX=$1
	G_FILENAME1=${1%[[*}
	G_FILENAME2=${G_FILENAME1##*[[}
	G_FILENAME3=${1##*[[}
	if [ ! -z $G_FILENAME2 ]; then
		G_FILENAME=$G_FILENAME2'[['$G_FILENAME3
	else
		G_FILENAME=$G_FILENAME3
	fi

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

	R_FILE1=${1%[[*}
	R_FILE2=${R_FILE1##*[[}
	R_FILE3=${1##*[[}
	if [ ! -z $R_FILE2 ]; then
		R_FILE=$R_FILE2'[['$R_FILE3.file
	else
		R_FILE=$R_FILE3.file
	fi
	sed 1d $R_FILE | while read line; do
		R_FLAG=${line:0:1}
		R_DIRNAME1=${line:2}
		# 特殊字符处理
		R_DIRNAME2=${R_DIRNAME1// /==}
		R_DIRNAME3=${R_DIRNAME2////[[}
		R_DIRNAME4=${R_DIRNAME3//\'/\\\'}
		R_DIRNAME=${R_DIRNAME4//-/\\-}

		R_FILENAME1=${1%[[*}
		R_FILENAME2=${R_FILENAME1##*[[}
		R_FILENAME3=${1##*[[}
		if [ ! -z $R_FILENAME2 ]; then
			R_FILENAME=$R_FILENAME2'[['$R_FILENAME3
		else
			R_FILENAME=$R_FILENAME3
		fi

		R_PREFIX=`head -1 $R_FILENAME.file`

		if [ $R_FLAG == 'D' ]; then
			R_WHOLEDIRNAME=$R_PREFIX[[${R_DIRNAME//\ /\\ }
			recursion $R_WHOLEDIRNAME
		else
			echo $R_PREFIX[[$line | awk '{$NF=""; print $0}' >> /opt/$ROOTDIR.txt
		fi
	done
}

#ROOTDIR='西==瓜[[豆==芽'
#ROOTDIR='西==瓜[[豆==苗'
#ROOTDIR='西==瓜[[西==瓜==独==享'
#ROOTDIR='西==瓜[[豆==花'
ROOTDIR=$1
#ROOTDIR='西==瓜[[网==易'
#ROOTDIR='17年赛普健身学院文件'
#ROOTDIR='test'
if [ ! -d $ROOTDIR-tmp ]; then
	mkdir $ROOTDIR-tmp
fi
pushd $ROOTDIR-tmp
#genSubdirOfNameToFile $ROOTDIR
recursion $ROOTDIR
popd
