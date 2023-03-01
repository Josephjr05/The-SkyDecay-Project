function onCreate()
	for i = 0, getProperty('unspawnNotes.length') do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'staticNote' then 
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'staticNote');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end


function noteMiss(id, dir, nt, sus)
	if nt == 'staticNote' then
		playSound('hitStatic1', 1, 'hitStatic1');
		makeAnimatedLuaSprite('hitStatic', 'hitStatic', 0, 0);
		scaleObject('hitStatic', 1, 1);

		setObjectCamera('hitStatic', 'hud');

		addAnimationByPrefix('hitStatic', 'idle', 'hitStatic', 24, true);
		addLuaSprite('hitStatic', false);
	end
end



