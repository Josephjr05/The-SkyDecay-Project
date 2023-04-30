--[[

LYRICS+ BY SALTYBOII

Please feel free to give feedback or ask for help in my DMs on Discord! (Saltyboii#2461)

Yes, you can use this in your mods. I don't know why I would upload it if you WEREN'T allowed to use it so that question is a little redundant, but yeah. Just credit me.

]]
local curWord = 1
local wordstuff = { -- The main meat of it all. Add text stuff here.
	{
		startStep = 519, -- The step of which the words appear, you can check where the steps are in the chart editor.
		endStep = 541, -- The step of which the words vanish.
		speaker = "Sonic.EXE", -- The person speaking.
		speakerColor = "FF0004", -- The hex color code for the speaker text.
		text = "Do you wanna play with me?" -- The actual text itself.
	},
	{
		startStep = 672, -- The step of which the words appear, you can check where the steps are in the chart editor.
		endStep = 693, -- The step of which the words vanish.
		speaker = "Sonic.EXE", -- The person speaking.
		speakerColor = "FF0004", -- The hex color code for the speaker text.
		text = "Want to try again?" -- The actual text itself.
	},
	{
		startStep = 1088, -- The step of which the words appear, you can check where the steps are in the chart editor.
		endStep = 1100, -- The step of which the words vanish.
		speaker = "Sonic.EXE", -- The person speaking.
		speakerColor = "FF0004", -- The hex color code for the speaker text.
		text = "*laughter*" -- The actual text itself.
	},
	{
		startStep = 1108, -- The step of which the words appear, you can check where the steps are in the chart editor.
		endStep = 1144, -- The step of which the words vanish.
		speaker = "Sonic.EXE", -- The person speaking.
		speakerColor = "FF0004", -- The hex color code for the speaker text.
		text = "So many Souls to play with..." -- The actual text itself.
	}
	
}

-- Underneath is the main meat of the script. I don't advice editing it unless you know what you're doing.
-- PS. If you encounter a bug whilst editing the code below. That's not my problem, don't DM me about that or I will send a shit ton of speech bubble gifs :3

function onCreatePost()
	makeLuaSprite('wordbox', '', 0, 500)
	makeGraphic('wordbox', 500, 125, '000000')
	addLuaSprite('wordbox', true)
	screenCenter('wordbox', 'x')
	setProperty('wordbox.alpha', 0)
	setObjectCamera('wordbox', 'camHUD')

	makeLuaText('speaker', '', 500, 0, 500)
	screenCenter('speaker', 'x')
	setTextBorder('speaker', 3, '000000')
	addLuaText('speaker', true)
	setTextSize('speaker', 45)
	setTextAlignment('speaker')

	makeLuaText('text', '', 490, 0, 560)
	screenCenter('text', 'x')
	setTextBorder('text', 2, '000000')
	addLuaText('text', true)
	setTextSize('text', 30)
	setTextAlignment('text')
end
function onStepHit()
	if curStep == wordstuff[curWord].startStep then
		doTweenAlpha('wordboxIn', 'wordbox', 0.7, 0.1, 'linear')
		doTweenAlpha('speakerIn', 'speaker', 1, 0.1, 'linear')
		doTweenAlpha('textIn', 'text', 1, 0.1, 'linear')
		textThing('wordbox')
		textThing('speaker')
		textThing('text')
		setTextString('speaker', string.upper(wordstuff[curWord].speaker))
		setTextString('text', wordstuff[curWord].text)
		setTextColor('speaker', wordstuff[curWord].speakerColor)
	elseif curStep == wordstuff[curWord].endStep then
		doTweenAlpha('wordboxOut', 'wordbox', 0, 0.1, 'linear')
		doTweenAlpha('speakerOut', 'speaker', 0, 0.1, 'linear')
		doTweenAlpha('textOut', 'text', 0, 0.1, 'linear')
		textThing('wordbox')
		textThing('speaker')
		textThing('text')
		curWord = curWord + 1
	end
end
function textThing(tag)
	setProperty(tag..'.y', getProperty(tag..'.y')-10)
	doTweenY(tag..'Popup', tag, getProperty(tag..'.y')+10, 0.1, 'linear')
end