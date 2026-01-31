--Script by Villagecool, yeah go and use for your own thing, just dont remove this watermark
-- if you wanna credit me in your mod heres my icon -> https://cdn.discordapp.com/attachments/1040970622542565406/1098013024117342309/Villagecool.png
local pixela = false
local pxSize = 0
function onCreatePost()
	runHaxeCode([[
		game.initLuaShader('pixel');

		shader0 = game.createRuntimeShader('pixel');
		shader0.setFloat('pxSize',0.1);

		game.camGame.setFilters([new ShaderFilter(shader0)]);
		game.camHUD.setFilters([new ShaderFilter(shader0)]);
	]])
end
function onEvent(n,v1,v2)
    if n == 'Pixel Zoom' then
		pixelate(v1)
    end
end
function onUpdate()
	if pixela == true then
		pxSize = pxSize+0.05
	else
		pxSize = 0.01
	end
		runHaxeCode(' shader0.setFloat(\'pxSize\','..pxSize..');')
end

timers = {}
function ezTimer(tag, timer, callback) -- Better
     table.insert(timers,{tag, callback})
     runTimer(tag, timer)
end

function onTimerCompleted(tag)
     for k,v in pairs(timers) do
          if v[1] == tag then
               v[2]()
          end
     end
end
function pixelate(time)
	pixela = true
    togglePixel(true)
	ezTimer('pixelate', time, function() togglePixel(false) end)
end
function togglePixel(bool)
    if bool == true then
        runHaxeCode([[
            game.initLuaShader('pixel');
    
            shader0 = game.createRuntimeShader('pixel');
            shader0.setFloat('pxSize',0.01);
    
            game.camGame.setFilters([new ShaderFilter(shader0)]);
            game.camHUD.setFilters([new ShaderFilter(shader0)]);
        ]])
    else
        pixela = false
        pxSize = 0.01
        runHaxeCode([[
            game.camGame.setFilters([]);
            game.camHUD.setFilters([]);
        ]])
    end
end