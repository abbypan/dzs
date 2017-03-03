# dzs:txt 转 电子书

txt 转 电子书 ，自动生成章节目录。 多于300章的txt会自动拆分成多个电子书，每个电子书不超过100章。

调用[calibre](http://www.calibre-ebook.com/)的ebook-convert工具生成电子书。

支持转换的目标类型有 md、mobi、epub、pdf 等等，详细列表见:[ebook-convert-help](http://manual.calibre-ebook.com/cli/ebook-convert.html#ebook-convert)

# txt 文件要求

默认转换的txt文件名格式为“作者-书名.txt”，内容为utf-8编码，见data目录

![dzs-file-utf8.png](data/dzs-file-utf8.png)

# 安装

需要安装[rebol](http://www.rebol.com/r3/downloads.html)

需要安装[calibre](http://www.calibre-ebook.com/)

r3-view 、r3-gui.r3 来自 [saphirion.com](http://development.saphirion.com/downloads/)

windows下需要把calibre的安装目录加入PATH环境变量，可以用 [rapidee](http://www.rapidee.com/en/about) 等软件添加环境变量

![dzs-path.png](data/dzs-path.png)

# 用法

## dzs-single.reb 单txt转换

usage: ``r3 dzs-single.reb [源文件.txt] [目标类型]``

example: 

``r3 dzs-single.reb d:\data\飘灯-风尘叹.txt mobi``

``r3 dzs-single.reb /d/data/飘灯-风尘叹.txt mobi``

## dzs-multi.reb 转换指定目录下的所有txt

usage: ``r3 dzs-multi.reb [txt目录] [目标类型]``

example: 

``r3 dzs-multi.reb d:\data mobi``

``r3 dzs-multi.reb /d/data mobi``

windows下直接双击``dzs_multi_mobi.bat``或``dzs_multi_epub.bat``可以查看data目录下批量转换txt效果

## dzs-gui.reb 图形界面

usage: ``r3-view dzs-gui.reb``

windows下直接双击 “dzs-gui.lnk” 即可打开图形界面

![dzs-gui.png](data/dzs-gui.png)

## dzs.reb 基础转换工具

usage: ``r3 dzs.reb [作者名] [书名] [源文件.txt] [目标类型]``

example: 

``r3 dzs.reb 飘灯 风尘叹 d:\data\fct.txt mobi``

``r3 dzs.reb 飘灯 风尘叹 /d/data/fct.txt mobi``

## dzs.lib.reb 基础库函数

read_txt 读入txt

write_dzs 转换txt

single_dzs 处理默认txt
