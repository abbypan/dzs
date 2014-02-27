Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

get_title_parser: func [] [
spacer: charset reduce [tab newline #" " "　"]
sep_not_spacer: charset [ 
"(" ")" "[" "]" 
"【" "】" "（" "）"
"." 
"-" "——" "—"
"、"]
sep: [ spacer | sep_not_spacer ]
seps: [ any sep ]
sep_not_spacer_block: [ "(" | ")" | "[" | "]" |
"【" | "】" | "（" | "）" ]

digit: charset reduce [
"0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
"０" "１" "２" "３" "４" "５" "６" "７" "８" "９" 
"零" "壹" "贰" "叁" "肆" "伍" "陆" "柒" "捌" "玖" "拾" "佰" "仟" 
"一" "二" "三" "四" "五" "六" "七" "八" "九" "十" "百" "千" "万" "亿" 
"廿" "卅" "卌" "圩" "圆" "进" "枯"
"○〇"]
digits: [ some digit ]

head_n: [ "第" | "卷" | "CHAPTER" ]
head_s: [ "内容简介" | "文案" | "序" |  "序言" | 
"楔子" | "正文" | "终章" |"尾声" | "番外" | 
"后记" ]
head_main: [ 0 1 head_n seps digits | head_s seps any digits ]

tail_u: [ "章" | "节" | "卷" | "回" | "部" | "折" ]
suffix: [ "上" | "中" | "下" ]
tail_m: [ seps 0 1 tail_u ]
tail_n: [ some sep suffix | seps ]
tail_main: [ tail_m tail_n ]

;chapter 1 xxxx
title_cix: [ seps head_n seps digits some sep to end ]

;第1章 xxx , 第一章 （上）xxx
title_cisx: [ seps head_main tail_main some sep to end ] 

;第1章
title_cis: [ seps head_main tail_main end ] 

;序言 xxx
title_sx: [ thru  sep_not_spacer_block  
some digit 
sep_not_spacer_block to end ]

main_title: [ title_cix | title_cis | title_cisx | title_sx ]

;print parse "chapter 44 abcd" main_title
;print parse "第廿十1章 程序" main_title
;print parse "卷五" main_title
;print parse "第30章(大结局)" main_title
;print parse "第3卷 大结局" main_title
;print parse "尾声 1" main_title
;print parse "(1)" main_title
;print parse "[1]" main_title
;print parse "(1)abc" main_title
;print parse "1-上" main_title
;print parse "1、测试" main_title
;print parse "abc [12] efg" main_title
;print parse "abc (12)" main_title

return main_title
]

write_mobi: func [ writer book src dst ] [
    cmd: reform ["ebook-convert" src dst "--authors" writer "--title" book]
    call cmd
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
t_line: join "" ["- [" line "](#" i ")" newline]
append toc t_line
line: join "" [ newline {<h1 id="} i {">} line {</h1>} newline ]
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

to_mobi: equal? dst_type "mobi"
if to_mobi [
mobi_dst: set_dzs_fname writer book src "mobi"
write_mobi writer book md_src mobi_dst
]

]

args: probe parse system/script/args none
writer: args/1
book: args/2
src: args/3
dst: args/4
write_dzs writer book src dst
