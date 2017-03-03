Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

do %dzs.lib.reb

args: parse system/script/args none
src_file: args/1
type: args/2
single_dzs src_file type
