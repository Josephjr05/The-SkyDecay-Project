--[[
    for all the clueless folk that cry for help because "i moved shader to psych mod but it not work like in base game!!!!!"
    redid it for 0.6.3 support grhgbhh
]]

function get(p)
    return getProperty('camGame.'..p);
end

function onCreatePost()
    if shadersEnabled == true then
    initLuaShader('rain', 100);
    makeLuaSprite('rainShaderSpr');
    setSpriteShader('rainShaderSpr', 'rain');

    setShaderFloatArray('rainShaderSpr', 'uScreenResolution', {screenWidth, screenHeight});
    setShaderFloat('rainShaderSpr', 'uTime', 0);
    setShaderFloat('rainShaderSpr', 'uScale', 3.6); -- screenHeight / 200
    -- 0.5 is constant for the last song, Blazin
    -- for other songs (they change as the song progresses):
    -- Darnell: 0 - 0.1
    -- Lit Up: 0.1 - 0.2
    -- 2Hot: 0.2 - 0.4
    setShaderFloat('rainShaderSpr', 'uIntensity', 0.5);

    --addHaxeLibrary('openfl.filters', 'ShaderFilter');
    runHaxeCode([[
        var obj = game.getLuaObject('rainShaderSpr');
        game.camGame.setFilters([new ShaderFilter(obj.shader)]);
        return;
    ]]);
end
end

-- avoiding use of os.clock() to have rain halt at pause instead of advancing further than it should
local time = 0;
function onUpdatePost(e)
    if shadersEnabled == true then
    time = time + e;

    setShaderFloatArray('rainShaderSpr', 'uCameraBounds',
        {get('scroll.x'), -- left
        get('scroll.y'), -- top
        get('scroll.x') + (get('width')), -- right
        get('scroll.y') + (get('height'))} -- bottom
    );
    setShaderFloat('rainShaderSpr', 'uTime', time);
end
end

function onGameOver()
    if shadersEnabled == true then
    runHaxeCode([[
        game.camGame.setFilters([]);
        return;
    ]]);
end
end