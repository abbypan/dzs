Rebol [
Title: "电子书"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

;do %r3-gui.r3
load-gui

days: system/locale/days
dzs_types: [ "mobi" "md" "epub" ]
view [
   vpanel
   [

   hpanel [
   text 60 "源文件" 
   txt: field 280
   button 70 "选择" on-action [set-face txt to-local-file request-file]
   ]

   hpanel [
   text 60 "目标格式"
   dst: drop-down dzs_types 

   button 220 "转换" on-action [
   s: get-face txt

   rs: to-rebol-file s
   set [dpath dsrc] split-path rs
   parse dsrc [ copy w to "-" skip copy b to "." ]

   d: pick dzs_types get-face dst

   cmd: reform [ "r3" "dzs.r3" w b s d ]
   call cmd
   ]

   ]

   ]
   ]
