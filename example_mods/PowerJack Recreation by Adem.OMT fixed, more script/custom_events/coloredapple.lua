--Don't change plz
converted = false

function onCreate()

--On case you wanted personalized for some songs

customforsong = {'YourSong1','YourSong2'}

--Change these on case that your characters,stage or both are too far lmfao
x = -1000
y = -600

--Weird scale to make it bigger or smaller the bg
xs = 3
ys = 3

--BG Color (Hexadecimal)
color = '000000'

--On case you want some of the 3 characters with custom colors

CustomBF = false

CustomDAD = false

CustomGF = false

--Remember that this uses RGB
rgbbf = {0,0,0}

rgbdad = {0,0,0}

rgbgf = {0,0,0}

--End of custom colors

--Custom shit for specific songs[make sure you added your song there] (ignore if you don't want to override the shit)
	for _, s in pairs(customforsong) do
		if songName == s then
		x = -1000
		y = -600
		xs = 3
		ys = 3
		color = '000000'
		CustomBF = false
		CustomGF = false
		CustomDAD = false
		rgbbf = {0,0,0}
		rgbdad = {0,0,0}	
		rgbgf = {0,0,0}
		end
	end
end


function onCreatePost()

    	getcolor()
	bgshit()

	--You can add here your hud elements on case you need it
	ui = {'iconP1','iconP2','healthBar','healthBarBG'}
		
end

function getcolor()
	if not CustomBF then
      		rgbbf = {getProperty('boyfriend.healthColorArray[0]'),getProperty('boyfriend.healthColorArray[1]'),getProperty('boyfriend.healthColorArray[2]')}
	end

	if not CustomDAD then
		rgbdad = {getProperty('dad.healthColorArray[0]'), getProperty('dad.healthColorArray[1]'), getProperty('dad.healthColorArray[2]')}
	end
	
	if not CustomGF then
		rgbgf = {getProperty('gf.healthColorArray[0]'),getProperty('gf.healthColorArray[1]'),getProperty('gf.healthColorArray[2]')}
	end

--Mess up here on case you want to hide some of the characters or idk
--Plz make sure about what are you doing here (is basically automatic black or white color)
--Based on the bg's color (only black and white supported)

	if color == '000000' then	
			if rgbbf[1] == 0 and rgbbf[2] == 0 and rgbbf[3] == 0 then
				for i = 0,3 do
					rgbbf[i] = 255
				end
			end
			if rgbdad[1] == 0 and rgbdad[2] == 0 and rgbdad[3] == 0 then
				for i = 0,3 do
					rgbdad[i] = 255
				end
			end
			if rgbgf[1] == 0 and rgbgf[2] == 0 and rgbgf[3] == 0 then
				for i = 0,3 do
					rgbgf[i] = 255
				end
			end
	elseif color == 'FFFFFF' then
			if rgbbf[1] == 255 and rgbbf[2] == 255 and rgbbf[3] == 255 then
				for i = 0,3 do
					rgbbf[i] = 255
				end
			end
			if rgbdad[1] == 255 and rgbdad[2] == 255 and rgbdad[3] == 255 then
				for i = 0,3 do
					rgbdad[i] = 255
				end
			end
			if rgbgf[1] == 255 and rgbgf[2] == 255 and rgbgf[3] == 255 then
				for i = 0,3 do
					rgbgf[i] = 255
				end
			end
	end
end

function bgshit()
		makeLuaSprite('ov', '',x,y)
		makeGraphic('ov', 2000, 2000,color)
		scaleObject('ov', xs, ys)
		setProperty('ov.alpha',0.0001)
		addLuaSprite('ov',false)
end

function onEvent(n,v1,v2)
      if n == 'coloredapple' then
		if v1 == '' or v1 == '0' then
			v1 = 0.1
		end
				if v2 ~= '' then

					doTweenZoom('zoomingyey','camGame',v2,v1,'sineInOut')
				end

            	if not converted then
              		converted = true
			doTweenAlpha('fadingov','ov',1,v1)
					for _, u in pairs(ui) do
						doTweenAlpha('fading'..u,u,0.0001,v1)
					end
        		runHaxeCode([[
        			FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..rgbbf[1]..[[, greenOffset: ]]..rgbbf[2]..[[, blueOffset: ]]..rgbbf[3]..[[, redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0 }, ]]..v1..[[);
    				FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..rgbdad[1]..[[, greenOffset: ]]..rgbdad[2]..[[, blueOffset: ]]..rgbdad[3]..[[, redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0 }, ]]..v1..[[);
    			]])
				if getProperty('gf.visible') or getProperty('gf.alpha') > 0 then
					runHaxeCode([[
        			    		FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..rgbgf[1]..[[, greenOffset: ]]..rgbgf[2]..[[, blueOffset: ]]..rgbgf[3]..[[, redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0 }, ]]..v1..[[);
    					]])
				end
          	else
			converted = not converted
			doTweenAlpha('fadingov','ov',0.0001,v1)
					for _, u in pairs(ui) do
						doTweenAlpha('fading'..u,u,1,v1)
					end
        		runHaxeCode([[
        			FlxTween.tween(game.boyfriend.colorTransform, { redOffset: 0, greenOffset: 0, blueOffset: 1, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1 }, ]]..v1..[[);
    				FlxTween.tween(game.dad.colorTransform, { redOffset: 0, greenOffset: 0, blueOffset: 0, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1 }, ]]..v1..[[);
				
    			]])
				if getProperty('gf.visible') or getProperty('gf.alpha') > 0 then
					runHaxeCode([[
        			    		FlxTween.tween(game.gf.colorTransform, { redOffset: 0, greenOffset: 0, blueOffset: 0, redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1 }, ]]..v1..[[);
    					]])
				end
          	end

      elseif n == 'Change Character' then
      		getcolor()
      end
end

function onTweenCompleted(t)
	if t == 'zoomingyey' then
		setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	end
end