@ECHO OFF
luac53.exe -o compiledLua_d.53.luac compiledLua.lua
luac53.exe -s -o compiledLua.53.luac compiledLua.lua

luac54.exe -o compiledLua_d.54.luac compiledLua.lua
luac54.exe -s -o compiledLua.54.luac compiledLua.lua
