function onCreate()
	makeLuaSprite('skyAdditive', 'phillyBlazin/skyBlurErect', -600, -175);
	scaleObject('skyAdditive', 1.75, 1.75);
	setScrollFactor('skyAdditive', 0, 0);
	
	makeAnimatedLuaSprite('lightning', 'phillyBlazin/lightning', 50, -300);
	addAnimationByPrefix('lightning', 'strike', 'lightning0', 24, false);
	setProperty('lightning.flipX', false);
	scaleObject('lightning', 1.75, 1.75);
	setScrollFactor('lightning', 0, 0);
	setProperty('lightning.alpha', 0);
	runTimer('lightningTimer', getRandomInt(7, 15));
	
	makeLuaSprite('phillyForegroundCity', 'phillyBlazin/streetBlurErect', -600, -175);
	scaleObject('phillyForegroundCity', 1.75, 1.75);
	setScrollFactor('phillyForegroundCity', 0, 0);
	
	makeLuaSprite('foregroundMultiply', 'phillyBlazin/', -600, -175);
	scaleObject('foregroundMultiply', 1, 1);
	setScrollFactor('foregroundMultiply', 1, 1);
	
	makeLuaSprite('additionalLighten', 'empty', -600, -175);
	makeGraphic('additionalLighten', 2500, 2500, 'FFFFFF');
	setScrollFactor('additionalLighten', 0, 0);
	setProperty('additionalLighten.alpha', 0);

	addLuaSprite('skyAdditive', false);
	addLuaSprite('lightning', false);
	addLuaSprite('phillyForegroundCity', false);
	addLuaSprite('foregroundMultiply', false);
	addLuaSprite('additionalLighten', false);
end

function onSongStart()
	setProperty('lightning.alpha', 1);
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'lightningTimer' then
		playAnim('lightning', 'strike', false);
		playSound('lightning/Lightning'..getRandomInt(1, 3), 1)
		runTimer('lightningTimer', getRandomInt(7, 15));
		setProperty('additionalLighten.alpha', 0.3);
		doTweenAlpha('additionalLighten', 'additionalLighten', 0, 1, 'linear')
	end
end

function onStartCountdown()
	setProperty('dad.scale.x', 1.75);
	setProperty('dad.scale.y', 1.75);
	setProperty('boyfriend.scale.x', 1.75);
	setProperty('boyfriend.scale.y', 1.75);
end

function onCreatePost()
    if gfName == 'gf' then
        setProperty('gf.y',getProperty('gf.y')+200)
    end
	if lowQuality == false then
        mistData = {
            {mistImage = 'mistMid', scrollFactor = 1.2, alpha = 0.6, velocity = 172, scale = 1, objectOrder = ''},
            {mistImage = 'mistMid', scrollFactor = 1.1, alpha = 0.6, velocity = 150, scale = 1, objectOrder = ''},
            {mistImage = 'mistBack', scrollFactor = 1.2, alpha = 0.8, velocity = -80, scale = 1, objectOrder = ''},
        }
        for mistNum, data in ipairs(mistData) do
            for i = 0, 2 do
                makeLuaSprite('mist'..mistNum..''..(i + 1), 'phillyStreets/erect/'..data.mistImage, -650, 600)
                scaleObject('mist'..mistNum..''..(i + 1), data.scale, data.scale, false)
                setScrollFactor('mist'..mistNum..''..(i + 1), data.scrollFactor, data.scrollFactor)
                setBlendMode('mist'..mistNum..''..(i + 1), 'ADD')
                if data.objectOrder ~= '' then
                    setObjectOrder('mist'..mistNum..''..(i + 1), getObjectOrder(data.objectOrder) + 8)
                end
                addLuaSprite('mist'..mistNum..''..(i + 1), true)
                setProperty('mist'..mistNum..''..(i + 1)..'.alpha', data.alpha)
                setProperty('mist'..mistNum..''..(i + 1)..'.color', 0x5C5C5C)
                setProperty('mist'..mistNum..''..(i + 1)..'.velocity.x', data.velocity)
                local offsetMist = getProperty('mist'..mistNum..''..(i + 1)..'.x') + (getProperty('mist'..mistNum..''..(i + 1)..'.width') * data.scale) * i
                setProperty('mist'..mistNum..''..(i + 1)..'.x', offsetMist)
            end
        end
    end

    makeLuaSprite('fakeDarnell', 'phillyBlazin/Darnell_huh', 130, 745) --fakeDarnellCuzCharacterFilesAreBeingStupid
	scaleObject('fakeDarnell',1.75 ,1.75)
	addLuaSprite('fakeDarnell', true);
    setObjectOrder('fakeDarnell', 12)
    setProperty('fakeDarnell.alpha', 0);

    if shadersEnabled == true then
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf', 'fakeDarnell'}) do
            setSpriteShader(object, 'adjustColor')
            setShaderFloat(object, 'hue', -5)
            setShaderFloat(object, 'saturation', -40)
            setShaderFloat(object, 'contrast', -25)
            setShaderFloat(object, 'brightness', -20)
        end
		setShaderFloat('gf', 'brightness', -100)
		setShaderFloat('gf', 'saturation', -60)
    end
end


function onUpdatePost(elapsed)
    --[[
        Everything here controls the movement of the fog around the stage.
        3 'mist' sprites of the same placement follow along one another 
        until one of them gets too far to the left or right, and so then get behind the pack.
        Also, all of them do an up and down motion depending of their set values.
    ]]
    if lowQuality == false then
        for mistNum, mistScale in ipairs({1, 1, 1, 0.8, 0.7, 1.1}) do
            for i = 1, 3 do
                if getProperty('mist'..mistNum..''..i..'.velocity.x') > 0 then
                    if getProperty('mist'..mistNum..''..i..'.x') > (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                        setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') - (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                    end
                else
                    if getProperty('mist'..mistNum..''..i..'.x') < -(getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 1.5 then
                        setProperty('mist'..mistNum..''..i..'.x', getProperty('mist'..mistNum..''..i..'.x') + (getProperty('mist'..mistNum..''..i..'.width') * mistScale) * 3)
                    end
                end
            end
        end
        for i = 1, 3 do
            setProperty('mist1'..i..'.y', 660 + (math.sin(elapsedTime * 0.35) * 70))
            setProperty('mist2'..i..'.y', 500 + (math.sin(elapsedTime * 0.3) * 80))
            setProperty('mist3'..i..'.y', 540 + (math.sin(elapsedTime * 0.4) * 60))
            setProperty('mist4'..i..'.y', 230 + (math.sin(elapsedTime * 0.3) * 70))
            setProperty('mist5'..i..'.y', 170 + (math.sin(elapsedTime * 0.35) * 50))
            setProperty('mist6'..i..'.y', -80 + (math.sin(elapsedTime * 0.08) * 100))
        end
    end
end
