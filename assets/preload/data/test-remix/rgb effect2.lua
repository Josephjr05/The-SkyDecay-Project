local shaderName = "rgb effect2"
function onCreate()
    shaderCoordFix() -- initialize a fix for textureCoord when resizing game window

    makeLuaSprite("rgb effect2")
    makeGraphic("shaderImage", screenWidth, screenHeight)

   setSpriteShader("shaderImage", "rgb effect2")


    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        
        game.initLuaShader(shaderName);
        
        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("rgb effect2").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("rgb effect2").shader)]);
        return;
    ]])
end

function onUpdate(elapsed)
    setShaderFloat("rgb effect2", "iTime", os.clock())
 end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end