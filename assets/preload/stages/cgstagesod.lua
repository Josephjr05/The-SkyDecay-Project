local turnvalue = 20

function onCreate()

	 makeAnimatedLuaSprite('back', 'stages/weekcg/CGBG', -900,-830);
	 setLuaSpriteScrollFactor('back', 1.0, 1.0);
	scaleObject('back', 1.35,1.35);
	
	makeAnimatedLuaSprite('publico', 'stages/weekcg/bopper1', -10, 280);
	scaleObject('publico', 1.32,1.32);
	
	makeAnimatedLuaSprite('publico2', 'stages/weekcg/bopper2',  -170, 270);
	setLuaSpriteScrollFactor('publico2', 1.0, 1.0);
	scaleObject('publico2', 1.32,1.32);
	
	makeLuaSprite('overlay', 'stages/weekcg/BGLAYER', 2,0);
	setLuaSpriteScrollFactor('overlay', 1.0, 1.0);
	scaleObject('overlay', 0.81,0.81);
	setObjectCamera('overlay', 'hud');
	
	makeLuaText('sion', "Recreation By SION | Mod MongMong", 0, -850, 20);
	setProperty('sion.alpha',0.90);
    setTextSize('sion',18);
    addLuaText('sion');
  
	addLuaSprite('back', false);
	addAnimationByPrefix('back', 'idle', 'new', 20, true);
	addLuaSprite('publico', false);
	addAnimationByPrefix('publico', 'idle', 'crowd', 15, true);
	addLuaSprite('publico2', false);
	addAnimationByPrefix('publico2', 'idle', 'crowd', 15, true);
	addLuaSprite('overlay', true);
	
end

function onSongStart()

doTweenX('Text', 'sion', 880, 1.7, 'circInOut')

end

function onTweenCompleted(tag)
if tag == 'Text' then

doTweenAlpha('Text', 'sion', 0.34, 0.5, 'currentBeat');

end
end

function onBeatHit()

doTweenZoom('two', 'camHUD', 1.05, 0.08, 'smootherStepInOut');
   

turnvalue = 20
if curBeat % 0 == 0 then
turnvalue = -20

   
   
end

setProperty('iconP2.angle',-turnvalue)
setProperty('iconP1.angle',turnvalue)

doTweenAngle('iconTween1','iconP1',0,crochet/1000,'circOut')
doTweenAngle('iconTween2','iconP2',0,crochet/1000,'circOut')

function onTweenCompleted(tag)
if tag == 'two' then

doTweenZoom('waos', 'camHUD', 1.0, 0.08, 'smootherStepInOut');


   end
end
end