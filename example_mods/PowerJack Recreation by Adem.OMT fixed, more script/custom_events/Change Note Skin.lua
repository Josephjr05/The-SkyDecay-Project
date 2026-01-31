local wasPixelStage = false
local songArrowSkin = 'NOTE_assets'

function onCreate()

	wasPixelStage = getPropertyFromClass('PlayState', 'isPixelStage')

	if getPropertyFromClass('PlayState', 'SONG.arrowSkin') == nil or getPropertyFromClass('PlayState', 'SONG.arrowSkin') == 'SONG.arrowSkin' then
		songArrowSkin = 'NOTE_assets'
	else
		songArrowSkin = 'PIXELNOTE_assets'
	end
	
end

function onEvent(tag, value1, value2)

	if tag == 'Change Note Skin' then

		if value1 == nil or value1 == '' then value1 = songArrowSkin end
		
		local character = 'both'
		
		--get the character if its specified
		if string.find(value1, ',') then

			if string.find(value1, 'bf') or string.find(value1, 'boyfriend') then character = 'bf' end
			if string.find(value1, 'dad') then character = 'dad' end
			
			value1 = string.sub(value1, 0, string.find(value1, ',') - 1)
			
		end
		
		--debugPrint(value1, ' - ', character)
	
		if not (value2 == nil or value2 == '') then

			if value2:lower() == 'true' then
				setPropertyFromClass('PlayState', 'isPixelStage', true)
			else
				setPropertyFromClass('PlayState', 'isPixelStage', false)
			end
				
		end

		--change the texture
		for i = 0, 3 do
		
			if character == 'both' then
		
				setPropertyFromGroup('playerStrums', i, 'texture', value1)
				setPropertyFromGroup('opponentStrums', i, 'texture', value1)
				
				runHaxeCode([[
					game.playerStrums.members[]]..i..[[].reloadNote();
					game.opponentStrums.members[]]..i..[[].reloadNote();
				]])
				
			elseif character == 'dad' then

				setPropertyFromGroup('opponentStrums', i, 'texture', value1)
				
				runHaxeCode([[
					game.opponentStrums.members[]]..i..[[].reloadNote();
				]])
			
			else
			
				setPropertyFromGroup('playerStrums', i, 'texture', value1)

				runHaxeCode([[
					game.playerStrums.members[]]..i..[[].reloadNote();
				]])
			
			end
			
		end
		
	end

end

