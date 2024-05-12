--created with Super_Hugo's Stage Editor v1.6.3

function onCreate()

	makeLuaSprite('obj2', 'concierto/floor', -1294, 639)
	setObjectOrder('obj2', 0)
	addLuaSprite('obj2', true)
	
	makeLuaSprite('obj3', 'concierto/cartel', -92, -473)
	setObjectOrder('obj3', 0)
	scaleObject('obj3', 1.8, 1.8)
	addLuaSprite('obj3', true)
	
	makeLuaSprite('obj9', 'concierto/edificios', -1329, -605)
	setObjectOrder('obj9', 0)
	scaleObject('obj9', 1.2, 1.2)
	setScrollFactor('obj9', 0.8, 0.8)
	addLuaSprite('obj9', true)
	
	makeLuaSprite('obj11', 'concierto/citybg', -2073, -401)
	setObjectOrder('obj11', 0)
	scaleObject('obj11', 1.4, 1.4)
	setScrollFactor('obj11', 0.5, 0.5)
	addLuaSprite('obj11', true)
	
	makeLuaSprite('obj12', 'concierto/sky', -3599, -2713)
	setObjectOrder('obj12', 0)
	scaleObject('obj12', 1.4, 1.4)
	setScrollFactor('obj12', 0.2, 0.2)
	addLuaSprite('obj12', true)
	
	makeLuaSprite('obj13', 'concierto/overlay', -1626, -1183)
	setBlendMode("obj13", "add")
	setObjectOrder('obj13', 17)
	scaleObject('obj13', 1.5, 1.5)
	addLuaSprite('obj13', true)
	
end