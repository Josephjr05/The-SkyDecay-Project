
function onCreate() 
	makeLuaSprite('bg-red', 'bg-red', -1900, 0);
	addLuaSprite('bg-red', false); 
	makeLuaSprite('tables-red', 'tables-red', -1200, 680);
	addLuaSprite('tables-red', false); 
	makeLuaSprite('chairback-red', 'chairback-red', -100, 870);
	addLuaSprite('chairback-red', false);
	makeLuaSprite('table-red', 'table-red', 0, 820);
	addLuaSprite('table-red', true);
	makeLuaSprite('chair-red', 'chair-red', -100, 1050);
	addLuaSprite('chair-red', true);
    makeAnimatedLuaSprite('back-red','back-red', -600, 800)
    addAnimationByPrefix('back-red','oters','Back',15,true)
    addLuaSprite('back-red', true)
    scaleObject('back-red', 0.9, 0.9)

function onHitStep()
 if curStep == 900 then
doTweenAlpha('camHUDAlpha', 'camHUD', 0., 1, 'cubicOut')
end
end

function onUpdate()
setProperty('gf.alpha', 0)
end
end 