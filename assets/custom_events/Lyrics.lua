local disableLyrics = false
local colorLyrics = 'FFFFFF'
local textLyrics = ''

local textSizeX = 2.2
local textSizeY = 2
local hideHud = false
local time = ''

local timeStart = 0
local timeFinish = 0
local commaStart = 0
local commaEnd = 0

local textFont = ''
local pixelFont = 'sonic-1-hud-font.ttf'
local cinematicEnabled = nil

local bordersSize = 170
local bordersTime = 1

local number1 = nil
local number2 = nil
local startLeters = 0
local allTextLeters = 0
local textValue2Preview = ''
local bordersEnabled = false
local LyricsInExecutation = false

function onUpdate()
    for eventNotes = 0,getProperty('eventNotes.length')-1 do
        if (getPropertyFromGroup('eventNotes',eventNotes,'strumTime') - getSongPosition()) < 350 and getPropertyFromGroup('eventNotes',eventNotes,'event') == 'Lyrics' then
            if string.find(string.lower(getPropertyFromGroup('eventNotes',eventNotes,'value2')),'refresh:true',0,true) ~= nil then
                bordersEnabled = false
                cinematicEnabled = false
                LyricsInExecutation = false
                textValue2Preview = ''
            end
            if LyricsInExecutation == false then
                if textValue2Preview == '' then
                    textValue2Preview = string.lower(getPropertyFromGroup('eventNotes',eventNotes,'value2'))
                end
                if string.find(textValue2Preview,'btime:',0,true) ~= nil then
                    local commaTime = 0
                    local commaTime2 = 0
                    local textTime = 0
                    local textTime2 = 0
                    textTime,textTime2 = string.find(textValue2Preview,'btime:',0,true)
                    if textTime ~= nil then
                        commaTime,commaTime2 = string.find(textValue2Preview,',',textTime2 + 1,true)
                    end
                    if commaTime ~= nil and commaTime ~= 0 then
                        bordersTime = string.sub(textValue2Preview,textTime2 + 1,commaTime - 1)
                    else
                        bordersTime = string.sub(textValue2Preview,textTime2 + 1)
                    end
                end
                if string.find(textValue2Preview,'tSizeX:',0,true) ~= nil then
                    local commaTX = 0
                    local commaTX2 = 0
                    local tSizeX = 0
                    local tSizeX2 = 0
                    tSizeX,tSizeX2 = string.find(textValue2Preview,'btime:',0,true)
                    if textTime ~= nil then
                        commaTX,commaTX2 = string.find(textValue2Preview,',',tSizeX2 + 1,true)
                    end
                    if commaTX ~= nil and commaTX ~= 0 then
                        textSizeX = string.sub(textValue2Preview,commaTX2 + 1,tSizeX - 1)
                    else
                        textSizeX = string.sub(textValue2Preview,textTime2 + 1)
                    end
                end
                if string.find(textValue2Preview,'bsize:',0,true) ~= nil then
                    local commaSize = 0
                    local commaSize2 = 0
                    local textSize = 0
                    local textSize2 = 0
                    textSize,textSize2 = string.find(textValue2Preview,'size:',0,true)
                    commaSize,commaSize2 = string.find(textValue2Preview,',',textSize2 + 1,true)
                    if commaSize ~= nil then
                        bordersSize = string.sub(textValue2Preview,textSize2 + 1,commaSize - 1)
                    else
                        bordersSize = string.sub(textValue2Preview,textSize2 + 1)
                    end
                end
                if string.find(textValue2Preview,'borders:false',0,true) == nil then
                    makeLuaSprite('blackBorderLyrics1',nil,0,-bordersSize)
                    makeLuaSprite('blackBorderLyrics2',nil,0,screenHeight)
                    doTweenY('comeBlack1','blackBorderLyrics1',0,bordersTime,'quartOut')
                    doTweenY('comeBlack2','blackBorderLyrics2',screenHeight - bordersSize,bordersTime,'quartOut')
                    bordersEnabled = true
                else
                    if bordersEnabled == true then
                        backBorders()
                    end
                    bordersEnabled = false
                end

                if bordersEnabled == true then
                    if string.find(textValue2Preview,'cinematic:true',0,true) == nil then
                        cinematicEnabled = false
                    else
                        cinematicEnabled = true
                    end
                    for blackBorders = 1,2 do
                        if cinematicEnabled == false then
                            setObjectCamera('blackBorderLyrics'..blackBorders,'other')
                            addLuaSprite('blackBorderLyrics'..blackBorders,true)
                        else
                            setObjectCamera('blackBorderLyrics'..blackBorders,'hud')
                            addLuaSprite('blackBorderLyrics'..blackBorders,false)
                        end
                        makeGraphic('blackBorderLyrics'..blackBorders,screenWidth,bordersSize,'000000')
                    end
                end
                LyricsInExecutation = true
            end
        end
    end
    if disableLyrics == true then
        setProperty('LyricsWow.alpha',getProperty('LyricsWow.alpha') - 0.05)
        if getProperty('LyricsWow.alpha') <= 0 then
            removeLuaText('LyricsWow',false)
            if bordersEnabled == false then
                refreshLyrics()
            end
            disableLyrics = false
            
        end
    end
