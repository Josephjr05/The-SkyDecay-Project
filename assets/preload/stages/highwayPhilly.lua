function onCreate()
	makeLuaSprite('Sky', 'stages/week8/highwayPhilly/sky', -1200, -800)
	setScrollFactor('Sky', 0.9, 0.9)
	scaleObject('Sky', 1.5, 1.5)
	
	makeLuaSprite('bgcity','stages/week8/highwayPhilly/bgcity', -720, -600)
	scaleObject('bgcity', 1.5, 1.5)
	
	makeLuaSprite('bridge', 'stages/week8/highwayPhilly/bridge', 0, -600)
	scaleObject('bridge', 1.5, 1.5)
	
	makeLuaSprite('lightpost', 'stages/week8/highwayPhilly/lightpost', 1170, -230)
	scaleObject('lightpost', 1.5, 1.5)
	
	makeLuaSprite('lightcast', 'stages/week8/highwayPhilly/lightpost lightcast', 830, -400)
	scaleObject('lightcast', 1.5, 1.5)
	
	makeLuaSprite('signpost', 'stages/week8/highwayPhilly/traffic signpost', 200, 150)
	scaleObject('signpost', 1.5, 1.5)
	
	makeLuaSprite('trafficLights', 'stages/week8/highwayPhilly/traffic lights', 1265, 10)
	scaleObject('trafficLights', 1.5, 1.5)
	
	makeLuaSprite('SF1', 'stages/week8/highwayPhilly/stage front1', -2500, -1100)
	scaleObject('SF1', 1.8, 1.8)	
	
	makeLuaSprite('carback', 'stages/week8/highwayPhilly/carback', 400, 450)
	scaleObject('carback', 1.5, 1.5)

	makeLuaSprite('vignette', 'stages/week8/highwayPhilly/vignette', -100, -200)
	setObjectCamera('hud')
	screenCenter('vignette', 'x')

	addLuaSprite('Sky')
	addLuaSprite('bgcity')
	addLuaSprite('bridge')
	addLuaSprite('carback')
	addLuaSprite('trafficLights')
	addLuaSprite('lightpost')
	addLuaSprite('lightcast')
	addLuaSprite('signpost')
	addLuaSprite('SF1')
	addLuaSprite('vignette', true)
end