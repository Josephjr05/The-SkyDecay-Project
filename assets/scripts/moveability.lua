local moveability = {Move = {}, Save = {}}
local moveables = {Lua = {}, Haxe = {}}

function moveability.Move:Lua(object, controls)
    controls = controls or {
        Z = {y = -1, x = 0},
        S = {y = 1, x = 0},
        Q = {x = -1, y  = 0},
        D = {x = 1, y = 0},
    }
    moveables.Lua[object] = controls
end
function moveability.Move:Haxe(object, controls)
    controls = controls or {
        Z = {y = -1, x = 0},
        S = {y = 1, x = 0},
        Q = {x = -1, y  = 0},
        D = {x = 1, y = 0},
    }
    moveables.Haxe[object] = controls
end
function savethis(file, content)
    local __file = io.open(file, 'wb')
    __file:write(content)
    __file:close()
end
function moveability.Save:Lua(saveFile, stringify)
    savethis(saveFile..'.txt', stringify)
end
function saveHaxe(saveFile, stringify)
    savethis(saveFile..'.txt', stringify)
end

function onUpdate()
    for _, __ in pairs(moveables.Lua) do
        for i, q in pairs(__) do
            if getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..i) then
                setProperty(_..'.x', getProperty(_..'.x')+q.x)
                setProperty(_..'.y', getProperty(_..'.y')+q.y)
            end
        end
        if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
            moveability.Save:Lua('LuaSave', 'X: '..getProperty(_..'.x')..'\nY: '..getProperty(_..'.y'))
        end
    end
    for _, __ in pairs(moveables.Haxe) do
        for i, q in pairs(__) do
            runHaxeCode(
                'if (FlxG.keys.pressed.'..i..'){\n'..
                _..'.x += '..q.x..';\n'..
                _..'.y += '..q.y..';\n}'..
                'if (FlxG.keys.justPressed.ENTER)\n'..
                'PlayState.instance.callOnLuas("saveHaxe", ["HaxeSave", "X: "+'.._..'.x+"\\nY: "+'.._..'.y]);'
            )
        end
    end
end

return moveability