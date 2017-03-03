Rebol [
Title: "dzs"
Author: "abbypan"
Email: "abbypan@gmail.com"
]

do %dzs.lib.reb

main_dzs: func [ src type ] [
    s: to-file join "" [ src "/" ]
    foreach f read s [
        if %.txt = suffix? f [
            fp: join "" [ src "/" f ]
            set [fpath fsrc] split-path fp
            cmd: reform [ "r3" "dzs-single.reb" fp type ]
            call/wait cmd
        ]
    ]
]

args: parse system/script/args none
src: args/1
type: args/2
main_dzs src type
