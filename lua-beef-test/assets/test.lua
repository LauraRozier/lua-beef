--lua 5.4
-- test.lua

function Run(val)
    print('Hello ' .. val .. ' from ' .. LUA_RELEASE .. '\n\nGlobals:')

    for n in pairs(_G) do
        print('  - ' .. n)
    end

    print('')

    p1, p2 = TestModule_HelloWorld(1, 2, 3)
    print (p1)
    print (p2)

    TestModule_HelloWorld2()
end
