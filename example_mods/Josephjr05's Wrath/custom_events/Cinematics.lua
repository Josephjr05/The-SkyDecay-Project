-- Created by RamenDominoes (Feel free to credit or not I don't really care)
--Not bad for my first event created... I think

StartStop = 0

Speed = 0



function onCreate()
	

	--THE TOP BAR
	makeLuaSprite('UpperBar', 'empty', 0, -120)
	makeGraphic('UpperBar', 1280, 120, '000000')
	setObjectCamera('UpperBar', 'hud')
	addLuaSprite('UpperBar', false)


	--THE BOTTOM BAR
	makeLuaSprite('LowerBar', 'empty', 0, 720)
	makeGraphic('LowerBar', 1280, 120, '000000')
	setObjectCamera('LowerBar', 'hud')
	addLuaSprite('LowerBar', false)

end


function onUpdate()

	if StartStop == 1 then
	
	doTweenY('Cinematics1', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2', 'LowerBar', 600, Speed, 'Linear')
	doTweenY('AlphaTween1', 'healthBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween2', 'healthBar', 0, 0.1)
	doTweenAlpha('AlphaTween3', 'scoreTxt', 0, 0.1)
	doTweenAlpha('AlphaTween4', 'iconP1', 0, 0.1)
	doTweenAlpha('AlphaTween5', 'iconP2', 0, 0.1)
	doTweenAlpha('AlphaTween6', 'timeBar', 0, 0.1)
	doTweenAlpha('AlphaTween7', 'timeBarBG', 0, 0.1)
	doTweenAlpha('AlphaTween8', 'timeTxt', 0, 0.1)

	end

	if downscroll and StartStop == 1 then
	
	doTweenY('Cinematics1', 'UpperBar', 0, Speed, 'Linear')
	doTweenY('Cinematics2', 'LowerBar', 600, Speed, 'Linear')
	doTweenY('AlphaTween1', 'healthBarBG', 140, Speed, 'Linear')
	doTweenY('AlphaTween2', 'healthBar', 140, Speed, 'Linear')
	doTweenY('AlphaTween4', 'iconP1', 60, Speed, 'Linear')
	doTweenY('AlphaTween5', 'iconP2', 60, Speed, 'Linear')
	doTweenY('AlphaTween6', 'timeBar', 600, Speed, 'Linear')
	doTweenY('AlphaTween7', 'timeBarBG', 600, Speed, 'Linear')
	doTweenY('AlphaTween8', 'timeTxt', 590, Speed, 'Linear')

	end


	if StartStop == 2 then
	
	doTweenY('Cinematics1', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2', 'LowerBar', 720, Speed, 'Linear')
	doTweenAlpha('AlphaTween1', 'healthBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween2', 'healthBar', 1, 0.1)
	doTweenAlpha('AlphaTween3', 'scoreTxt', 1, 0.1)
	doTweenAlpha('AlphaTween4', 'iconP1', 1, 0.1)
	doTweenAlpha('AlphaTween5', 'iconP2', 1, 0.1)
	doTweenAlpha('AlphaTween6', 'timeBar', 1, 0.1)
	doTweenAlpha('AlphaTween7', 'timeBarBG', 1, 0.1)
	doTweenAlpha('AlphaTween8', 'timeTxt', 1, 0.1)
	
	end

	if downscroll and StartStop == 2 then
	
	doTweenY('Cinematics1', 'UpperBar', -120, Speed, 'Linear')
	doTweenY('Cinematics2', 'LowerBar', 720, Speed, 'Linear')
	doTweenY('AlphaTween1', 'healthBarBG', 60, Speed, 'Linear')
	doTweenY('AlphaTween2', 'healthBar', 60, Speed, 'Linear')
	doTweenY('AlphaTween4', 'iconP1', 0, Speed, 'Linear')
	doTweenY('AlphaTween5', 'iconP2', 0, Speed, 'Linear')
	doTweenY('AlphaTween6', 'timeBar', 690, Speed, 'Linear')
	doTweenY('AlphaTween7', 'timeBarBG', 690, Speed, 'Linear')
	doTweenY('AlphaTween8', 'timeTxt', 680, Speed, 'Linear')
	
	end
	
end

function onEvent(name,value1,value2)
	if name == 'Cinematics' then
		StartStop = tonumber(value1)
		Speed = tonumber(value2)
			end
	
		end
