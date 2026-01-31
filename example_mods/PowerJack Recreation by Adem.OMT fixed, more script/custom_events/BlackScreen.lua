function check(variable, values)
    local found_value = false

    for _, value in pairs(values) do
        if string.lower(variable) == value then
            found_value = true
            break
        end
    end

    return found_value
end

function onEvent(name, value1, value2)
    if name ~= "BlackScreen" then
        return
    end

    local error = false

    if not check(value1, {"add", "remove"}) then
        debugPrint("BlackScreen Error: Value1 is invalid. (Add or Remove)")
        error = true
    end

    if not check(value2, {"game", "hud", "other"}) then
        debugPrint("BlackScreen Error: Value2 is invalid. (game, hud, or other)")
        error = true
    end

    if error then
        return
    end

    if string.lower(value1) == "remove" then
        removeLuaSprite("BlackBox", true)
        return
    end

    makeLuaSprite("BlackBox", nil, 0, 0)
    makeGraphic("BlackBox", 3200, 3200, "0x000000")
    setScrollFactor("BlackBox", 0, 0)
    setObjectCamera("BlackBox", string.lower(value2))
    setObjectOrder("BlackBox", 2147483647)
    screenCenter("BlackBox")

    addLuaSprite("BlackBox", true)
end