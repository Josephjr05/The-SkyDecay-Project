
function onCreatePost()
	makeLuaSprite('Health', 'iridaHealthBar')
	setObjectCamera('Health', 'hud')
	addLuaSprite('Health', true)
	scaleObject('Health', 1, 1)
	setObjectOrder('iconP1', getObjectOrder('Health') + 1)
	setObjectOrder('iconP2', getObjectOrder('Health') + 1)
	setProperty('healthBar.visible', true)
end

function onUpdatePost(elapsed)
	setProperty('Health.x', getProperty('healthBar.x') - 200)
	setProperty('Health.y', getProperty('healthBar.y') - 70)
	setProperty('iconP1.x', screenWidth - 300)
	setProperty('iconP2.x', 150)
	setProperty('healthBar.scale.x', 1.5)
end
function onStepHit()
        if curStep == 2560 then -- also step nigger, FUCK YOU
                setProperty('Health.alpha', 0, 0 );
      end
        if curStep == 2816 then -- also step nigger, FUCK YOU
                setProperty('Health.alpha', 1, 1 );


end
 end

