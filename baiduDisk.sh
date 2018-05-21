#!/bin/bash

# 参数：目录的绝对路径；例如：'西__瓜[[豆__芽'
# 功能：生成'西__瓜-豆__芽.file'，其中包含该目录的所有子目录
function genSubdirOfNameToFile() {
	PARAM1=${1//[[//}
	PARAM=${PARAM1//==/\\ }	
#	echo $PARAM >> /root/debug.txt
	echo $PARAM | xargs bypy list > tmp
	sed -i 1d tmp
	sed -i s/\ $//g tmp
	sed -i s/\ /==/g tmp
	cat tmp | awk -F == '{$NF=$(NF-1)=$(NF-2)=""; print $0}' > $1.file && rm -f tmp
}

# 参数：西__瓜[[豆__芽.file
# 功能：生成'西__瓜[[豆__芽.file'中每一行目录对应的文件
function recursion() {
	genSubdirOfNameToFile $1

	cat $1.file | while read line; do
		FLAG=${line:0:1}
		DIRNAME1=${line:2}
		# 特殊字符处理
		DIRNAME2=${DIRNAME1// /==}
		DIRNAME3=${DIRNAME2////[[}
		DIRNAME=${DIRNAME3//\'/\\\'}
		if [ $FLAG == 'D' ]; then
			WHOLEDIRNAME=$1[[${DIRNAME//\ /\\ }
			recursion $WHOLEDIRNAME
		else
			echo $1[[$line | awk '{$NF=""; print $0}' >> /opt/WangKe.txt
		fi
	done
}

ROOTDIR='西==瓜[[西==瓜==独==享'
#ROOTDIR='17年赛普健身学院文件'
#ROOTDIR='test'
if [ ! -d WangKe-tmp ]; then
	mkdir WangKe-tmp
fi
pushd WangKe-tmp
recursion $ROOTDIR
popd
