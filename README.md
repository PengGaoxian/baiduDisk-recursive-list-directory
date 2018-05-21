# baiduDisk-recursive-list-directory
用法：sh baiduDisk.sh <百度网盘目录>  
目录格式：空格( )用双等号(==)代替 目录分隔符(/)用双左中括号([[)代替，例如：'西 瓜/豆 芽'应该写成'西==瓜[[豆==芽'
递归列出百度网盘指定目录下的所有文件，依赖于bypy工具
目录内容通过变量存储，文件存储会出现file name too long 的问
