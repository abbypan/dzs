# dzs：txt 转 电子书

txt 转 电子书 ，自动生成章节目录。

调用[calibre](http://www.calibre-ebook.com/)的ebook-convert工具生成电子书。

支持转换的目标电子书格式有markdown、mobi、epub、pdf等等，详细列表见：[ebook-convert-help](http://manual.calibre-ebook.com/cli/ebook-convert.html#ebook-convert)

## 安装

需要安装[rebol](http://www.rebol.com/r3/downloads.html)

需要安装[calibre](http://www.calibre-ebook.com/)

windows下要把calibre的安装目录加入PATH环境变量

## 用法

转换指令：``r3 dzs.r3 [作者名] [书名] [源文件.txt] [目标类型]``

例子：
- 转换成markdown: ``r3 dzs.r3 飘灯 风尘叹 d:/test/fct.txt md``
- 转换成mobi: ``r3 dzs.r3 飘灯 风尘叹 d:/test/fct.txt mobi``
- 转换成epub: ``r3 dzs.r3 飘灯 风尘叹 d:/test/fct.txt epub``
