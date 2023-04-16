local singing = 4
function onCreate()
		makeAnimatedLuaSprite('camelliaReflection', 'characters/camellia', 775, 825)
		addAnimationByPrefix('camelliaReflection', 'idle', 'Camellia_Idle', 24, true) 
        addAnimationByPrefix('camelliaReflection', 'singLEFT', 'Camellia_Leftp', 24, false) 
		addAnimationByPrefix('camelliaReflection', 'singDOWN', 'Camellia_Downs', 24, false) 
		addAnimationByPrefix('camelliaReflection', 'singUP', 'Camellia_Upw', 24, false) 
		addAnimationByPrefix('camelliaReflection', 'singRIGHT', 'Camellia_Rightk', 24, false) 
        setProperty('camelliaReflection.flipY', true)
        --setProperty('camelliaReflection.flipX', true)
end
function onStepHit(

    if getProperty('camelliaReflection.animation.curAnim.name')  ~= null and curBeat % 2 == 0 and singing ~= 1 then 
        objectPlayAnimation('camelliaReflection','idle');	
    end
end
function onUpdate(elapsed)
	if getProperty('camelliaReflection.animation.curAnim.name') ~= 'idle' and not getProperty('camelliaReflection.animation.curAnim.finished') then
	singing = 1
	else
	singing = 0
	end
end
function onUpdatePost(elapsed)
            if getProperty('camelliaReflection.animation.curAnim.name') == 'idle' then
                setProperty('camelliaReflection.offset.x',0)
				setProperty('camelliaReflection.offset.y',0)
			elseif getProperty('camelliaReflection.animation.curAnim.name') == 'singLEFT' then
                setProperty('camelliaReflection.offset.x',-40)
				setProperty('camelliaReflection.offset.y',0)
			elseif getProperty('camelliaReflection.animation.curAnim.name') == 'singDOWN' then
                setProperty('camelliaReflection.offset.x',-4)
				setProperty('camelliaReflection.offset.y',0)
			elseif getProperty('camelliaReflection.animation.curAnim.name') == 'singUP' then
                setProperty('camelliaReflection.offset.x',-35)
				setProperty('camelliaReflection.offset.y',0)
			elseif getProperty('camelliaReflection.animation.curAnim.name') == 'singRIGHT' then
                setProperty('camelliaReflection.offset.x',1)
				setProperty('camelliaReflection.offset.y',0)
            end
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
if noteData == 0 then
	objectPlayAnimation('camelliaReflection', 'singLEFT',true);
end
if noteData == 1 then
	objectPlayAnimation('camelliaReflection', 'singDOWN',true);
end
if noteData == 2 then
	objectPlayAnimation('camelliaReflection', 'singUP',true);
end
if noteData == 3 then
	objectPlayAnimation('camelliaReflection', 'singRIGHT',true);
end
end