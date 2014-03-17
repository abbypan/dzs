Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

get_title_parser: func [] [
spacer: charset reduce [tab    newline    #" "    "　"]
not_spacer: complement spacer
sep_not_spacer: charset reduce [ 
"("   ")"   "["   "]"   
"【"    "】"    "（"    "）"   
]
sep_with_spacer: charset reduce [
"."   
"-"   "——"   "—"   
"、" ]
sep: [ spacer | sep_not_spacer | sep_with_spacer ]
seps: [ some sep ]
sep_maybe: [ any sep ]

digit: [
"0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" |
"０" | "１" | "２" | "３" | "４" | "５" | "６" | "７" | "８" | "９" |
"零" | "壹" | "贰" | "叁" | "肆" | "伍" | "陆" | "柒" | "捌" | "玖" | "拾" | "佰" | "仟" |
"一" | "二" | "三" | "四" | "五" | "六" | "七" | "八" | "九" | "十" | "百" | "千" | "万" | "亿" |
"廿" | "卅" | "卌" | "圩" | "圆" | "进" | "枯" | "○〇"
]
digits: [ some digit ]

head_n: [ "第" | "卷" | "CHAPTER" ]
head_s: [ "内容简介" | "文案" | "序言" | "序" | 
"楔子" | "正文" | "终章" | "尾声" | "番外" | 
"后记" ]
tail_n: [ "章" | "节" | "卷" | "回" | "部" | "折" ]
tail_s: [ "上" | "中" | "下" ]

title_ds: [ sep_maybe digits seps tail_s sep_maybe ]
;print parse "1-(上)" title_ds
;print "==end title_ds=="

sep_to_end: [ any sep_with_spacer some spacer | some sep_not_spacer ] 
title_ndx: [ sep_maybe 0 1 head_n sep_maybe digits [ end | sep_to_end to end ] ]
;print parse "23" title_ndx
;print parse "(1)" title_ndx
;print parse "[1]" title_ndx
;print parse "(1)abc" title_ndx
;print parse "1、 测试" title_ndx
;print parse "chapter 44 abcd" title_ndx
;print "==end title_ndx=="

title_ndtx: [ sep_maybe head_n digits tail_n seps to end ] 
;print parse "第二百八十四章 还有点憧憬" title_ndtx
;print parse "第一卷 第二百八十四章 还有点憧憬" title_ndtx
;print parse "第廿十1章 程序" title_ndtx
;print parse "第30章(大结局)" title_ndtx
;print parse "第3卷 大结局" title_ndtx
;print "==end title_ndtx=="

title_ndn: [ sep_maybe head_n digits 0 1 tail_n end ] 
;print parse "第1章" title_ndn
;print parse "卷五" title_ndn
;print "==end title_ndn=="

title_sx: [ sep_maybe head_s seps to end ]
;print parse "尾声 1" title_sx
;print parse "尾声 xxx" title_sx
;print parse "楔子 xxx" title_sx
;print parse "序言 xxx" title_sx
;print "==end title_sx=="

title_xdx: [ some not_spacer to spacer sep_maybe digits sep_maybe to end ]
;print parse "abc (12)" title_xdx
;print parse "abc [12] efg" title_xdx
;print "==end title_xdx=="


main_title: [ title_ds | title_ndx | title_ndtx | title_ndn | title_sx | title_xdx ]

;test: "一、二、三"
;print parse test title_ndx
;print parse test title_ndtx
;print parse test title_ndn
;print parse test title_sx
;print parse test title_xdx
;print parse test main_title

return main_title
]

;get_title_parser
;exit


write_mobi: func [ writer book src dst ] [
cmd: reform ["ebook-convert" src dst "--authors" writer "--title" book]
call/wait cmd
]

set_dzs_fname: func [ writer book src type ] [
set [dpath dsrc] split-path src
dst: join "" [ dpath writer "-" book "." type ]
return dst
]

write_dzs: func [ writer book src dst_type ] [
title_parser: get_title_parser
srcfile: to-rebol-file src
doc: read/lines srcfile
toc: copy []
content: copy []
i: 1 
foreach line doc [
c: parse line title_parser
replace/all line "　" " "
trim line
if c [
t_line: join "" ["- [" line "](#segment" i ")" newline]
append toc t_line
line: join "" [ newline {<h1 id="segment} i {">} line {</h1>} newline ]
i: i + 1
]
append line newline
append content line
]

md: join "" [ "#  " writer " 《" book "》" newline newline]
append md toc
append md content

md_src: set_dzs_fname writer book src "md"
md_file: to-rebol-file md_src
write md_file md

to_other: not-equal? dst_type "md"
if to_other [
mobi_dst: set_dzs_fname writer book src dst_type
write_mobi writer book md_src mobi_dst
delete md_file
]

]

args: probe parse system/script/args none
writer: args/1
book: args/2
src: args/3
dst: args/4
write_dzs writer book src dst
