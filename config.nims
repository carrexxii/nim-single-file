# zlib License
#
# (C) 2024 carrexxii
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

# Version 0.1 (22/12/24)

import std/[os, strformat, strutils]

const
    bin_path = "main"
    src_dir  = "./src"
    lib_dir  = "./lib"
    entry    = src_dir / "main.nim"
    deps: seq[tuple[src, dst, tag: string; cmds: seq[string]]] = @[
        (src : "https://github.com/carrexxii/sdl-nim",
         dst : lib_dir / "sdl-nim",
         tag : "",
         cmds: @["nim restore --skipParentCfg"]),
    ]

var cmd_count = 0
proc run(cmd: string) =
    if defined `dry-run`:
        echo &"[{cmd_count}] {cmd}"
        inc cmd_count
    else:
        exec cmd

task restore, "Restore and build":
    run "git submodule update --init --remote --merge -j 8"
    for dep in deps:
        with_dir dep.dst:
            run &"git checkout {dep.tag}"
            for cmd in dep.cmds:
                run cmd

task run, "Run":
    run &"nim c -r {entry} -o:{bin_path}"

task gdb, "Debug with gdb":
    run &"nim c --debugger:native {entry} && nim-gdb -tui {bin_path}"

task info, "Print out information about the project":
    echo &"\e[34m{(get_current_dir().split \"/\")[^1]}\e[0m:"
    echo &"    Source dir   -  \e[33m{src_dir}\e[0m"
    echo &"    Library dir  -  \e[33m{lib_dir}\e[0m"
    if deps.len > 0:
        echo &"    Dependencies"
    for dep in deps:
        let tag = if dep.tag.len > 0: dep.tag else: "HEAD"
        echo &"        {dep.src}@\e[36m{tag}\e[0m"
