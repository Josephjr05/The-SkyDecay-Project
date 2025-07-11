function onCreatePost()
    if not shadersEnabled then return end

    initLuaShader('Light_Shader')

    -- change values if you want
    local chars = {
        boyfriend = {
            angle = 105,
            lightOpacity = 0.8,            thr = 0.1,
            useMask = true,
            thr2 = 0.1,
            dist = 25,
            brightness = -75,
            hue = -10, -- hue diferente
            contrast = -25,
            saturation = 0
        },
        gf = {
            angle = 90,
            lightOpacity = 0.8,            thr = 0.1,
            useMask = true,
            thr2 = 0.1,
            dist = 20,
            brightness = -50,
            hue = -10,
            contrast = -25,
            saturation = 0
        },
        dad = {
            angle = 45,
            lightOpacity = 0.8,            thr = 0.1,
            useMask = true,
            thr2 = 0.1,
            dist = 20,
            brightness = -75,
            hue = -10,
            contrast = -25,
            saturation = 0
        }
    }

    for char, data in pairs(chars) do
        setSpriteShader(char, 'Light_Shader')

        -- Luz e máscara
        setShaderFloat(char, 'thr', data.thr)
        if data.thr2 then setShaderFloat(char, 'thr2', data.thr2) end
        setShaderFloat(char, 'ang', math.rad(data.angle))
        setShaderBool(char, 'useMask', data.useMask)
        setShaderFloat(char, 'dist', data.dist)

        -- Anti-alias e força do efeito
        setShaderFloat(char, 'AA_STAGES', 2)
        setShaderFloat(char, 'str', 0.8)

        -- color of the light
        setShaderFloatArray(char, 'dropColor', {255/255, 165/255, 0/255})

        -- Ajustes de cor personalizados
        setShaderFloat(char, 'brightness', data.brightness or 0)
        setShaderFloat(char, 'hue', data.hue or 0)
        setShaderFloat(char, 'contrast', data.contrast or 0)
        setShaderFloat(char, 'saturation', data.saturation or 0)
        setShaderFloat(char, 'lightOpacity', data.lightOpacity or 1)

        -- Frame info
        updateFrameInfo(char)
    end
end

function onUpdatePost()
    if not shadersEnabled then return end
    for char in pairs({boyfriend=true, gf=true, dad=true}) do
        updateFrameInfo(char)
    end
end

function updateFrameInfo(s)
    if getProperty(s..'.pixel') then return end
    setShaderFloatArray(s, 'uFrameBounds', {
        getProperty(s..'.frame.uv.x'),
        getProperty(s..'.frame.uv.y'),
        getProperty(s..'.frame.uv.width'),
        getProperty(s..'.frame.uv.height')
    })
end
