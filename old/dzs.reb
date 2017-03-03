Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

do %dzs.lib.reb

args: probe parse system/script/args none
writer: args/1
book: args/2
src: args/3
type: args/4
write_dzs writer book src type
