
function onCreate() 
	makeLuaSprite('bg-blue', 'bg-blue', -1400, 0);
	addLuaSprite('bg-blue', false); 
	  scaleObject('bg-blue', 0.9, 0.9) 

function onUpdate()
setProperty('gf.alpha', 0)
end
end 