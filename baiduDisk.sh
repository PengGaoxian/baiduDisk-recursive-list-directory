#!/bin/bash

# 参数：目录的绝对路径；例如：'西==瓜[[豆==芽'
# 功能：生成'西==瓜[[豆==芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
# 将[[字符转换成/，将==字符转换成空格
	PARAM1=${1//[[//}
	PARAM=${PARAM1//==/\\ }	

	if [ ${#1} -gt 83 ]; then
		G_FILENAME=${1:((${#1}-83))}
	else
		G_FILENAME=$1
	fi

# 将路径前缀存入文件的首行
	echo $1 > $G_FILENAME.file
# 列出目录写入临时文件tmp中，去除tmp文件首行信息，追加到FILENAME.file中
	echo $PARAM | xargs bypy list > tmp
	sed -i 1d tmp
	sed -i s/\ $//g tmp
	sed -i s/\ /==/g tmp
	cat tmp | awk -F == '{$NF=$(NF-1)=$(NF-2)=""; print $0}' &>> $G_FILENAME.file && rm -f tmp
}

# 参数：西__瓜[[豆__芽
# 功能：生成'西__瓜[[豆__芽.file'中每一行目录对应的文件
function recursion() {
	genSubdirOfNameToFile $1

	if [ ${#1} -gt 83 ]; then
		FILENAME=${1:((${#1}-83))}
	else
		FILENAME=$1
	fi
	sed 1d $FILENAME.file | while read line; do
		FLAG=${line:0:1}
		DIRNAME1=${line:2}
		# 将空格转换成==字符，将/字符转换成[[字符
		DIRNAME2=${DIRNAME1// /==}
		DIRNAME3=${DIRNAME2////[[}
		# 特殊字符处理
		DIRNAME4=${DIRNAME3//\'/\\\'}
		DIRNAME=${DIRNAME4//-/\\-}

		if [ ${#1} -gt 83 ]; then
			FILENAME=${1:((${#1}-83))}
		else
			FILENAME=$1
		fi

		PREFIX=`head -1 $FILENAME.file`

		if [ $FLAG == 'D' ]; then
			WHOLEDIRNAME=$PREFIX[[${DIRNAME//\ /\\ }
			recursion $WHOLEDIRNAME
		else
			echo $PREFIX[[$line | awk '{$NF=""; print $0}' >> /opt/$ROOTDIR`date +%Y%m%d`.txt
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
