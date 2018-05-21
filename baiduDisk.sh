#!/bin/bash

# 参数：目录的绝对路径；例如：'西==瓜[[豆==芽'
# 功能：生成'西==瓜[[豆==芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
	PARAM1=${1//[[//}
	PARAM=${PARAM1//==/\\ }	
	PREFIX=$1
	FILENAME=${1##*[[}
# 将路径前缀存入文件的首行
	echo $PREFIX > $FILENAME.file
	echo $PARAM | xargs bypy list > tmp
	sed -i 1d tmp
	sed -i s/\ $//g tmp
	sed -i s/\ /==/g tmp
	cat tmp | awk -F == '{$NF=$(NF-1)=$(NF-2)=""; print $0}' >> $FILENAME.file && rm -f tmp
}

# 参数：西__瓜[[豆__芽
# 功能：生成'西__瓜[[豆__芽.file'中每一行目录对应的文件
function recursion() {
	genSubdirOfNameToFile $1

	sed 1d $FILENAME.file | while read line; do
		FLAG=${line:0:1}
		DIRNAME1=${line:2}
		# 特殊字符处理
		DIRNAME2=${DIRNAME1// /==}
		DIRNAME3=${DIRNAME2////[[}
		DIRNAME=${DIRNAME3//\'/\\\'}

		FILENAME=${1##*[[}
		PREFIX=`head -1 $FILENAME.file`

		if [ $FLAG == 'D' ]; then
			WHOLEDIRNAME=$PREFIX[[${DIRNAME//\ /\\ }
			recursion $WHOLEDIRNAME
		else
			echo $PREFIX[[$line | awk '{$NF=""; print $0}' >> /opt/WangKe.txt
		fi
	done
}

ROOTDIR='西==瓜[[豆==芽'
#ROOTDIR='17年赛普健身学院文件'
#ROOTDIR='test'
if [ ! -d WangKe-tmp ]; then
	mkdir WangKe-tmp
fi
pushd WangKe-tmp
#genSubdirOfNameToFile $ROOTDIR
recursion $ROOTDIR
popd
