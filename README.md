dzs：txt 转 markdown / mobi
===========================

## 需要下载rebol

http://www.rebol.com/r3/downloads.html

## txt 转 markdown 

``rebol dzs.reb "writer book a.txt a.md"``

## markdown 转 mobi

需要安装[calibre](http://www.calibre-ebook.com/)

``rebol dzs2mobi.reb "writer book a.md a.mobi"``

windows下要把calibre的安装目录加入PATH环境变量
