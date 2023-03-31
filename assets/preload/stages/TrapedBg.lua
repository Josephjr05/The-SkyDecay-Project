
function onCreate() 
	makeLuaSprite('bg-traped', 'bg-traped', -700, 0);
	addLuaSprite('bg-traped', false); 
	makeLuaSprite('beds-traped', 'beds-traped', -800, 700);
	addLuaSprite('beds-traped', false);

function onUpdate()
setProperty('gf.alpha', 0)
end
end 