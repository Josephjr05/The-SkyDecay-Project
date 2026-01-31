
function onCreate()
    callMethod("preloadMidSongVideo", {"BMWG_intro", true})
    callMethod("preloadMidSongVideo", {"BMWG_midcutscene", true})
end

local noteColors = {}

function onCreatePost()
    setProperty('healthBar.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)

    setProperty('timeTxt.visible', false)
    setProperty('timeBoard.visible', false)
    setProperty('nps.visible', false)

    for i = 0, getProperty('strumLineNotes.members.length')-1 do 
        table.insert(noteColors, {
            getPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.r'),
            getPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.g'),
            getPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.b')})

            
        makeLuaSprite('noteColorR'..i, ""); 
        setProperty('noteColorR'..i..'.color', getColorFromHex('cccccc'))
        makeLuaSprite('noteColorG'..i, ""); 
        setProperty('noteColorG'..i..'.color', -1)
        makeLuaSprite('noteColorB'..i, ""); 
        setProperty('noteColorB'..i..'.color', getColorFromHex('767676'))
    end

    makeLuaWiiText('missNameTxt', "", 1280)
    setProperty('missNameTxt.size', 1.5)
    setProperty('missNameTxt.text', "Misses")
    setProperty('missNameTxt.width', getProperty('missNameTxt.fieldWidth'))
    screenCenter('missNameTxt')
    addInstance('missNameTxt')
    setProperty('missNameTxt.y', getProperty('missNameTxt.y') - 48)


    makeLuaWiiText('missTxt', "", 1280)
    setProperty('missTxt.size', 3)
    setProperty('missTxt.text', "0")
    setProperty('missTxt.width', getProperty('missTxt.fieldWidth'))
    screenCenter('missTxt')
    addInstance('missTxt')

    setObjectCamera('missTxt', 'other')
    setObjectCamera('missNameTxt', 'other')

    setProperty('missNameTxt.alpha', 0)
    setProperty('missTxt.alpha', 0)

    makeLuaSprite('whitebg', nil, 0, 0)
	luaSpriteMakeGraphic('whitebg', 1, 1, 'FFFFFF')
	setGraphicSize('whitebg', 5000,5000)
	setScrollFactor('whitebg', 0, 0);
	screenCenter('whitebg');
	addLuaSprite('whitebg', true)
	setProperty('whitebg.alpha', 0)
    --debugPrint(noteColors)
end

function onSongStart()
    callMethod("playMidSongVideo", {0})
end

function onStepHit()

    if not shadersEnabled then 
        if curStep == 287 then 
            cameraFlash('game', 'FFFFFF', 1)
        elseif curStep == 2816 then 
            cameraFlash('game', 'FFFFFF', 1)
        end
    end

    if curStep == 288 then
        setProperty('healthBar.visible', true)
        setProperty('iconP1.visible', true)
        setProperty('iconP2.visible', true)
        setProperty('nps.visible', true)
    elseif curStep == 512 then 
        doTweenAlpha('whitebg', 'whitebg', 1, crochet*0.001*4, 'cubeIn')
    elseif curStep == 512+16 then
        doTweenAlpha('whitebg', 'whitebg', 0, crochet*0.001*4, 'linear')
        callOnLuas('endFly')
        setProperty('camGame.zoom', 0.4)
        setProperty('defaultCamZoom', 0.4)
        setProperty('dad.visible', false)
        setProperty('boyfriend.visible', false)
    elseif curStep == 544 then
        setProperty('dad.visible', true)
        setProperty('boyfriend.visible', true)
        playAnim('mattSplash', 'Matt')
        playAnim('bfSplash', 'BF')
        setProperty('defaultCamZoom', 0.6)
    elseif curStep == 2784 then
        callMethod("playMidSongVideo", {1})
        setProperty('healthBar.visible', false)
        setProperty('iconP1.visible', false)
        setProperty('iconP2.visible', false)
        setProperty('nps.visible', false)
    elseif curStep == 2816 then
        setProperty('healthBar.visible', true)
        setProperty('iconP1.visible', true)
        setProperty('iconP2.visible', true)
        setProperty('nps.visible', true)
        callOnLuas('beginFinalPhase')
    elseif curStep == 4864 then
        --setProperty('missNameTxt.alpha', 1)
        --setProperty('missTxt.alpha', 1)
    elseif curStep == 6144 then
        --setProperty('scoreTxt.visible', true)

        
        

        if (getMisses() == 0) then 
            setProperty('missNameTxt.text', "Good Job!")
            setProperty('missNameTxt.width', getProperty('missNameTxt.fieldWidth'))
            screenCenter('missNameTxt')
            doTweenAlpha('missNameTxt', 'missNameTxt', 1, 2, 'cubeOut')
        else
            doTweenAlpha('missNameTxt', 'missNameTxt', 1, 2, 'cubeOut')
            doTweenAlpha('missTxt', 'missTxt', 1, 2, 'cubeOut')
            --setTextString('missTxt', getMisses())
            setProperty('missTxt.text', ''..getMisses())
            setProperty('missTxt.width', getProperty('missTxt.fieldWidth'))
            screenCenter('missTxt')
        end
    end


    if curStep == 96 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 

            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0xfe8c00', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0xa35a00', (crochet/1000), 'expoIn')
        end

    elseif curStep == 128 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0x00aee6', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x005a76', (crochet/1000), 'expoIn')
        end

    elseif curStep == 160 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0x61b0c4', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x447b89', (crochet/1000), 'expoIn')
        end

    elseif curStep == 192 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0x0fe83a', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x098f23', (crochet/1000), 'expoIn')
        end

    elseif curStep == 224 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0x0f5fd7', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x0a3d8b', (crochet/1000), 'expoIn')
        end

    elseif curStep == 256 - 4 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0xdd102a', (crochet/1000), 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x8f0a1b', (crochet/1000), 'expoIn')
        end

    elseif curStep == 96 + 8 or curStep == 128 + 8 or curStep == 160 + 8 or curStep == 192 + 8 or curStep == 224 + 8 or curStep == 256 + 8 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, '0xcccccc', (crochet/1000)*2, 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, '0x767676', (crochet/1000)*2, 'expoIn')
        end
    end


    --reset back to default colors
    if curStep == 256 + 24 then 
        for i = 0, getProperty('strumLineNotes.members.length')-1 do 
            --debugPrint(getColorFromString(noteColors[i+1][1]))

            doTweenColor('noteColorR'..i..'.color', 'noteColorR'..i, getColorStringFromInt(noteColors[i+1][1]), (crochet/1000)*2, 'expoIn')
            doTweenColor('noteColorG'..i..'.color', 'noteColorG'..i, getColorStringFromInt(noteColors[i+1][2]), (crochet/1000)*2, 'expoIn')
            doTweenColor('noteColorB'..i..'.color', 'noteColorB'..i, getColorStringFromInt(noteColors[i+1][3]), (crochet/1000)*2, 'expoIn')
        end
    end
    
end

function getColorStringFromInt(col)
    --lua sucks ass
    local r = bit.band(math.floor(col / 2 ^ 16), 0xff);
    local rStr = callMethodFromClass('StringTools', "hex", {r, 2})
    local g = bit.band(math.floor(col / 2 ^ 8), 0xff);
    local gStr = callMethodFromClass('StringTools', "hex", {g, 2})
    local b = bit.band(col, 0xff);
    local bStr = callMethodFromClass('StringTools', "hex", {b, 2})

    --debugPrint(('0x'..rStr..gStr..bStr))

    return ('0x'..rStr..gStr..bStr)
end

function onUpdate(elapsed)
    for i = 0, getProperty('strumLineNotes.members.length')-1 do 

        setPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.parent.r', getProperty('noteColorR'..i..'.color'))
        setPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.parent.g', getProperty('noteColorG'..i..'.color'))
        setPropertyFromGroup('strumLineNotes.members', i, 'rgbShader.parent.b', getProperty('noteColorB'..i..'.color'))
    end
end