function onCreatePost()
    initLuaShader("VCR")
    initLuaShader("crt")
    initLuaShader("ntsc")
    initLuaShader("rain")
    initLuaShader("bloom")
    initLuaShader("saturation")
    
    makeLuaSprite("chromatic")
    makeGraphic("chromatic", screenWidth, screenHeight)
    
    setSpriteShader("chromatic", "VCR")
	
	
	
	makeLuaSprite("VHS")
    makeGraphic("VHS", screenWidth, screenHeight)
	
	makeLuaSprite("crt")
    makeGraphic("crt", screenWidth, screenHeight)

	makeLuaSprite("ntsc")
    makeGraphic("ntsc", screenWidth, screenHeight)
	
	makeLuaSprite("rain")
    makeGraphic("rain", screenWidth, screenHeight)
	
	makeLuaSprite("bloom")
    makeGraphic("bloom", screenWidth, screenHeight)
   
        setSpriteShader("chromatic", "VCR")
    setSpriteShader("bloom", "bloom")
    addHaxeLibrary("ShaderFilter", "openfl.filters")
    checkChrom();
end

function setChrome(chromeOffset)
    setShaderFloat("chromatic", "rOffset", chromeOffset);
    setShaderFloat("chromatic", "gOffset", 0.0);
    setShaderFloat("chromatic", "bOffset", chromeOffset * -1);
end

function checkChrom()
    setChrome(0.0020);
end

function onStepHit()
    if curStep == 768 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
	end

    if curStep == 904 then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

       if curStep == 1536 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end

       if curStep == 1544 then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

       if curStep == 1552 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end
 
      if curStep == 1558 then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end
 
     if curStep == 1564 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end 

     if curStep == 1568    then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

     if curStep == 1576   then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end 

     if curStep == 1584   then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

      if curStep == 1590 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end 
 
     if curStep == 1596 then
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

    if curStep == 1600 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end 

     if curStep == 1608 then 
        runHaxeCode([[
        game.camGame.setFilters([]);
        game.camHUD.setFilters([]);
    ]])
    end

    if curStep == 1616 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end 


     if curStep == 2803 then
        runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
    ]])
    end
end

function onUpdate(elapsed)
    setShaderFloat('bloom', 'iTime', os.clock())
end