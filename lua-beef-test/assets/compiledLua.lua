--lua5.4
-- compiledLua.lua

function TestPrint(val)
    print('Hello World from a compiles script running in ' .. LUA_RELEASE .. val)

    print(debug.traceback("Stack trace"))
    print("Stack trace end")
end

function Run(val)
    TestPrint(val)
    local tmp = 1 + 500 * 99
    print('1 + 500 * 99 = ' .. tmp)
end
