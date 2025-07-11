local splashCount = 0;

local splashThing = nil;

local sickTrack = -1;

local enableNewSystem = 2;

local textureSplash = 'BloodSplash';
local texturesplashfrombefore = nil

local defaultSplashXfromBefore = nil
local defaultSplashYfromBefore = nil

local splashOffsetX = 150
local splashOffsetY = 150

local defaultSplashX = 70
local defaultSplashY = 35

local splashScaleX = nil
local splashScaleY = nil
local splashVelocity = 30
local splashAlpha = 1
local splashesDestroyed = 0

local splashAnims = {'note splash purple 1','note splash blue 1','note splash green 1','note splash red 1'}

function onCreatePost()
	if string.match(songName,'endless') == 'endless' then
		enableNewSystem = 0
		precacheImage('endlessNoteSplashes')
	end
	if string.match(songName,'milk')  == 'milk' then
		enableNewSystem = 2
		textureSplash = 'milkSplashes'
	end
	if songName == 'Too-Fest' then
		precacheImage('hitmarker')
		precacheSound('hitmarker')
	end
	if enableNewSystem == 2 then
		precacheImage(textureSplash)
		makeAnimatedLuaSprite('noteSplashpChache',textureSplash, 100, 100);
		addLuaSprite('noteSplashpChache',false);
		setProperty('noteSplashpChache.visible',false)
	end
end

function goodNoteHit(note, direction, type, sus)
	if sickTrack ~= getProperty('sicks') then
		if sus == false then
			if enableNewSystem == 2 and getPropertyFromClass('ClientPrefs','noteSplashes') == true and not sus then
				if textureSplash == 'milkSplashes' then
					splashOffsetX = 180
					splashOffsetY = 200
					splashScaleX = 0.5
					splashScaleY = 0.5
				else
					splashOffsetX = defaultSplashX
					splashOffsetY = defaultSplashY
					splashScaleX = 1
					splashScaleY = 1
				end
				if type ~= 'RingNote' then
					spawnCustomSplash(note, direction, type,textureSplash);
				end
			end
		end
		if textureSplash == 'hitmarker' then
			playSound('hitmarker')
		end
		sickTrack = getProperty('sicks');
	end
end

function spawnCustomSplash(noteId, noteDirection, type,textureNote)
	splashThing = splashAnims[noteDirection + 1]
	splashCount  = splashCount + 1

	makeAnimatedLuaSprite('noteSplash'..splashCount, textureNote, getPropertyFromGroup('playerStrums', noteDirection, 'x'), getPropertyFromGroup('playerStrums', noteDirection, 'y'));
	addAnimationByPrefix('noteSplash'..splashCount, 'anim', splashThing, splashVelocity, false);
	if splashScaleX ~= nil then
		setProperty('noteSplash' .. splashCount .. '.scale.x', splashScaleX);
	end
	if splashScaleY ~= nil then
		setProperty('noteSplash' .. splashCount .. '.scale.y', splashScaleY);
	end
	setProperty('noteSplash' .. splashCount .. '.offset.x', splashOffsetX);
	setProperty('noteSplash' .. splashCount .. '.offset.y', splashOffsetY);

	setProperty('noteSplash' .. splashCount .. '.alpha', splashAlpha);

	setObjectCamera('noteSplash'..splashCount, 'hud');
	setObjectOrder('noteSplash'..splashCount, 9999); -- this better make the splashes go in front-
	addLuaSprite('noteSplash'..splashCount,true);
end
function onUpdate()
	if textureSplash == 'BloodSplash' or textureSplash == 'endlessNoteSplashes' then
		splashVelocity = 30
	elseif textureSplash == 'milkSplashes' then
		splashVelocity = 34
	else
		splashVelocity = 24
	end
	if enableNewSystem == 2 then
		if sickTrack ~= 0 then
			for splashes = splashesDestroyed, splashCount do
				if getProperty('noteSplash'..splashes..'.animation.curAnim.finished') then
					setProperty('noteSplash'..splashes..'.visible',false)
					removeLuaSprite('noteSplash'..splashes,true)
					splashesDestroyed = splashesDestroyed + 1
				end
			end
			for splashesDefault = 0,getProperty('grpNoteSplashes.length') do
				setPropertyFromGroup('grpNoteSplashes', splashesDefault,'visible',false)
			end
		end
	end

end

function onStepHit()
	if curStep == 900 and songName == 'endless' or curStep == 800 and songName == 'endless-encore' then
		enableNewSystem = 2
		textureSplash = 'endlessNoteSplashes'
		defaultSplashX = 135
		defaultSplashY = 105
	end
	if songName == 'Too-Fest' then
		if curStep == 930  then
			enableNewSystem = 2
			texturesplashfrombefore = textureSplash
			defaultSplashXfromBefore = defaultSplashX
			defaultSplashYfromBefore = defaultSplashY
			textureSplash = 'hitmarker'
			for changeSplash = 0,4 do
			   table.insert(splashAnims,changeSplash,'hit')
			end
	
			defaultSplashX = 10
			defaultSplashY = 0
		end
		if curStep == 1168 then
			backSplashArray()
			textureSplash = texturesplashfrombefore
			texturesplashfrombefore = nil
			defaultSplashX = defaultSplashXfromBefore
			defaultSplashY = defaultSplashYfromBefore
			defaultSplashXfromBefore = nil
			defaultSplashYfromBefore = nil
		end
	end

end
function backSplashArray()
	table.insert(splashAnims,1,'note splash purple 1')
	table.insert(splashAnims,2,'note splash blue 1')
	table.insert(splashAnims,3,'note splash green 1')
	table.insert(splashAnims,4,'note splash red 1')
end