--Reflect Sprite Script By xTHFx--
--The GF Code Is Not The Same To The Others(The Anothers Animations In Other Update)--
--Give Credits To Me If You Use It--
local tagGF = "reflectGF"--Tag--
local charName = "characters/Ash"--Character Image And XML Name--
local shaderSpr = true--If You Want To Only Work With Shaders--
function onCreatePost()
    if shaderSpr then
        if shadersEnabled then
        onCreateChar()
        end
    end
    if not shaderSpr then
        onCreateChar()
        end
    end
function onCreateChar()
    makeAnimatedLuaSprite(tagGF, charName, getProperty('gf.x'), getProperty('gf.y') + 640)
    scaleObject(tagGF, getProperty('gf.scale.x'), getProperty('gf.scale.y'))
    setProperty(tagGF ..'.alpha', 0.25)
    setProperty(tagGF ..'.angle', 180)
    setProperty(tagGF ..'.flipX', true)
    --Not All Anims--
    --Idle--
    addAnimationByIndices(tagGF, 'danceLeft', 'GF Dancing Beat', '30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14', 24);
    addAnimationByIndices(tagGF, 'danceRight', 'GF Dancing Beat', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29', 24);
    --Special Anims(Add Your SpecialAnims Here)--
    addAnimationByPrefix(tagGF, 'cheer', 'GF Cheer', 24, false)
    addAnimationByPrefix(tagGF, 'scared', 'GF FEAR', 24, true)
    addAnimationByPrefix(tagGF, 'hairBlow', 'GF Dancing Beat Hair blowing', 24, false)
    addAnimationByPrefix(tagGF, 'hairFall', 'GF Dancing Beat Hair Landing', 24, true)
    addAnimationByIndices(tagGF, 'sad', 'gf sad', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12', 24);
        --SingAnims(Add Your SingAnims Here)--
        addAnimationByPrefix(tagGF, 'singLEFT', 'GF left note', 24, false)
        addAnimationByPrefix(tagGF, 'singDOWN', 'GF Down Note', 24, false)
        addAnimationByPrefix(tagGF, 'singUP', 'GF Up Note', 24, false)
        addAnimationByPrefix(tagGF, 'singRIGHT', 'GF Right Note', 24, false)
    --The Offsets Have To Be Set Manually--
    --SpecialOffsets--
    addOffset(tagGF, 'danceLeft', 0, 0)
    addOffset(tagGF, 'danceRight', 0, 0)
    addOffset(tagGF, 'cheer', 0, -10)
    addOffset(tagGF, 'scared', 0, 10)
    addOffset(tagGF, 'hairBlow', 0, 0)
    addOffset(tagGF, 'hairFall', 0, 0)
    addOffset(tagGF, 'sad', 0, 10)
    --SingOffsets--
    addOffset(tagGF, 'singLEFT', 0, 10)
    addOffset(tagGF, 'singDOWN', 0, 10)
    addOffset(tagGF, 'singUP', 0, -10)
    addOffset(tagGF, 'singRIGHT', 0, 10)
    
    addLuaSprite(tagGF, false)

end
function goodNoteHit(id, direction, noteType, isSustainNote)
    if noteType == 'GF Sing' then
    if direction == 0 then
        playAnim(tagGF, 'singLEFT', true)
        runTimer('idlekeys',0.35)
    end
    if direction == 1 then
        playAnim(tagGF, 'singDOWN', true)
        runTimer('idlekeys',0.35)
    end
    if direction == 2 then
        playAnim(tagGF, 'singUP', true)
        runTimer('idlekeys',0.35)
    end
    if direction == 3 then
        playAnim(tagGF, 'singRIGHT', true)
        runTimer('idlekeys',0.35)
    end
end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
    if noteType == 'GF Sing' then
    if direction == 0 then
        playAnim(tagGF, 'singLEFT', true)
        runTimer('idle',0.35)
    end
    if direction == 1 then
        playAnim(tagGF, 'singDOWN', true)
        runTimer('idle',0.35)
    end
    if direction == 2 then
        playAnim(tagGF, 'singUP', true)
        runTimer('idle',0.35)
    end
    if direction == 3 then
        playAnim(tagGF, 'singRIGHT', true)
        runTimer('idle',0.35)
    end
end
end
--Add Your Values Here--
function onUpdatePost()
    if getProperty("gf.animation.curAnim.name") == 'danceLeft' then
        rgDanceLeft()
    end
    if getProperty("gf.animation.curAnim.name") == 'danceRight' then
        rgDanceRight()
    end
    if getProperty("gf.animation.curAnim.name") == 'cheer' then
        rgcheer()
    end
    if getProperty("gf.animation.curAnim.name") == 'hairBlow' then
        rghblow()
    end
    if getProperty("gf.animation.curAnim.name") == 'hairFall' then
        rghfall()
    end
    if getProperty("gf.animation.curAnim.name") == 'sad' then
        rgsad()
    end
    if getProperty("gf.animation.curAnim.name") == 'scared' then
        rgscared()
    end
end
function onTimerCompleted(tag)
    if tag == 'danceLeft' then
        rgDanceLeft()
    end
    if tag == 'danceRight' then
        rgDanceRight()
    end
    if tag == 'cheer' then
        playAnim(tagGF, 'cheer', false)
    end
    if tag == 'idlekeys' then
		if keyPressed("left") or keyPressed("down") or keyPressed("up") or keyPressed("right") then
            runTimer('idlekeys',0.001,1)
		else
        rgDanceLeft()
		end
	end
end
function rgDanceLeft()
    characterPlayAnim('gf','danceLeft',false)
    playAnim(tagGF, 'danceLeft', false)
end
function rgDanceRight()
    characterPlayAnim('gf','danceRight',false)
    playAnim(tagGF, 'danceRight', false)
end
function rgcheer()
    characterPlayAnim('gf','cheer',false)
    playAnim(tagGF, 'cheer', false)
end
function rgscared()
    characterPlayAnim('gf','scared',false)
    playAnim(tagGF, 'scared', false)
end
function rghblow()
    characterPlayAnim('gf','hairBlow',false)
    playAnim(tagGF, 'hairBlow', false)
end
function rghfall()
    characterPlayAnim('gf','hairFall',false)
    playAnim(tagGF, 'hairFall', false)
end
function rgsad()
    characterPlayAnim('gf','sad',false)
    playAnim(tagGF, 'sad', false)
end