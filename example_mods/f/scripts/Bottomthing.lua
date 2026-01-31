-- Script by Raltyro


noRatingScoreFormat = ' Score: %score | Misses: %misses | Rating: %rating'
scoreFormat = ' Score: %score | Misses: %misses | Rating: %rating (%percent%)'
percentDecimals = 2

-- Ratings - {percent - 0 to 100, ratingname} (orders doesn't matter)
noRatingName = '. . .'
ratingNames = {
	{100, "Perfect!!"},
	{90, "Sick!"},
	{80, "Great!"},
	{70, "Good"},
	{69, "nice"},
	{60, "Meh"},
	{50, "Bruh"},
	{40, "Bad"},
	{20, "Shit"},
	{0, "You Suck!"}
}

local errors
function updateRating()
	luaDebugMode = true
	local percent, rating = tonumber(getProperty("ratingPercent")) * 100, noRatingName
	local health = math.max(0, math.min(getHealth() * 50, 100))
	local showAcc = hits ~= 0

	if showAcc then
		local v
		for i = #ratingNames, 1, -1 do
			v = ratingNames[i]
			if (percent >= v[1]) then
				rating = v[2]
			else
				break
			end
		end
	end

	local decimals = 10 ^ percentDecimals
	percent = math.floor(percent * decimals) / decimals

	local str = showAcc and scoreFormat or noRatingScoreFormat
	str = str:gsub('%%score', score)
	str = str:gsub('%%misses', misses)
	str = str:gsub('%%rating', rating)
	str = str:gsub('%%percent', percent)
	str = str:gsub('%%health', health)

	setTextString("scoreTxt", str)
end

-- backwards compatibility
function onUpdateScore()
	onUpdate = nil; onUpdateScore = updateRating
	return updateRating()
end

onUpdate = updateRating

function onCreatePost()
	setTextFont('scoreTxt', 'FridayNight.ttf')
	setTextFont('timeTxt','FridayNight.ttf')
	setTextFont('botplayTxt','FridayNight.ttf')
	setTextBorder('timeTxt', 3, '000000')
	setTextBorder('scoreTxt', 3, '000000')
	setTextBorder('botplayTxt', 9, '000000')
	setObjectOrder('scoreTxt', getObjectOrder('iconP1') - 1)
	setProperty("timeBar.leftBar.color", getProperty("healthBar.leftBar.color"))
end

function onCreate()

	if not downscroll then
		makeAnimatedLuaSprite('FC','FCicon',945,628)
	end
	
	if  downscroll then
		makeAnimatedLuaSprite('FC','FCicon',945,66)
		end
		addAnimationByPrefix('FC','dance','WhenTheFC',24,true)
		objectPlayAnimation('FC','dance',false)
	setObjectCamera('FC', 'hud')
	scaleObject('FC',0.4,0.4)
	addLuaSprite('FC', true);
end


function noteMiss()
		removeLuaSprite('FC', true);
end
