local seconds = 0
local zoom = 0
local defaultZoom = 0

function onCreate()
	defaultZoom = getProperty('defaultCamZoom')
end

function onEvent(name, value1, value2) --value1 = how far zoom in / value2 = time in steps
	if name == 'epicZoom' then
		if value1 == '' then
			zoom = defaultZoom
		else
			zoom = value1
		end
		if value2 == '' then
			setProperty('defaultCamZoom', zoom)
		else
			--sec = beat : bpm * 60 || beat = step : 4
			seconds = value2/4/curBpm*60
			doTweenZoom('zoom','camGame',zoom,seconds,'linear')
		end
	end
end

function onTweenCompleted(tag)
	if tag == 'zoom' then
		setProperty('defaultCamZoom', zoom)
	end
end