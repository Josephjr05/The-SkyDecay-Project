local offsetsToUpdate = {'lol'}
local songSplashSkin = ''
local orOffsets = {10, 10}

function onEvent(tag, value1, value2)

	if tag == 'Change Note Splashes' then
		
		if not (value2 == nil) and string.find(value2, ',') then
			offsetsToUpdate[1] = string.sub(value2, 0, string.find(value2, ',') - 1)
			offsetsToUpdate[2] = string.sub(value2, string.find(value2, ',') + 1)
		else
			offsetsToUpdate = {orOffsets[1], orOffsets[2]}
		end
		
	end
	
end

function onCreatePost()

	orOffsets = {getPropertyFromGroup('grpNoteSplashes', 0, 'offset.x'), getPropertyFromGroup('grpNoteSplashes', 0, 'offset.y')}

	--get the song splash skin
	if getPropertyFromClass('PlayState', 'SONG.splashSkin') == nil or getPropertyFromClass('PlayState', 'SONG.splashSkin') == 'SONG.splashSkin' then
		songSplashSkin = 'noteSplashes'
	else
		songSplashSkin = getPropertyFromClass('PlayState', 'SONG.splashSkin')
	end
	
	
	--Change all unspawned notes from the time of each event to the end of the song
	for i = 0, getProperty('eventNotes.length')-1 do
	
		if getPropertyFromGroup('eventNotes', i, 'event') == 'Change Note Splashes' then
		
			local value1 = getPropertyFromGroup('eventNotes', i, 'value1')
			local value2 = getPropertyFromGroup('eventNotes', i, 'value2')

			for ii = 0, getProperty('unspawnNotes.length')-1 do

				if (getPropertyFromGroup('unspawnNotes', ii, 'strumTime') >= getPropertyFromGroup('eventNotes', i, 'strumTime')) or getPropertyFromGroup('eventNotes', i, 'strumTime') < 50 then
				
					if not (value1 == nil or value1 == '') then
						setPropertyFromGroup('unspawnNotes', ii, 'noteSplashTexture', value1)
						precacheImage(value1) --less lag
					else
						setPropertyFromGroup('unspawnNotes', ii, 'noteSplashTexture', songSplashSkin)
					end
					
				end
			
			end
		
		end
		
	end
	
end

--Change the note splashes offsets
function onUpdatePost()

	if not (offsetsToUpdate == nil or offsetsToUpdate[1] == 'lol') then
	
		for i = 0, getProperty('grpNoteSplashes.length')-1 do
			setPropertyFromGroup('grpNoteSplashes', i, 'offset.x', offsetsToUpdate[1])
			setPropertyFromGroup('grpNoteSplashes', i, 'offset.y', offsetsToUpdate[2])
		end

	end

end