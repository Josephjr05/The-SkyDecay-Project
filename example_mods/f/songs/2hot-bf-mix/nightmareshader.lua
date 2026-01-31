--Chromatic Abbretion shader, Original and remaster by sirFerzy!

function onCreate()
    if shadersEnabled then
        setVar('chromStrength',0); --How strong you want the shader, set with setProperty
        setVar('chromMult',1); --This amplifies the  chromStrength, default is 1
        setVar('chromSpeed',8); --This is how fast the shader fades out
    end
end
function onCreatePost()
    if shadersEnabled then
    initLuaShader('ferzyShader')
    makeLuaSprite("chromAbr")
    makeGraphic("chromAbr", 1, 1)
    setSpriteShader("chromAbr", 'ferzyShader')
    addHaxeLibrary("ShaderFilter", "openfl.filters")
    runHaxeCode([[
        trace(ShaderFilter);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromAbr").shader)]);
        game.camGame.filters.push(new ShaderFilter(game.getLuaObject('chromAbr').shader));
    ]])
    
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
    local lerpSpeed = getProperty('chromSpeed')
    if curStep >= 2464 and curStep <= 2472 then
      setProperty('chromStrength', math.lerp(getProperty('chromStrength'), 0.3, elapsed * lerpSpeed))
     else
      setProperty('chromStrength', math.lerp(getProperty('chromStrength'), 0.0, elapsed * lerpSpeed))
      end
    setShaderFloat('chromAbr', 'force', getProperty('chromStrength') * getProperty('chromMult'))
    end
end



function math.lerp(from, to, i)
    return from + (to - from) * i
end


function onBeatHit()
   if (curStep > 2383 and curStep < 2735 or curStep > 846 and curStep < 1023 or curStep > 1039 and curStep < 1105) then
        if curBeat % 1 == 0 then
            triggerEvent('Add Camera Zoom','','')
            if shadersEnabled == true then
         setProperty('chromStrength', getProperty('chromStrength') + 0.2)
            end
        end
   end
end
