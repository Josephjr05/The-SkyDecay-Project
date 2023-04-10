--Coding Game
local noflashy
function onCreate()
    noflashy = getPropertyFromClass('flixel.FlxG','save.data.noFlashy')
    if noflashy then
        makeLuaSprite('Colorful')
        makeGraphic("Colorful",2500, 600, "FFFFFF")
        setProperty('Colorful.alpha',0)
        addLuaSprite('Colorful',true)
        scaleObject('Colorful',10000,10000)
        setProperty('Colorful.y',-560)
        setProperty('Colorful.x',-1560)
        setBlendMode('Colorful','add')

        makeLuaSprite('ColorfulR')
        makeGraphic("ColorfulR",2500, 600, "FFFFFF")
        setProperty('ColorfulR.alpha',0)
        addLuaSprite('ColorfulR',true)
        scaleObject('ColorfulR',10000,10000)
        setProperty('ColorfulR.y',-560)
        setProperty('ColorfulR.x',-1560)
        setBlendMode('ColorfulR','add')

        makeLuaSprite('flash')
        makeGraphic("flash",2500, 600, "FFFFFF")
        setProperty('flash.alpha',0)
        addLuaSprite('flash',true)
        scaleObject('flash',10000,10000)
        setProperty('flash.y',-560)
        setProperty('flash.x',-1560)
        setBlendMode('flash','add')

        makeLuaSprite('dark')
        makeGraphic("dark",2500, 600, "000000")
        setProperty('dark.alpha',0.8)
        addLuaSprite('dark',true)
        scaleObject('dark',10000,10000)
        setProperty('dark.y',-560)
        setProperty('dark.x',-1560)
        setBlendMode('dark','divide')
    end
    doTweenAlpha('winAlpha','win',0,0.0001)
end
--[[function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then
		startDialogue('dialogue', 'dialogue');
	end
end]]

