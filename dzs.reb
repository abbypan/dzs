Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

get_title_parser: func [] [
;spacer: charset reduce [tab    newline    #" "    "　"]
spacer: charset reduce [tab #" " "　"]
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

not_spacer: complement spacer
not_sep: complement union sep_with_spacer sep_not_spacer
title_xdx: [ some not_spacer to spacer sep_maybe digits sep_maybe [ end | spacer any not_sep end] ]
;print parse "abc (12)" title_xdx
;print parse "abc [12] efg" title_xdx
;print "==end title_xdx=="


main_title: [ title_ds | title_ndx | title_ndtx | title_ndn | title_sx | title_xdx ]

;test: "一样"
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

read_txt: func [ writer book src ] [
title_parser: get_title_parser
srcfile: to-rebol-file src
doc: read/lines srcfile

toc: copy []
content: copy []
i: 0 
foreach line doc [
c: parse line title_parser
replace/all line "　" " "
trim line
if c [
i: i + 1
t_line: join "" ["- [" line "](#segment" i ")" newline]
append toc t_line
line: join "" [ newline {<h1 id="segment} i {">} line {</h1>} newline ]
]
append line newline
append content line
]

segment: make object! [
n: i
t: copy toc
c: copy content 
w: copy writer
b: copy book
]
return segment
]

write_md: func [ r fname ] [
md: join "" [ "#  " r/w " 《" r/b "》" newline newline ]
append md r/t
append md r/c
md_file: to-rebol-file fname
write md_file md
return fname
]

write_dzs: func [ writer book src dst_type ] [
info: read_txt writer book src
num:  info/n
b: copy book
md_src: set_dzs_fname writer b src "md"
write_md info md_src

md_file: to-rebol-file md_src
write md_file md

to_other: not-equal? dst_type "md"

if to_other [
dst_fname: set_dzs_fname writer b src dst_type
md_to_dzs writer book md_src dst_fname
delete md_file
]

]

set_dzs_fname: func [ writer book src type ] [
set [dpath dsrc] split-path to-rebol-file src
dst: join "" [ dpath writer "-" book "." type ]
return dst
]

md_to_dzs: func [ writer book s d ] [
src: to-local-file s
dst: to-local-file d
cmd: reform ["ebook-convert" src dst "--authors" writer "--title" book]
probe cmd
call/wait cmd
]

format_num: func [ i n ] [
c: round/ceiling log-10 (n + 1)
ci: round/ceiling log-10 (i + 1)
max: c - ci
m: copy []
if max > 0 [
for x 1 max 1 [ append m "0" ]
]
append m i
return join "" m
]

;main
args: parse system/script/args none
num: length? args
either num == 4 [
write_dzs args/1 args/2 args/3 args/4
] [
set [fpath fname] split-path to-rebol-file args/1
parse fname [ copy fwriter to "-" ]
parse fname [ thru "-"  copy fbook to ".txt" ]
write_dzs fwriter fbook args/1 args/2
]