function onCreatePost()

	for i = 0, getProperty('eventNotes.length')-1 do
	
		if getPropertyFromGroup('eventNotes', i, 'event') == 'Change Note Skin' then

			local value1 = getPropertyFromGroup('eventNotes', i, 'value1')
			local value2 = getPropertyFromGroup('eventNotes', i, 'value2')
			
			if value1 == nil or value1 == '' then value1 = songArrowSkin end
			
			local character = 'both'
		
			--get the character if its specified
			if string.find(value1, ',') then

				if string.find(value1, 'bf') or string.find(value1, 'boyfriend') then character = 'bf' end
				if string.find(value1, 'dad') then character = 'dad' end
				
				value1 = string.sub(value1, 0, string.find(value1, ',') - 1)
				
			end
			
			if not (value2 == nil or value2 == '') then

				if value2:lower() == 'true' then
					setPropertyFromClass('PlayState', 'isPixelStage', true)
				else
					setPropertyFromClass('PlayState', 'isPixelStage', false)
				end
				
			end
			

			--change the strum texture from the start if its at the start of the song
			if getPropertyFromGroup('eventNotes', i, 'strumTime') < 50 then

				for i = 0, 3 do
				
					if character == 'both' then
		
						setPropertyFromGroup('playerStrums', i, 'texture', value1)
						setPropertyFromGroup('opponentStrums', i, 'texture', value1)
						
						runHaxeCode([[
							game.playerStrums.members[]]..i..[[].reloadNote();
							game.opponentStrums.members[]]..i..[[].reloadNote();
						]])
						
					elseif character == 'dad' then

						setPropertyFromGroup('opponentStrums', i, 'texture', value1)
						
						runHaxeCode([[
							game.opponentStrums.members[]]..i..[[].reloadNote();
						]])
					
					else
					
						setPropertyFromGroup('playerStrums', i, 'texture', value1)

						runHaxeCode([[
							game.playerStrums.members[]]..i..[[].reloadNote();
						]])
					
					end
							
				end
				
			end
			
			
			local nextEventTime = 0

			--get the next change note skin event (it causes less lag because it doesn't need to get every single note until the end of the song for each event)
			for iii = 0, getProperty('eventNotes.length')-1 do
			
				if not (iii == i) and getPropertyFromGroup('eventNotes', iii, 'event') == 'Change Note Skin' then
				
					if (character == 'bf' and (string.find(getPropertyFromGroup('eventNotes', iii, 'value1'), 'bf') or string.find(getPropertyFromGroup('eventNotes', iii, 'value1'), 'boyfriend')))
					or (character == 'dad' and string.find(getPropertyFromGroup('eventNotes', iii, 'value1'), 'dad')) or character == 'both' then

						if getPropertyFromGroup('eventNotes', iii, 'strumTime') > getPropertyFromGroup('eventNotes', i, 'strumTime') then
							nextEventTime = getPropertyFromGroup('eventNotes', iii, 'strumTime')
							break
						end
					
					end
					
				end
				
			end
			
			--debugPrint(getPropertyFromGroup('eventNotes', i, 'strumTime'), ' - ', nextEventTime, ' - ', character) --current event time and the next event time (0 means there is no event after this one)
			

			
			for ii = 0, getProperty('unspawnNotes.length')-1 do
			
				if (character == 'dad' and getPropertyFromGroup('unspawnNotes', ii, 'mustPress') == false) or (character == 'bf' and getPropertyFromGroup('unspawnNotes', ii, 'mustPress')) or character == 'both' then
	
					if (nextEventTime > 0 and getPropertyFromGroup('unspawnNotes', ii, 'strumTime') >= getPropertyFromGroup('eventNotes', i, 'strumTime') and getPropertyFromGroup('unspawnNotes', ii, 'strumTime') < nextEventTime)
					or (nextEventTime == 0 and getPropertyFromGroup('unspawnNotes', ii, 'strumTime') >= getPropertyFromGroup('eventNotes', i, 'strumTime')) then

						setPropertyFromGroup('unspawnNotes', ii, 'texture', value1)
						
						runHaxeCode([[
							game.unspawnNotes.members[]]..ii..[[].reloadNote('', ']]..value1..[[');
						]])
						
						--This fixes the weird spaces between long notes
						if getPropertyFromGroup('unspawnNotes', ii, 'isSustainNote') then
						
							setPropertyFromGroup('unspawnNotes', ii, 'scale.y', 1)
						
							if not (string.find(getPropertyFromGroup('unspawnNotes', ii, 'animation.curAnim.name'),'end')) then
								setPropertyFromGroup('unspawnNotes', ii, 'scale.y', getPropertyFromGroup('unspawnNotes', ii, 'scale.y') * getPropertyFromClass('Conductor', 'stepCrochet') / 100 * 1.05)
								setPropertyFromGroup('unspawnNotes', ii, 'scale.y', getPropertyFromGroup('unspawnNotes', ii, 'scale.y') * getProperty('songSpeed'))
							end
						
							if getPropertyFromClass('PlayState', 'isPixelStage') == true then
								setPropertyFromGroup('unspawnNotes', ii, 'scale.y', getPropertyFromGroup('unspawnNotes', ii, 'scale.y') * 1.19)
								--setPropertyFromGroup('unspawnNotes', ii, 'scale.y', getPropertyFromGroup('unspawnNotes', ii, 'scale.y') * (6 / getPropertyFromGroup('unspawnNotes', ii, 'height')))
								setPropertyFromGroup('unspawnNotes', ii, 'scale.y', getPropertyFromGroup('unspawnNotes', ii, 'scale.y') * 6)
							end
								
							updateHitboxFromGroup('unspawnNotes', ii)
						
						end
						
					end
				
				end
					
			end
			
		end
			
	end
	
	setPropertyFromClass('PlayState', 'isPixelStage', wasPixelStage)
	
end

function onDestroy()
	setPropertyFromClass('PlayState', 'isPixelStage', wasPixelStage)
end