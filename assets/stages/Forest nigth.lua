---------- (Old) background change by nickpoke00
------------ Ty bro this is the most useful shit ngl --- TR0L0X
function onCreate()
	makeLuaSprite('sky','stages/Forest/sky',-1700,-1100)
	scaleObject('sky',1,1)
	setScrollFactor('sky',1,1)
	setProperty('sky.antialiasing',true)
	addLuaSprite('sky')


	makeLuaSprite('wawa','stages/Forest/wawa',-1700,-1100)
	scaleObject('wawa',1,1)
	setScrollFactor('wawa',1,1)
	setProperty('wawa.antialiasing',true)
	addLuaSprite('wawa')
	
	makeLuaSprite('Arena', 'stages/arena-bg', -1700, -1500)
	addLuaSprite('Arena', false)
	setProperty('Arena.alpha', 0);
	scaleObject('Arena',1,1)

	makeAnimatedLuaSprite('people', 'stages/arena-characters', -1700, -1100)
	addAnimationByPrefix('people', 'bounce', 'bg-characters', 24, true)
	addLuaSprite('people', false)
	objectPlayAnimation('people', 'bounce', true)
	setProperty('people.alpha', 0);

	makeLuaSprite('railingpeople', 'stages/railing', -1700, -940)
	addLuaSprite('railingpeople', false)
	setProperty('railingpeople.alpha', 0);
end
function onStepHit()
	if curStep == 2360 then
		setProperty('Arena.alpha', 1);
		setProperty('railingpeople.alpha', 1);
		setProperty('people.alpha', 1);
	end
	if curStep == 999999 then
		setProperty('Arena.alpha', 0);
		setProperty('people.alpha', 0);
		setProperty('railingpeople.alpha', 0);
	end
end