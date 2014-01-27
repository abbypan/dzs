Rebol [
Title: "dzs"
Author: "abbypan"
]

write_mobi: func [ writer book src dst ] [
    cmd: reform ["ebook-convert" src dst "--authors" writer "--title" book]
    print cmd
    call cmd
]

args: probe parse system/script/args none
writer: args/1
book: args/2
src: args/3
dst: args/4
write_mobi writer book src dst
