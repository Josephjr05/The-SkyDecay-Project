local xx = 0
local yy = 0

local xx2 = 0
local yy2 = 0

local xx3 = 0
local yy3 = 0

local totalX = 0
local totalY = 0

local opponentIntensity = 20
local playerIntensity = 15
local player3Intensity = 15
local intensity = 0

local camSpeed = 1

local shouldMove = true

local anim = ''

function lerp(a, b, t)
	return a + (b - a) * t
end

function boundTo(value, min, max)
	return math.max(min, math.min(max, value))
end

function settingsInit(song)
	--[[
	
		You config the intensity of the camera movement and camera speed here
		2 examples are shown below.
	
	]]--
	
	if song:lower() == 'personnel' then
		opponentIntensity = 35
		playerIntensity = 22.5
	end
	
	if song:lower() == 'lots-of-talent' then
		opponentIntensity = 27.5
		playerIntensity = 20.5
	end
	
	xx = getMidpointX('dad') + 150 + (getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'))
	yy = getMidpointY('dad') - 100 + (getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'))
	
	xx2 = getMidpointX('boyfriend') - 100 - (getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]'))
	yy2 = getMidpointY('boyfriend') - 100 + (getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]'))
	
	xx3 = getMidpointX('gf') + (getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]'))
	yy3 = getMidpointY('gf') + (getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]'))
end

function onCreatePost()
	settingsInit(songName)
end

function cameraFollow(x, y)
	setProperty('camFollow.x', x)
	setProperty('camFollow.y', y)
end

function setPosition(obj, x, y)
	setProperty(obj .. '.x', x)
	setProperty(obj .. '.y', y)
end

function onEvent(n, v1, v2)
	if n == 'Change Character' then
		-- I have my reasons for this being so messy lol
		
		xx = getMidpointX('dad') + 150 + (getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'))
		yy = getMidpointY('dad') - 100 + (getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'))
	
		xx2 = getMidpointX('boyfriend') - 100 - (getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]'))
		yy2 = getMidpointY('boyfriend') - 100 + (getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]'))
		
		xx3 = getMidpointX('gf') + (getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]'))
		yy3 = getMidpointY('gf') + (getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]'))
	end
end

function onUpdate(elapsed)
	if shouldMove and getProperty('isCameraOnForcedPos') == false then
		moveCamera(elapsed)
	else
		setTextString('botplayTxt', getProperty('camFollow.x') .. ' • ' .. getProperty('camFollow.y'))
	end
end

local followLerp

function moveCamera(delta)
	followLerp = boundTo(delta * 2.4 * camSpeed * getProperty('playbackRate'), 0, 1)
	
	setPosition('camFollowPos', lerp(getProperty('camFollowPos.x'), getProperty('camFollow.x'), followLerp), lerp(getProperty('camFollowPos.y'), getProperty('camFollow.y'), followLerp))
	
	if mustHitSection == true and gfSection == false then
		anim = getProperty('boyfriend.animation.curAnim.name')
		
		totalX = xx2
		totalY = yy2
		
		intensity = playerIntensity
	elseif mustHitSection == false and gfSection == false then
		anim = getProperty('dad.animation.curAnim.name')
		
		totalX = xx
		totalY = yy
		
		intensity = opponentIntensity
	elseif mustHitSection == true and gfSection == true then
		anim = getProperty('gf.animation.curAnim.name')
		
		totalX = xx3
		totalY = yy3
		
		intensity = player3Intensity
	elseif mustHitSection == false and gfSection == true then
		anim = getProperty('gf.animation.curAnim.name')
		
		totalX = xx3
		totalY = yy3
		
		intensity = player3Intensity
	end
	
	if anim == 'idle' then
		cameraFollow(totalX, totalY)
	end
	
	if anim == 'singLEFT' then
		cameraFollow(totalX - intensity, totalY)
	end
	
	if anim == 'singRIGHT' then
		cameraFollow(totalX + intensity, totalY)
	end
	
	if anim == 'singUP' then
		cameraFollow(totalX, totalY - intensity)
	end
	
	if anim == 'singDOWN' then
		cameraFollow(totalX, totalY + intensity)
	end
end