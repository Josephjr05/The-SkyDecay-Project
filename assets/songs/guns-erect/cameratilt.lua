--[Script made by SenTCM (but fuck credits, you can delete this line whenever you want and experiment as much as you've want)]--


-- how far the tilt would be? --
local intensity = 1

-- how fast would it go? (the lower the number the faster it is) --
local speed = 1.1

-- actually this shouldn't be existing but i need to or else you'll see those black edges --
local camGameScale = 1.07

-- no issue, just wanna put it in --
local camHUDScale = 1.02

-- this is to prevent it from looking like a close-up --
local zoom = 0.8

-- dynamic tilting? fuck yes! not just angles! --
local offset = 10

-- even the opponent!? --
local opTiltEnabled = true


-- don't touch this shit if you dont know what you doin (but i know you know so ignore this) --
function onCreatePost()

setProperty('camGame.flashSprite.scaleX', camGameScale)
setProperty('camGame.flashSprite.scaleY', camGameScale)
setProperty('defaultCamZoom', zoom)
end

function goodNoteHit(id, direction, noteType, isSustainNote)

 if mustHitSection == true then
    if not isSustainNote then
        if direction == 0 then
            doTweenAngle('CamTween1', 'camGame', (0-intensity), speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', offset, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 1 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut ')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end

        if direction == 2 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 3 then
            doTweenAngle('CamTween1', 'camGame', intensity, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', Xval, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end
    end
end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
if opTiltEnabled then
 if mustHitSection == false then
    if not isSustainNote then
        if direction == 0 then
            doTweenAngle('CamTween1', 'camGame', (0-intensity), speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', offset, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 1 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut ')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end

        if direction == 2 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 3 then
            doTweenAngle('CamTween1', 'camGame', intensity, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', Xval, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end
    end
end
end
end

function onUpdate()
if getProperty('dad.animation.curAnim.name') == 'idle' and mustHitSection == false and opTiltEnabled then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
if mustHitSection == false and not opTiltEnabled then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
if getProperty('boyfriend.animation.curAnim.name') == 'idle' and mustHitSection == true then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
end