end
function onEvent(name,v1,v2)
    if name == 'Lyrics' then
        textLyrics = v1
        number1,number2 = string.find(string.lower(v1),'--0x',0,true)
        startLeters,allTextLeters = string.find(v1,v1,0,true)
        if number1 ~= nil and number2 ~= number1 + 4 then
            colorLyrics = string.sub(v1,number2 + 1,allTextLeters)
            textLyrics = string.sub(v1,startLeters,allTextLeters - 10)
        end
        if string.find(string.lower(v2),'hidehud:true',0,true) ~= nil then
            hideHud = true
            doTweenAlpha('hudAlphaEvent','camHUD',0,0.4,'linear')
        end
        makeLuaText('LyricsWow',textLyrics,1280,0,600)
        setTextColor('LyricsWow',colorLyrics)
        setObjectCamera('LyricsWow','other')
        setProperty('LyricsWow.antialiasing',false)
        setProperty('LyricsWow.alpha',1)
        addLuaText('LyricsWow',true)
        --setProperty('LyricsWow.antialiasing',false)
        if getPropertyFromClass('PlayState','isPixelStage') == true then
            if pixelFont ~= '' then
                setTextFont('LyricsWow',pixelFont)
            else
                if textFont ~= '' then
                    setTextFont('LyricsWow',textFont)
                end
            end
        else
            if textFont ~= '' then
                setTextFont('LyricsWow',textFont)
            end
        end
        setProperty('LyricsWow.scale.x',textSizeX)
        setProperty('LyricsWow.scale.y',textSizeY)
        setTextBorder('LyricsWow',1,'000000')
        if bordersEnabled == false then
            setObjectOrder('LyricsWow',getObjectOrder('blackBorderLyrics2') + 1)
        end
        if tonumber(v2) ~= nil then
            time = tonumber(v2)
        else
            if string.find(v2,'time:',0,true) ~= nil then
                timeStart,timeFinish = string.find(v2,'time:',0,true)
                commaStart,commaEnd = string.find(v2,',',timeFinish,true)
                if commaStart ~= nil then
                    time = string.sub(v2,timeFinish + 1,commaStart - 1)
                end
            else
                time = 0.3
            end
        end
        runTimer('removeLyricsEvent',time)
        runTimer('removeLyricsBars',time + 0.5)
        disableLyrics = false

    elseif name == 'Close Lyrics' and LyricsInExecutation == true then
        local bordersBackTime = v1
        local bordersBackEasing = v2

        if bordersBackTime == '' then
            bordersBackTime = bordersTime
        end
        if bordersBackEasing == '' then
            bordersBackEasing = 'quartOut'
        end
        refreshLyrics(bordersBackTime,bordersBackEasing)
    end
end
function onTimerCompleted(tag)
    if tag == 'removeLyricsEvent' then
        disableLyrics = true
    end
end
function backBorders(bodersTime,bordersEasing)
    if bodersTime == nil then
        bodersTime = 1
    end
    if bordersEasing == nil then
        bordersEasing = 'quartOut'
    end
    doTweenY('backBlack1','blackBorderLyrics1',bordersSize*-1,bodersTime,bordersEasing)
    doTweenY('backBlack2','blackBorderLyrics2',screenHeight,bodersTime,bordersEasing)
end
function refreshLyrics(disappearTime,easingBoders)
    disableLyrics = true
    number1 = nil
    number2 = nil
    textValue2Preview = ''
    LyricsInExecutation = false
    colorLyrics = 'FFFFFF'
    if bordersEnabled == true then
        backBorders(disappearTime,easingBoders)
        bordersEnabled = false
    end
    if hideHud == true then
        doTweenAlpha('hudAlphaEvent','camHUD',1,0.6,'linear')
        hideHud = false
    end
end
function onTweenCompleted(tag)
    if string.find(tag,'blackBlack',0,true) ~= nil then
        for blackBorders = 1,2 do
            if tag == 'backBlack'..blackBorders then
                removeLuaSprite('blackBorderLyrics'..blackBorders,false)
            end
        end
    end
end
