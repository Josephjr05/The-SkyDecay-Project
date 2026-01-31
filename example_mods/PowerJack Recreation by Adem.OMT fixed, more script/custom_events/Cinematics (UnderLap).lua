--Created by RamenDominoes (Please credit if using this, thanks! <3)

HudAssets = {'healthBarBG','healthBar','scoreTxt','iconP1','iconP2','timeBar','timeBarBG','timeTxt'}
Index = 1

function onCreatePost()

    makeLuaSprite('UpperBar(UnderLap)', 'empty', -110, -350)
	makeGraphic('UpperBar(UnderLap)', 1500, 350, '000000')
	setObjectCamera('UpperBar(UnderLap)', 'HUD')
	addLuaSprite('UpperBar(UnderLap)', false)

    makeLuaSprite('LowerBar(UnderLap)', 'empty', -110, 720)
	makeGraphic('LowerBar(UnderLap)', 1500, 350, '000000')
	setObjectCamera('LowerBar(UnderLap)', 'HUD')
	addLuaSprite('LowerBar(UnderLap)', false)

    UpperBar = getProperty('UpperBar(UnderLap).y')
	LowerBar = getProperty('LowerBar(UnderLap).y')

    for Notes = 0,7 do 
        StrumY = getPropertyFromGroup('strumLineNotes', Notes, 'y')
    end
end


function onEvent(name, value1, value2)
	if name == 'Cinematics (UnderLap)' then
	
		Speed = tonumber(value1)
		Distance = tonumber(value2)

--ENTRANCES

		if Speed and Distance > 0 then

			doTweenY('UnderLap1', 'UpperBar(UnderLap)', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('UnderLap2', 'LowerBar(UnderLap)', LowerBar - Distance, Speed, 'QuadOut')

			for Tweens = 0,7 do 
				noteTweenY('MoveIn(UnderLap)'..Tweens, Tweens, (StrumY + Distance) - 35, Speed, 'QuadOut')

				for Alphas = 1,8 do
					doTweenAlpha('Alpha(UnderLap)'..Alphas, HudAssets[Index], 0, Speed - 0.1)
					Index = Index + 1
						
					if Index > #HudAssets then
						Index = 1
					end
				end
			end
		end

		if downscroll and Speed and Distance > 0 then
		
			doTweenY('UnderLap1', 'UpperBar(UnderLap)', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('UnderLap2', 'LowerBar(UnderLap)', LowerBar - Distance, Speed, 'QuadOut')

				for Tweens = 0,7 do 
					noteTweenY('MoveIn(UnderLap)'..Tweens, Tweens, (StrumY - Distance) + 35, Speed, 'QuadOut')
			
					for Alphas = 1,8 do
						doTweenAlpha('Alpha(UnderLap)'..Alphas, HudAssets[Index], 0, Speed - 0.1)
						Index = Index + 1
							
						if Index > #HudAssets then
							Index = 1
						
						end
					end
				end
			end

		if Distance <= 0 then
			
			doTweenY('UnderLap1', 'UpperBar(UnderLap)', UpperBar, Speed, 'QuadIn')
			doTweenY('UnderLap2', 'LowerBar(UnderLap)', LowerBar, Speed, 'QuadIn')

			for Tweens = 0,7 do 
				noteTweenY('MoveOut(UnderLap)'..Tweens, Tweens, StrumY , Speed, 'QuadIn')
			
				for Alphas = 1,8 do
					doTweenAlpha('Alpha(UnderLap)'..Alphas, HudAssets[Index], 1, Speed + 0.1)
					Index = Index + 1
							
					if Index > #HudAssets then
						Index = 1
						
					end
				end
			end
		end	
	end
end
