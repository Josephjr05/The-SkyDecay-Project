
local y = 50
local t = 0
-- stolen from bbpanzu lol -Uhard
local u = false;
local r = 0;
local shot = false;
local agent = 1
local health = 0;
local xx = 450.00;
local yy = 540;
local xx2 = 870.9;
local yy2 = 540;
local ofs = 65;
local followchars = true;
local del = 0;
local del2 = 0;
local drain = 0.01 -- the funne
local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and not seenCutscene then --Block the first countdown
			startVideo('IDK HOW TO DELETED IT TO WORK LOL');
		
		
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onUpdate()
	if followchars == true then
        if mustHitSection == false then
            --setProperty('defaultCamZoom',0.7)
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else

            --setProperty('defaultCamZoom',0.7)
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end
function onStepHit() -- VINE BOOM
    --[[if curStep == 16 or curStep == 20 or curStep == 24 or curStep == 26 or curStep == 28 or curStep == 30 or curStep == 1197 or curStep == 1199 or curStep == 1201  or curStep >= 1202 and curStep < 1212 then
        setProperty('camGame.zoom',1.6)
        setProperty('camHUD.zoom',1.7)
        cameraShake('camGame',0.01,0.1)
        cameraShake('camHUD',0.02,0.1)
        characterPlayAnim('boyfriend','scared',true)
        characterPlayAnim('gf','scared',true)
        doTweenZoom('vineboom0','camGame',1,crochet*0.002,'circOut')
        doTweenZoom('vineboom1','camHUD',1,crochet*0.0016,'circOut')
    end]]
end
function onBeatHit() -- oohhh mah gawwwd
--[[if curBeat == 68 or curBeat == 220 or curBeat == 228 or curBeat == 236 or curBeat == 244 or curBeat == 248 or curBeat == 252 or curBeat == 256 or curBeat == 260  or curBeat == 264 or curBeat == 268 or curBeat == 272 or curBeat == 276 or curBeat == 280 then
     cameraShake('camGame',0.015,1.2)
        cameraShake('camHUD',0.03,1.2)
end]]
end

function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.1 then
        setProperty('health', health- 0.025);
    end
end