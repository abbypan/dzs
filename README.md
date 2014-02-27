# dzs：txt 转 电子书 markdown / mobi / epub / ...

## 需要下载rebol

http://www.rebol.com/r3/downloads.html

## txt 转 markdown 

``r3 dzs.r3 writer book d:/test/a.txt md``

## txt 转 markdown 后再转成其他格式的电子书

需要安装[calibre](http://www.calibre-ebook.com/)

windows下要把calibre的安装目录加入PATH环境变量

支持转换的目标电子书格式列表见：[ebook-convert-help](http://manual.calibre-ebook.com/cli/ebook-convert.html#ebook-convert)

转换指令：``r3 dzs.r3 [作者名] [书名] [源文件.txt] [目标类型]``

例子：
- 转换成mobi : ``r3 dzs.r3 飘灯 风尘叹 d:/test/fct.txt mobi``
- 转换成epub : ``r3 dzs.r3 飘灯 风尘叹 d:/test/fct.txt mobi``
