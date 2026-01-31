--Created by RamenDominoes (Please credit if using this, thanks! <3)

HudAssets = {'healthBarBG','healthBar','scoreTxt','iconP1','iconP2','timeBar','timeBarBG','timeTxt'}
Index = 1

function onCreatePost()

    makeLuaSprite('UpperBar(No HUD)', 'empty', -110, -350)
	makeGraphic('UpperBar(No HUD)', 1500, 350, '000000')
	setObjectCamera('UpperBar(No HUD)', 'HUD')
	addLuaSprite('UpperBar(No HUD)', false)

    makeLuaSprite('LowerBar(No HUD)', 'empty', -110, 720)
	makeGraphic('LowerBar(No HUD)', 1500, 350, '000000')
	setObjectCamera('LowerBar(No HUD)', 'HUD')
	addLuaSprite('LowerBar(No HUD)', false)

    UpperBar = getProperty('UpperBar(No HUD).y')
	LowerBar = getProperty('LowerBar(No HUD).y')

    for Notes = 0,7 do 
        StrumY = getPropertyFromGroup('strumLineNotes', Notes, 'y')
    end
end

function onEvent(name, value1, value2)
	if name == 'Cinematics (No HUD)' then
	
		Speed = tonumber(value1)
		Distance = tonumber(value2)

--ENTRANCES

		if Speed and Distance > 0 then

			doTweenY('No HUD1', 'UpperBar(No HUD)', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('No HUD2', 'LowerBar(No HUD)', LowerBar - Distance, Speed, 'QuadOut')

			for Tweens = 0,7 do 
				noteTweenY('MoveIn(No HUD)'..Tweens, Tweens, (StrumY + Distance) - 35, Speed, 'QuadOut')
				noteTweenAlpha('FadeOut(No HUD)'..Tweens, Tweens, 0, Speed)

			
				for Alphas = 1,8 do
					doTweenAlpha('Alpha(No HUD)'..Alphas, HudAssets[Index], 0, Speed - 0.1)
					Index = Index + 1
						
					if Index > #HudAssets then
						Index = 1
					end
				end
			end
		end

		if downscroll and Speed and Distance > 0 then
		
			doTweenY('No HUD1', 'UpperBar(No HUD)', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('No HUD2', 'LowerBar(No HUD)', LowerBar - Distance, Speed, 'QuadOut')

				for Tweens = 0,7 do 
					noteTweenY('MoveIn(No HUD)'..Tweens, Tweens, (StrumY - Distance) + 35, Speed, 'QuadOut')
					noteTweenAlpha('FadeOut(No HUD)'..Tweens, Tweens, 0, Speed)


					for Alphas = 1,8 do
						doTweenAlpha('Alpha(No HUD)'..Alphas, HudAssets[Index], 0, Speed - 0.1)
						Index = Index + 1
							
						if Index > #HudAssets then
							Index = 1
						
						end
					end
				end
			end

			if Distance <= 0 then
			
			doTweenY('No HUD1', 'UpperBar(No HUD)', UpperBar, Speed, 'QuadIn')
			doTweenY('No HUD2', 'LowerBar(No HUD)', LowerBar, Speed, 'QuadIn')

			for Tweens = 0,7 do 
				noteTweenY('MoveOut(No HUD)'..Tweens, Tweens, StrumY , Speed, 'QuadIn')
				noteTweenAlpha('FadeIn(No HUD)'..Tweens, Tweens, 1, Speed)


				for Alphas = 1,8 do
					doTweenAlpha('Alpha(No HUD)'..Alphas, HudAssets[Index], 1, Speed + 0.1)
					Index = Index + 1
							
					if Index > #HudAssets then
						Index = 1
						
					end
				end
			end
		end	
	end
end