stepHitFuncs = { --Old Code... yeah u know
    [128] = function()
        if not lowQuality then
            doTweenY('frontTweenY', 'front', -613, 1.5, 'quartInOut');
            doTweenY('backTweenY', 'back', -668, 0.0001);
            doTweenZoom('CamGamTweenZoom','camGame',0.46, 1.5,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',0.8, 1.5, 'quartInOut');
        end
    end,
    [384] = function()
	  if not lowQuality then
            doTweenY('frontTweenY', 'front', -98, 2, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.58, 2,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',1, 2, 'quartInOut');
        end
     end,
     [626] = function()
        if not lowQuality then
            doTweenY('frontTweenY', 'front', -613, 1.5, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.42, 1.5,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',0.69, 1.5, 'quartInOut');
        end
    end,
    [1152] = function()
	  if not lowQuality then
            doTweenY('frontTweenY', 'front', -98, 2, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.58, 2,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',1, 2, 'quartInOut');
        end
     end,
    [1536] = function()
        if not lowQuality then
            setProperty('ChartPart1.alpha',0)
            setProperty('ChartPart2.alpha',1)
        end
    end,
    [1658] = function()
        if not lowQuality then
            doTweenY('frontTweenY', 'front', -613, 1.5, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.46, 1.5,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',0.8, 1.5, 'quartInOut');
        end
    end,
    [1920] = function()
	  if not lowQuality then
            doTweenY('frontTweenY', 'front', -98, 2, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.58, 2,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',1, 2, 'quartInOut');
        end
     end,
     [2162] = function()
        if not lowQuality then
            doTweenY('frontTweenY', 'front', -613, 1.5, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.42, 1.5,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',0.69, 1.5, 'quartInOut');
        end
    end,
    [2432] = function()
	  if not lowQuality then
            doTweenY('frontTweenY', 'front', -98, 2, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.58, 2,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',1, 2, 'quartInOut');
        end
     end,
    [2616] = function()
        if not lowQuality then
            doTweenY('frontTweenY', 'front', -613, 1, 'quartInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.42, 1,'quartInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',0.69, 1, 'quartInOut');
        end
    end,
    [2875] = function()
	  if not lowQuality then
            doTweenY('frontTweenY', 'front', -98, 1, 'backInOut');
            doTweenZoom('CamGamTweenZoom','camGame',0.58, 1,'backInOut');
            doTweenZoom('CamHUDTweenZoom','camHUD',1, 1, 'backInOut');
        end
     end,
}
function followchart()
    if followchars == true then
        if mustHitSection == false then
                if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
				   triggerEvent('Camera Follow Pos',xx-ofs,yy)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                   triggerEvent('Camera Follow Pos',xx+ofs,yy)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',xx,yy-ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                   triggerEvent('Camera Follow Pos',xx,yy+ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT-alt' then
                    triggerEvent('Camera Follow Pos',xx-ofs,yy)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT-alt' then
                    triggerEvent('Camera Follow Pos',xx+ofs,yy)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singUP-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy-ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy+ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'idle-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx,yy)
                end
            else
                if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
			objectPlayAnimation('camelliaReflection','singLEFT', false);
			setProperty('camelliaReflection.offset.x',92)
			setProperty('camelliaReflection.offset.y',0)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
			objectPlayAnimation('camelliaReflection','singRIGHT', false);
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
			objectPlayAnimation('camelliaReflection','singUP', false);
			setProperty('camelliaReflection.offset.x',-2)
			setProperty('camelliaReflection.offset.y',0)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
			objectPlayAnimation('camelliaReflection','singDOWN', false);
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx2,yy2)
			objectPlayAnimation('camelliaReflection','Idle', true);
                end
            end
        else
            triggerEvent('Camera Follow Pos','','')
        end
    end
local noteXCenter = {412,524,636,748}

function onBack()
        noteTweenX('5pX', 4, defaultPlayerStrumX0, 1.6,'quartinout')
        noteTweenX('6pX', 5, defaultPlayerStrumX1, 1.6,'quartinout')
        noteTweenX('7pX', 6, defaultPlayerStrumX2, 1.6,'quartinout')
        noteTweenX('8pX', 7, defaultPlayerStrumX3, 1.6,'quartinout')

        noteTweenX('5OpX', 0, defaultOpponentStrumX0, 1.6,'quartinOut')
        noteTweenX('6OpX', 1, defaultOpponentStrumX1, 1.6,'quartinOut')
        noteTweenX('7OpX', 2, defaultOpponentStrumX2, 1.6,'quartinOut')
        noteTweenX('8OpX', 3, defaultOpponentStrumX3, 1.6,'quartinOut')
end
function onSongStart()
    setProperty('Mod by.alpha',1)
end
function onStepHit()
    if stepHitFuncs[curStep] then 
        stepHitFuncs[curStep]()
    end
    if curStep == 32 then
        setProperty('Mod by.alpha',0)
        setProperty('Song and Cover.alpha',1)
    end
    if curStep == 48 then
        setProperty('Cover.alpha',1)
    end
    if curStep == 64 then
        doTweenAlpha('Song and CoverAlpha','Song and Cover',0,4)
        doTweenAlpha('CoverAlpha','Cover',0,4)
    end
    if curStep < 99999 and curStep %16 == 0 then
        --doTweenColor('wincolor','win',math.random(getColorFromHex('FF0000','00FF21','E200FF','FF6600','0087FF')),0.0001)
        setProperty('win.color',math.random(getColorFromHex('FF0000','8fce00','E200FF','FF6600','00AFFF')))-- very random
        setProperty('SpotLights.color',math.random(getColorFromHex('FF0000','8fce00','E200FF','FF6600','00AFFF')))-- very random
        setProperty('SpotLights2.color',math.random(getColorFromHex('FF0000','8fce00','E200FF','FF6600','00AFFF')))-- very random
        setProperty('SpotLights3.color',math.random(getColorFromHex('FF0000','8fce00','E200FF','FF6600','00AFFF')))-- very random
        setProperty('SpotLights4.color',math.random(getColorFromHex('FF0000','8fce00','E200FF','FF6600','00AFFF')))-- very random
    end
    if curStep < 99999 and curStep %4 == 0 then
        setProperty('Colorful.color',math.random(getColorFromHex('FF0000'))) -- very random
        objectPlayAnimation('speaker','speakerL', true);--fail
        objectPlayAnimation('speaker2','speakerL', true);--fail
        objectPlayAnimation('speaker3','speakerR', true);--fail
        objectPlayAnimation('speaker4','speakerR', true);--fail Why? IDK HEHE...
    end
    if curStep < 99999 and curStep %2 == 0 then
        setProperty('ColorfulR.color',math.random(getColorFromHex('FF0000'))) -- very random
    end
    if curStep < 99999 and curStep %8 == 0 then
        doTweenX('FrontScaleX','front.scale',1.9,0.0001)
        doTweenX('FrontScaleXs','front.scale',1.78,0.4,'quartOut')
        doTweenY('FrontScaleY','front.scale',1.9,0.0001)
        doTweenY('FrontScaleYs','front.scale',1.78,0.4,'quartOut')
        doTweenX('BackScaleX','back.scale',1.8,0.0001)
        doTweenX('BackScaleXs','back.scale',1.78,0.4,'quartOut')
        doTweenY('BackScaleY','back.scale',1.8,0.0001)
        doTweenY('BackScaleYs','back.scale',1.78,0.4,'quartOut')
    end--------------MODCAM By Verdianz
    if curStep == 128 then
        for i = 0,7 do
            noteTweenAlpha('noteAlpha'..i,i,1,0.5,'expoout')
        end
        onBack()
    end
    

    if curStep == 148 
    or curStep == 160
    or curStep == 176
    or curStep == 192
    or curStep == 208 
    or curStep == 224
    or curStep == 240
    or curStep == 256 
    or curStep == 272
    or curStep == 288
    or curStep == 304
    or curStep == 320
    or curStep == 336
    or curStep == 352
    or curStep == 368 then
        doTweenZoom('CamGamTweenZoom','camGame',0.47, 0.001);
        doTweenZoom('CamHUDTweenZoom','camHUD',0.85, 0.001);
        doTweenZoom('CamGamTweenZooms','camGame',0.46, 0.75,'quartOut');
        doTweenZoom('CamHUDTweenZooms','camHUD',0.8, 0.7, 'quartOut');
    end
    if curStep >= 410 and curStep < 447 and curStep %4 == 0 then
        doTweenZoom('CamGamTweenZoom','camGame',0.6, 0.001);
        doTweenZoom('CamHUDTweenZoom','camHUD',1.05, 0.001);
        doTweenZoom('CamGamTweenZooms','camGame',0.58, 0.75,'quartOut');
        doTweenZoom('CamHUDTweenZooms','camHUD',1, 0.7, 'quartOut');
    end
    if curStep >= 447 and curStep < 511 and curStep %3 == 0 then
        doTweenZoom('CamGamTweenZoom','camGame',0.62, 0.001);
        doTweenZoom('CamHUDTweenZoom','camHUD',1.09, 0.001);
        doTweenZoom('CamGamTweenZooms','camGame',0.58, 0.75,'quartOut');
        doTweenZoom('CamHUDTweenZooms','camHUD',1, 0.7, 'quartOut');
    end
    if curStep == 512 then-------------
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 0.15, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0,1, 0.001)
        noteTweenAlpha('6OAlpha', 1,1, 0.001)
        noteTweenAlpha('7OAlpha', 2,0.15, 0.001)
        noteTweenAlpha('8OAlpha', 3,0.15, 0.001)
    end
    if curStep == 515 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0,1, 0.001)
        noteTweenAlpha('6OAlpha', 1,1, 0.001)
        noteTweenAlpha('7OAlpha', 2,0.15, 0.001)
        noteTweenAlpha('8OAlpha', 3,0.15, 0.001)
    end
    if curStep == 517 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 0.15, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 1, 0.001)

        noteTweenAlpha('5OAlpha', 0,0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1,1, 0.001)
        noteTweenAlpha('7OAlpha', 2,1, 0.001)
        noteTweenAlpha('8OAlpha', 3,1, 0.001)
    end
    if curStep == 521 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 524 then
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 0.15, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 526 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 0.15, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 1, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 0.15, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 528 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 530 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 0.15, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 534 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 537 then
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 1, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end---------------------------------
    if curStep == 544 then-------------
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 547 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0,1, 0.001)
        noteTweenAlpha('6OAlpha', 1,1, 0.001)
        noteTweenAlpha('7OAlpha', 2,0.15, 0.001)
        noteTweenAlpha('8OAlpha', 3,0.15, 0.001)
    end
    if curStep == 550 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0,0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1,1, 0.001)
        noteTweenAlpha('7OAlpha', 2,1, 0.001)
        noteTweenAlpha('8OAlpha', 3,1, 0.001)
    end
    if curStep == 553 then
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 0.15, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 0.15, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 556 then
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 0.15, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 558 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 560 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 0.15, 0.001)
    end
    if curStep == 563 then
        noteTweenAlpha('5pAlpha', 4, 0.15, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 0.15, 0.001)

        noteTweenAlpha('5OAlpha', 0, 0.15, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    if curStep == 566 then
        noteTweenAlpha('5pAlpha', 4, 1, 0.001)
        noteTweenAlpha('6pAlpha', 5, 1, 0.001)
        noteTweenAlpha('7pAlpha', 6, 1, 0.001)
        noteTweenAlpha('8pAlpha', 7, 1, 0.001)

        noteTweenAlpha('5OAlpha', 0, 1, 0.001)
        noteTweenAlpha('6OAlpha', 1, 1, 0.001)
        noteTweenAlpha('7OAlpha', 2, 1, 0.001)
        noteTweenAlpha('8OAlpha', 3, 1, 0.001)
    end
    ---------------------------------
    if curStep >= 512 and curStep < 540 and curStep %3 == 0
    or curStep >= 544 and curStep < 570 and curStep %3 == 0 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphsa','win',0,0.3,'expoIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.3,'expoIn')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.3,'expoIn')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.3,'expoIn')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.3,'expoIn')
    end
    if curStep == 576 or curStep == 578 or curStep == 580
    or curStep == 584 or curStep == 586 or curStep == 588
    or curStep == 592 or curStep == 594 or curStep == 596
    or curStep == 600 or curStep == 602 or curStep == 604 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 608 and curStep < 624 and curStep %3 == 0 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 640 and curStep < 895 and curStep %4 == 0
    or curStep >= 1024 and curStep < 1136 and curStep %4 == 0
    or curStep >= 1664 and curStep < 1792 and curStep %4 == 0
    or curStep >= 2176 and curStep < 2415 and curStep %4 == 0
    or curStep >= 2432 and curStep < 2560 and curStep %4 == 0 then
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlpha','win',1,0.001)
        --doTweenAlpha('winAlphas','win',0,0.6,'expoOut')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.15,'expoIn')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.15,'expoIn')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.15,'expoIn')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.15,'expoIn')
    end
    if curStep >= 643 and curStep < 880 and curStep %4 == 0 
    or curStep >= 896 and curStep < 960 and curStep %4 == 0
    or curStep >= 1026 and curStep < 1088 and curStep %4 == 0 then
        doTweenZoom('beatGame','camGame',0.47, 0.001)
        doTweenZoom('beatHud','camHUD',0.74, 0.001)
    end
    if curStep >= 2176 and curStep < 2415 and curStep %4 == 0 then
        doTweenAlpha('ColorfulAlpha','Colorful',0.55,0.001)
        doTweenAlpha('ColorfulAlphas','Colorful',0.4,0.25,'expoIn')
    end
    if curStep == 903 or curStep == 1793 or curStep == 2432 or curStep == 2560 then
        doTweenAlpha('winAlpha','win',1,2)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,2)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,2)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,2)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,2)
        doTweenAlpha('darkAlpha','dark',0,2)
    end
    if curStep == 1200 then
        doTweenAlpha('winAlpha','win',1,2)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,2)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,2)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,2)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,2)
    end
    if curStep == 1216 or curStep == 1218 or curStep == 1220
    or curStep == 1224 or curStep == 1226 or curStep == 1228
    or curStep == 1232 or curStep == 1233 or curStep == 1235
    or curStep == 1240 or curStep == 1242 or curStep == 1244 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 1248 and curStep < 1264 and curStep %3 == 0 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep == 1504 then
        doTweenY('frontTweenY', 'front', -613, 1.6, 'quartInOut');
        doTweenZoom('CamGamTweenZoom','camGame',0.42, 1.6,'quartInOut');
        doTweenZoom('CamHUDTweenZoom','camHUD',0.69, 1.6, 'quartInOut');
    end
    if curStep == 1276 or curStep == 1344 or curStep == 1408 or curStep == 1472 or curStep == 1488 then
        doTweenY('frontTweenY', 'front', -613, 0.6, 'quartOut');
        doTweenZoom('CamGamTweenZoom','camGame',0.42, 0.6,'quartOut');
        doTweenZoom('CamHUDTweenZoom','camHUD',0.69, 0.6, 'quartOut');
    end
    if curStep == 1312 or curStep == 1375 or curStep == 1440 or curStep == 1480 or curStep == 1497 or curStep == 1536 then
        doTweenY('frontTweenY', 'front', -98, 0.6, 'quartOut');
        doTweenZoom('CamGamTweenZoom','camGame',0.58, 0.6,'quartOut');
        doTweenZoom('CamHUDTweenZoom','camHUD',1, 0.6, 'quartOut');
    end
    if curStep >= 1280 and curStep < 1286 and curStep %3 == 0
    or curStep >= 1288 and curStep < 1310 and curStep %1 == 0
    or curStep >= 1344 and curStep < 1350 and curStep %3 == 0
    or curStep >= 1352 and curStep < 1375 and curStep %1 == 0
    then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep == 1408 then
        doTweenAlpha('winAlpha','win',1,2)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,2)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,2)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,2)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,2)
    end
    if curStep >= 1504 and curStep < 1546 and curStep %3 == 0
    then
            doTweenAlpha('winAlpha','win',1,0.001)
            doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
            doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
            doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
            doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
            doTweenAlpha('winAlphas','win',0,0.01,'QuartIn')
            doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
            doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
            doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
            doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 1664 and curStep < 1793 and curStep %4 == 0
    then
            doTweenAlpha('winAlpha','win',1,0.001)
            doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
            doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
            doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
            doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
            doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
            doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
            doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
            doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
            doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep == 1800 then
            doTweenAlpha('winAlpha','win',1,2)
            doTweenAlpha('SpotLightsAlpha','SpotLights',1,2)
            doTweenAlpha('SpotLights2Alpha','SpotLights2',1,2)
            doTweenAlpha('SpotLights3Alpha','SpotLights3',1,2)
            doTweenAlpha('SpotLights4Alpha','SpotLights4',1,2)
    end
    if curStep == 1920 then
        doTweenAlpha('winAlpha','win',0,2)
        doTweenAlpha('SpotLightsAlpha','SpotLights',0,2)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',0,2)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',0,2)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',0,2)
    end
    if curStep >= 2048 and curStep < 2108 and curStep %4 == 0
    then
            doTweenAlpha('winAlpha','win',1,0.001)
            doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
            doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
            doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
            doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
            doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
            doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
            doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
            doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
            doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep == 2113 or curStep == 2114 or curStep == 2116
    or curStep == 2119 or curStep == 2121 or curStep == 2123
    or curStep == 2129 or curStep == 2131 or curStep == 2133
    or curStep == 2135 or curStep == 2137 or curStep == 2139 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 2625 and curStep < 2655 and curStep %3 == 0
    or curStep >= 2689 and curStep < 2717 and curStep %3 == 0
    or curStep >= 2753 and curStep < 2781 and curStep %3 == 0
    or curStep >= 2817 and curStep < 2823 and curStep %3 == 0
    or curStep >= 2833 and curStep < 2839 and curStep %3 == 0
    or curStep >= 2849 and curStep < 2870 and curStep %3 == 0 then
        doTweenAlpha('winAlpha','win',1,0.001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
        doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
        doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
        doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
        doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
        doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    if curStep >= 2656 and curStep < 2659 and curStep %1 == 0
    or curStep >= 2720 and curStep < 2749 and curStep %1 == 0
    or curStep >= 2784 and curStep < 2813 and curStep %1 == 0
    or curStep >= 2824 and curStep < 2831 and curStep %1 == 0
    or curStep >= 2841 and curStep < 2847 and curStep %1 == 0
    or curStep >= 2871 and curStep < 2880 and curStep %1 == 0


    then
            doTweenAlpha('winAlpha','win',1,0.001)
            doTweenAlpha('SpotLightsAlpha','SpotLights',1,0.001)
            doTweenAlpha('SpotLights2Alpha','SpotLights2',1,0.001)
            doTweenAlpha('SpotLights3Alpha','SpotLights3',1,0.001)
            doTweenAlpha('SpotLights4Alpha','SpotLights4',1,0.001)
            doTweenAlpha('winAlphas','win',1,0.01,'QuartIn')
            doTweenAlpha('SpotLightsAlphas','SpotLights',0,0.12,'expoin')
            doTweenAlpha('SpotLights2Alphas','SpotLights2',0,0.12,'expoin')
            doTweenAlpha('SpotLights3Alphas','SpotLights3',0,0.12,'expoin')
            doTweenAlpha('SpotLights4Alphas','SpotLights4',0,0.12,'expoin')
    end
    -----Visual------
    if curStep == 128 or curStep == 1658 then
        doTweenAlpha('winAlpha','win',1,2)
        doTweenAlpha('SpotLightsAlpha','SpotLights',1,2)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',1,2)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',1,2)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',1,2)
        doTweenAlpha('darkAlpha','dark',0,2)
    end
    if curStep == 640 or curStep == 2176 then
        doTweenAlpha('ColorfulAlpha','Colorful',0.4,1)
        setProperty('dark.alpha',0)
        setProperty('flash.alpha',1)
        doTweenAlpha('flashAlpha','flash',0,1)
    end
    if curStep == 1152 or curStep == 2592 then
        doTweenAlpha('ColorfulAlpha','Colorful',0,1)
    end
    if curStep == 1312 or curStep == 1376 or curStep == 1440
    or curStep == 1481 or curStep == 1497 or curStep == 2656
    or curStep == 2720 or curStep == 2784 or curStep == 2825
    or curStep == 2841 then
        doTweenAlpha('ColorfulRAlpha','ColorfulR',0.4,0.0001)
    end
    if curStep == 1344 or curStep == 1408 or curStep == 1472
    or curStep == 1488 or curStep == 1504 or curStep == 1536
    or curStep == 2688 or curStep == 2752 or curStep == 2816
    or curStep == 2832 or curStep == 2848 then
        doTweenAlpha('ColorfulRAlpha','ColorfulR',0,0.0001)
    end
    if curStep == 1505 or curStep == 2849 then
        doTweenAlpha('ColorfulRAlpha','ColorfulR',0.6,3)
    end
    if curStep == 1536 then
        setProperty('dark.alpha',0.8)
        setProperty('flash.alpha',1)
        doTweenAlpha('flashAlpha','flash',0,1)
        doTweenAlpha('ColorfulRAlpha','ColorfulR',0,0.0001)
        doTweenAlpha('winAlpha','win',0,0.0001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',0,0.0001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',0,0.0001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',0,0.0001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',0,0.0001)
    end
    if curStep == 1920 then
        doTweenAlpha('ColorfulAlpha','Colorful',0,1)
    end
    if curStep >= 2176 and curStep < 2288 and curStep %4 == 0 
    or curStep >= 2308 and curStep < 2359 and curStep %4 == 0
    or curStep >= 2368 and curStep < 2380 and curStep %4 == 0
    or curStep >= 2384 and curStep < 2396 and curStep %4 == 0
    or curStep >= 2400 and curStep < 2415 and curStep %4 == 0 then
        doTweenZoom('beatGame','camGame',0.47, 0.001)
        doTweenZoom('beatHud','camHUD',0.74, 0.001)
    end
    if curStep == 2880 then
        setProperty('flash.alpha',1)
        doTweenAlpha('flashAlpha','flash',0,1)
        doTweenAlpha('ColorfulRAlpha','ColorfulR',0,0.0001)
        doTweenAlpha('winAlpha','win',0,0.0001)
        doTweenAlpha('SpotLightsAlpha','SpotLights',0,0.0001)
        doTweenAlpha('SpotLights2Alpha','SpotLights2',0,0.0001)
        doTweenAlpha('SpotLights3Alpha','SpotLights3',0,0.0001)
        doTweenAlpha('SpotLights4Alpha','SpotLights4',0,0.0001)
    end
end
function onTweenCompleted(tag)
    if tag == 'beatGame' then
        doTweenZoom('CamGamTweenZooms','camGame',0.42, 0.8,'quartOut')
        doTweenZoom('CamHUDTweenZooms','camHUD',0.69, 0.8, 'quartOut')
    end
end
function onUpdate()
    if (curStep < 2 ) then
        for i = 0,7 do
            noteTweenX('noteX'..i,i,noteXCenter[(i %4)+1],0.001,'quintInOut')
        end
        for i = 0,3 do
            noteTweenAlpha('noteAlpha'..i,i,0.3,0.5,'expoOut')
        end
    end
    TimeBar = {'timeBar','timeBarBG', 'timeTxt'}
    for x = 1,10 do
        setProperty(TimeBar[x]..'.x', 100) 
    end
end