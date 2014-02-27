dzs：txt 转 markdown / mobi
===========================

## 需要下载rebol

http://www.rebol.com/r3/downloads.html

## txt 转 markdown 

``rebol dzs.r3 writer book /d/test/a.md md``

## txt 转 markdown 后再转 mobi

需要安装[calibre](http://www.calibre-ebook.com/)

windows下要把calibre的安装目录加入PATH环境变量

``rebol dzs.r3 writer book /d/test/a.md mobi``
