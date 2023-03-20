function onCreate() 
     makeLuaText('n1_shadow', num1, nil, getProperty('pcm_shadow.x') + 225, 403)
     setTextFont('n1_shadow', 'sonic-cd-menu-font.ttf')
     setTextColor('n1_shadow', '6b6c91')
     setTextBorder('n1_shadow', 0)
     setTextSize('n1_shadow', 30)
     setObjectCamera('n1_shadow', 'other')
     addLuaText('n1_shadow', true)

     makeLuaText('n1', num1, nil, getProperty('pcm.x') + 225, 400)
     setTextFont('n1', 'sonic-cd-menu-font.ttf')
     setTextColor('n1', 'b1adf7')
     setTextBorder('n1', 0)
     setTextSize('n1', 30)
     setObjectCamera('n1', 'other')
     addLuaText('n1', true)

     makeLuaText('n2_shadow', num2, nil, getProperty('da_shadow.x') + 190, 403)
     setTextFont('n2_shadow', 'sonic-cd-menu-font.ttf')
     setTextColor('n2_shadow', '6b6c91')
     setTextBorder('n2_shadow', 0)
     setTextSize('n2_shadow', 30)
     setObjectCamera('n2_shadow', 'other')
     addLuaText('n2_shadow', true)

     makeLuaText('n2', num2, nil, getProperty('da.x') + 190, 400)
     setTextFont('n2', 'sonic-cd-menu-font.ttf')
     setTextColor('n2', 'b1adf7')
     setTextBorder('n2', 0)
     setTextSize('n2', 30)
     setObjectCamera('n2', 'other')
     addLuaText('n2', true)

     makeLuaSprite('BFblacklol', nil, 0, 0)
     makeGraphic('BFblacklol', 1500, 1000, 'ffffff')
     setObjectCamera('BFblacklol', 'other')
     setProperty('BFblacklol.alpha', 0)
     addLuaSprite('BFblacklol', true)

     setTextColor('pcm', 'f5b10a')
     setTextColor('pcm_shadow', 'e81006')
end

local allowCountdown = false;
function onStartCountdown()
     if not allowCountdown then -- Block the first countdown
          allowCountdown = true;    
          playMusic('TEST_INST', 1, true)
          return Function_Stop
     end
     return Function_Continue
end

Detect = true
num1 = 0 -- min 00 max 75 
num2 = 0 -- min 00 max 25 
function onUpdate(elapsed)
     onPass()
     if keyboardJustPressed('SHIFT') then
          exitSong()
     end

     if onGetKey('LEFT') then
          Detect = true
          setTextColor('pcm', 'f5b10a')
          setTextColor('pcm_shadow', 'e81006')

          setTextColor('da', 'b1adf7')
          setTextColor('da_shadow', '6b6c91')
     end

     if onGetKey('RIGHT') then
          Detect = false
          setTextColor('da', 'f5b10a')
          setTextColor('da_shadow', 'e81006')

          setTextColor('pcm', 'b1adf7')
          setTextColor('pcm_shadow', '6b6c91')
     end

     if Detect then
          if onGetKey('UP') then
               playSound('scroll_Test', 0.3, false)
               num1 = num1 + 1
          end
          if onGetKey('DOWN') then
               playSound('scroll_Test', 0.3, false)
               num1 = num1 - 1
          end

          setTextString('n1', num1)
          setTextString('n1_shadow', num1)
     else
          if onGetKey('UP') then
               playSound('scroll_Test', 0.3, false)
               num2 = num2 + 1
          end
          if onGetKey('DOWN') then
               playSound('scroll_Test', 0.3, false)
               num2 = num2 - 1
          end

          setTextString('n2', num2)
          setTextString('n2_shadow', num2)
     end

     if num1 >= 76 then num1 = 0 end
     if num1 <= -1 then num1 = 75 end

     if num2 >= 26 then num2 = 0 end
     if num2 <= -1 then num2 = 25 end
end

function onPass()
     if onGetKey('ENTER') then
          if num1 == 35 and num2 == 23 then
               onTeleportSong('Fresh', 2)

          elseif num1 == 25 and num2 == 13 then
               onTeleportSong('Milf', 2)

          elseif num1 == 73 and num2 == 3 then
               onTeleportSong('Thorns', 2)

          elseif num1 == 23 and num2 == 0 then
               onTeleportSong('Pico', 2)
          else
               playSound('deniedMOMENT', 0.3, false)
          end
     end
end

function onTeleportSong(name, diff)
     playSound('confirm_Test', 0.3, false)
     playMusic('', 0, false)
     doTweenAlpha(nil, 'BFblacklol', 1, 0.4, 'linear')

     ezTimer(nil, 2, function()
          loadSong(name, diff)
     end)
end

function onGetKey(key) -- I know this useless but I hate long code's they, hurt my brain a lot
     return getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key)
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