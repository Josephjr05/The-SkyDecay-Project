function onEvent(name, value1, value2)

    if name == "Spawn Particles" then

        for i=1,value1 do	
    
          makeLuaSprite(
    
            i,
    
            value2,
    
            math.random(0,screenWidth),
    
            math.random(-5,5)
    
          )
          addLuaSprite(i, false);
    
        end

    end

end