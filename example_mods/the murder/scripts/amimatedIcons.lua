local IconSettings = {
-- Example icon settings
-- You can remove this tutorial comment if you don’t need it
--	["your icon"] = { -- Healthicon in your character.json
--		frame = 'newFrame', -- Name of the frame in icons/your icon
--		idlePrefix = 'newPrefix', -- Default: 'Default'
--		losePrefix = 'newPrefix', -- Default: 'Losing'
--		x = nil, -- Optional: X offset for the icon
--		y = nil -- Optional: Y offset for the icon
--	}
} 
function onCreatePost()
	changeIcon('iconP1', getProperty('boyfriend.healthIcon'), true)
	changeIcon('iconP2', getProperty('dad.healthIcon'), false)
end

function onUpdatePost(elapsed)
	updateIcons()
end

function onEvent(eventName, value1, value2)
	if eventName == 'Change Character' then
		onCreatePost()
	end
end

function changeIcon(tag, char, isPlayer)
	local path = (IconSettings[char] and IconSettings[char].frame or char)
	local idlePrefix = (IconSettings[char] and IconSettings[char].idlePrefix or 'Default')
	local losePrefix = (IconSettings[char] and IconSettings[char].losePrefix or 'Losing')
	local xOff = (IconSettings[char] and IconSettings[char].x or 0)
	local yOff = (IconSettings[char] and IconSettings[char].y or 0)
	if not checkFileExists('images/icons/'..path..'.xml') then path = 'icon-'..char end
	if not checkFileExists('images/icons/'..path..'.png') then path = 'icon-face' end

	if checkFileExists('images/icons/'..path..'.xml') then
		loadFrames(tag, 'icons/'..path)
		addAnimationByPrefix(tag, 'idle', idlePrefix, 24, true)
		addAnimationByPrefix(tag, 'losing', losePrefix, 24, true)
		setProperty('iconsAnimations', false)
	else
		loadGraphic(tag, 'icons/'..path, 150, 150)
		addAnimation(tag, tag, {0, 1}, 0, false)
	end

	setProperty(tag..'.iconOffsets[0]', (getProperty(tag..'.width') - 150 + xOff) / 2)
	setProperty(tag..'.iconOffsets[1]', (getProperty(tag..'.height') - 150 + yOff) / 2)
	setProperty(tag..'.flipX', getProperty((isPlayer and 'boyfriend' or 'dad')..'.isPlayer'))
end

function updateIcons()
	for _, icon in ipairs({'iconP1', 'iconP2'}) do
		--  Port from Gorefield v2
		local losing = false
		if icon == 'iconP1' then
			losing = getProperty('healthBar.percent') < 20
			else losing = getProperty('healthBar.percent') > 80
		end
		if getProperty(icon..'.animation.name') == icon then
			setProperty(icon..'.animation.curAnim.curFrame', (losing and 1 or 0))
			else playAnim(icon, (losing and 'losing' or 'idle'))
		end
	end
end