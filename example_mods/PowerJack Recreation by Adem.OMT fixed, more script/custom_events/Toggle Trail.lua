--note
-- variables
trailEnabledDad = false;
trailEnabledBF = false;
timerStartedDad = false;
timerStartedBF = false;
startTrailDad = true
getTrailOrder = false


trailLength = 6;
trailDelay = 0.05;
trailAlpha = 0.6
trailObjectOrder = -1

local meximexi = false

function onEvent(name, value1, value2)
	if name == 'Toggle Trail' then




		function onTimerCompleted(tag, loops, loopsLeft)
			if tag == 'stopTrailDad' then
				numberDad = 0
				trailEnabledDad = false
			end

			if tag == 'stopTrailBF' then
				trailEnabledBF = false
				numberBF = 0
				createTrailFrameBF('BF');
			end
			
			if tag == 'timerTrailBF' then
				createTrailFrameBF('BF');
			end
			if tag == 'timerTrailDad' then
				createTrailFrameDad('Dad');
			end
		end
		
		-- toggle dad trail
		if not (value1 == '0' or value1 == '') then
			numberDad = trailAlpha
			trailEnabledDad = true
			
			curTrailDad = 0;
			function createTrailFrameDad(tag)
				num = 0;
				color = -1;
				image = '';
				frameDad = 'BF idle dance';
				x = 0;
				y = 0;
				x2 = 0;
				y2 = 0;
				offsetX = 0;
				offsetY = 0;
			
				if tag == 'Dad' then
					num = curTrailDad;
					curTrailDad = curTrailDad + 1;
					if trailEnabledDad and startTrailDad == true then
						-- get color from health bar thingy
						r = getProperty('dad.healthColorArray[0]')
						g = getProperty('dad.healthColorArray[1]')
						b = getProperty('dad.healthColorArray[2]')
						if songName == 'Casanova' or songName == 'Casanova-Void' then
							color = getColorFromHex('d01b60')
						elseif songName == 'Payback' or songName == 'Payback-Void' then
							color = getColorFromHex('FFFFFF')
						else
							color = (r * 0x10000) + (g * 0x100) + b
						end
						-- stuff
						doIT = true
						flip = getProperty('dad.flipX')
						image = getProperty('dad.imageFile')
						frameDad = getProperty('dad.animation.frameName');
						scaleX = getProperty('dad.scale.x')
						scaleY = getProperty('dad.scale.y')
						x = getProperty('dad.x');
						y = getProperty('dad.y');
						x2 = getProperty('dad.x');
						y2 = getProperty('dad.y');
						offsetX = getProperty('dad.offset.x');
						offsetX2i = offsetX*x;
						offsetY = getProperty('dad.offset.y');
						offsetY2 = getProperty('dad.offset.y');
					end
				end
			
				if num - trailLength + 1 >= 0 then
					for i = (num - trailLength + 1), (num - 1) do
						setProperty('psychicTrail'..tag..i..'.alpha', getProperty('psychicTrail'..tag..i..'.alpha') - (0.6 / (trailLength - 1)));
					end
				end
				removeLuaSprite('psychicTrail'..tag..(num - trailLength));
			
				if not (image == '') then
					trailTag = 'psychicTrail'..tag..num;
					if songName == 'Payback-Void' then
						if curBeat == 516 then
							trailAlpha = 0
						end
					end
					makeAnimatedLuaSprite(trailTag, image, x, y);
					setProperty(trailTag..'.offset.x', offsetX);
					setProperty(trailTag..'.offset.y', offsetY);
					setProperty(trailTag..'.scale.x', scaleX)
					setProperty(trailTag..'.scale.y', scaleY)
					setProperty(trailTag..'.flipX', flip)
					setObjectOrder(trailTag, trailObjectOrderDad)
					setProperty(trailTag..'.alpha', numberDad);
					setProperty(trailTag..'.color', color);
					addAnimationByPrefix(trailTag, 'stuff', frameDad, 0, false);
					addLuaSprite(trailTag, false);
					offsetX2 =  getProperty(trailTag..'.offset.x') + getProperty(trailTag..'.x')
					-- ooooooh cool new move mechanic that doesnt really work but do what you will with it
					if move then
						function opponentNoteHit(id, noteData, noteType, isSustainNote)
							if move and trailEnabledDad and trailEnabledBF then
								trailTag = 'psychicTrail'..tag..num;
								if not isSustainNote then
									if noteData == 1 or noteData == 3 then
										doTweenX('trail1', trailTag, -230 + 80, 0.08 , linear)
									end
	
	
									if noteData == 0 then
										doTweenAngle('trail2', trailTag, -5, 0.08 , linear)
										doTweenX('trail3', trailTag, -130 + -60 , 0.08 , linear)	
										setProperty(trailTag..'.y', 310 + 20)	
									end
	
									if noteData == 2 then
										setProperty(trailTag..'.y', 310 + -60)	
										doTweenX('trail4', trailTag, -130 + -60 , 0.08 , linear)	
										doTweenAngle('trail5', trailTag, -5, 0.08 , linear)
									end

									if noteData == 3 then
										setProperty(trailTag..'.y', 310 + -60)	
										doTweenAngle('trail6', trailTag, 5, 0.08 , linear)
									end

									if noteData == 1 then
										setProperty(trailTag..'.y', 310 + 20)	
									end
								end
							end
							-- have this same on how it is on the top 
							if move and trailEnabledDad and not trailEnabledBF then
								if not isSustainNote then
									if noteData == 1 or noteData == 3 then
										doTweenX('trail1', trailTag, -230 + 80, 0.08 , linear)
									end
	
									if noteData == 0 then
										doTweenAngle('trail2', trailTag, -5, 0.08 , linear)
										doTweenX('trail3', trailTag, -130 + -60 , 0.08 , linear)	
										setProperty(trailTag..'.y', 310 + 20)	
									end
	
									if noteData == 2 then
										setProperty(trailTag..'.y', 310 + -60)	
										doTweenX('trail4', trailTag, -130 + -60 , 0.08 , linear)	
										doTweenAngle('trail5', trailTag, -5, 0.08 , linear)
									end

									if noteData == 3 then
										setProperty(trailTag..'.y', 310 + -60)	
										doTweenAngle('trail6', trailTag, 5, 0.08 , linear)
									end

									if noteData == 1 then
										setProperty(trailTag..'.y', 310 + 20)	
									end
								end

							end

						end
					end
				end



			end
			if not timerStartedDad then
			runTimer('timerTrailDad', trailDelay, 0);
			timerStartedDad = true;
			trailEnabledDad = true
		end
	else
		trailEnabledDad = false
		numberDad = 0
	end
	
	if name == 'moviAi' then
		meximexi = not meximexi
	end

	-- toggle bf trail
	if not (value2 == '0' or value2 == '') then
		getTrailOrder = true
		numberBF = trailAlpha
		trailEnabledBF = true

		curTrailBF = 0;
		function createTrailFrameBF(tag)
			num = 0;
			color = -1;
			image = '';
			frame = 'BF idle dance';
			x = 0;
			y = 0;
			offsetX = 0;
			offsetY = 0;
		
			if tag == 'BF' then
				num = curTrailBF;
				curTrailBF = curTrailBF + 1;
				if trailEnabledBF then
						-- get color from health bar thingy
						r = getProperty('boyfriend.healthColorArray[0]')
						g = getProperty('boyfriend.healthColorArray[1]')
						b = getProperty('boyfriend.healthColorArray[2]')
						if songName == 'Payback-Void' then
							color = getColorFromHex('FFFFFF')
						else
						color = (r * 0x10000) + (g * 0x100) + b
						end
						-- stuff					
					flip = getProperty('boyfriend.flipX')
					image = getProperty('boyfriend.imageFile')
					frame = getProperty('boyfriend.animation.frameName');
					scaleX = getProperty('boyfriend.scale.x')
					scaleY = getProperty('boyfriend.scale.y')
					x = getProperty('boyfriend.x');
					y = getProperty('boyfriend.y');
					offsetX = getProperty('boyfriend.offset.x');
					offsetY = getProperty('boyfriend.offset.y');
				end
			end
		
			if num - trailLength + 1 >= 0 then
				for i = (num - trailLength + 1), (num - 1) do
					setProperty('psychicTrail'..tag..i..'.alpha', getProperty('psychicTrail'..tag..i..'.alpha') - (0.6 / (trailLength - 1)));
				end
			end
			removeLuaSprite('psychicTrail'..tag..(num - trailLength));
		
			if not (image == '') then
				trailTag = 'psychicTrail'..tag..num;
				makeAnimatedLuaSprite(trailTag, image, x, y);
				setProperty(trailTag..'.offset.x', offsetX);
				setProperty(trailTag..'.offset.y', offsetY);
				setProperty(trailTag..'.flipX', flip)
				setProperty(trailTag..'.scale.x', scaleX)
				setProperty(trailTag..'.scale.y', scaleY)
				setObjectOrder(trailTag, trailObjectOrderBf)
				setProperty(trailTag..'.alpha', numberBF);
				setProperty(trailTag..'.color', color);
				--setBlendMode(trailTag, 'add');-- note this adds more of an instese color 
				addAnimationByPrefix(trailTag, 'stuff', frame, 0, false);
				addLuaSprite(trailTag, false);
			end
		end
		if not timerStartedBF then
		runTimer('timerTrailBF', trailDelay, 0);
		timerStartedBF = true;
		trailEnabledBF = true
	end
else
	trailEnabledBF = false
	numberBF = 0
	setProperty(trailTag..'.alpha', numberBF);
end


function onUpdate()

	-- sets the trail over gf this may break but idk
	if getTrailOrder then
		trailObjectOrderDad = getObjectOrder('gfGroup') +1
		trailObjectOrderBf = getObjectOrder('gfGroup') +1
	else
		trailObjectOrderBf = getObjectOrder('gfGroup') +1
		trailObjectOrderDad = getObjectOrder('dadGroup') 
	end

	-- move bullshit thing
	if meximexi then
		move = true
	else
		move = false 
	end

end
	end
end