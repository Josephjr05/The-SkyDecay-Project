
function onCreate()
  makeLuaSprite('blackScreenn', 'nil', 0, 0)
  setObjectOrder('blackScreenn', 800);
  makeGraphic('blackScreenn', screenWidth, screenHeight, '000000')
  addLuaSprite('blackScreenn', true)
  setProperty('blackScreenn.alpha', 1)
  setObjectCamera('blackScreenn', 'other')
  end

function showBlackScreen(duration)
    doTweenAlpha('blackFadeIn', 'blackScreenn', 1, duration, 'linear')
end

function hideBlackScreen(duration)
    doTweenAlpha('blackFadeOut', 'blackScreenn', 0, duration, 'linear')
end

function onSongStart()
hideBlackScreen(6)
end

function onEvent(name,v1,v2)
    if name == 'Play Animation' then
        if v1 == 'black' then
            showBlackScreen(1)
		elseif v1 == 'bye' then
		    hideBlackScreen(0.01)
		elseif v1 == 'byea' then
		    hideBlackScreen(2)
                elseif v1 == 'blacklong' then
		    showBlackScreen(5)
		elseif v1 == 'blacki' then
		    showBlackScreen(0.01)
			end
		end
	end
