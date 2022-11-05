trailEnabledDad = false;
trailEnabledBF = false;
timerStartedDad = false;
timerStartedBF = false;

trailLength = 5;
trailDelay = 0.05;

function onEvent(name, value1, value2)
	if name == "Shader" then
		if not (value1 == nil or value1 == '') and tonumber(value1) > 0 then
			if not timerStartedDad then
				runTimer('timerTrailDad', trailDelay, 0);
				timerStartedDad = true;
			end
			trailEnabledDad = true;
			curTrailDad = 0;
		else
			trailEnabledDad = false;
		end

		if not (value2 == nil or value2 == '') and tonumber(value2) > 0 then
			if not timerStartedBF then
				runTimer('timerTrailBF', trailDelay, 0);
				timerStartedBF = true;
			end
			trailEnabledBF = true;
			curTrailBF = 0;
		else
			trailEnabledBF = false;
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'timerTrailDad' then
		createTrailFrame('Dad');
	end

	if tag == 'timerTrailBF' then
		createTrailFrame('BF');
	end
end

curTrailDad = 0;
curTrailBF = 0;
function createTrailFrame(tag)
	num = 0;
	color = -1;
	image = '';
	frame = 'BF idle dance';
	x = 0;
	y = 0;
	scaleX = 0;
	scaleY = 0;
	offsetX = 0;
	offsetY = 0;
	flipX = false;
	flipY = false;
	antialiasing = false;

	if tag == 'BF' then
		num = curTrailBF;
		curTrailBF = curTrailBF + 1;
		if trailEnabledBF then
			color = getColorFromHex('FF0000');
			image = getProperty('boyfriend.imageFile')
			frame = getProperty('boyfriend.animation.frameName');
			x = getProperty('boyfriend.x');
			y = getProperty('boyfriend.y');
			scaleX = getProperty('boyfriend.scale.x'); 
			scaleY = getProperty('boyfriend.scale.y'); 
			offsetX = getProperty('boyfriend.offset.x');
			offsetY = getProperty('boyfriend.offset.y');
			flipX = getProperty('boyfriend.flipX');
			flipY = getProperty('boyfriend.flipY');
			antialiasing = getProperty('boyfriend.antialiasing');
			color2 = getColorFromHex('00FF00');
			color3 = getColorFromHex('0000FF');
		end
	else
		num = curTrailDad;
		curTrailDad = curTrailDad + 1;
		if trailEnabledDad then
			color = getColorFromHex('FF0000');
			image = getProperty('dad.imageFile')
			frame = getProperty('dad.animation.frameName');
			x = getProperty('dad.x');
			y = getProperty('dad.y');
			scaleX = getProperty('dad.scale.x');
			scaleY = getProperty('dad.scale.y');
			offsetX = getProperty('dad.offset.x');
			offsetY = getProperty('dad.offset.y');
			flipX = getProperty('dad.flipX');
			flipY = getProperty('dad.flipY');
			antialiasing = getProperty('dad.antialiasing');
			color2 = getColorFromHex('00FF00');
			color3 = getColorFromHex('0000FF');
		end
	end

	if num - trailLength + 1 >= 0 then
		for i = (num - trailLength + 1), (num - 1) do
			setProperty('psychicTrail'..tag..i..'.alpha', getProperty('psychicTrail'..tag..i..'.alpha') - (0.6 / (trailLength - 1)));
			setProperty('psychicTrail2'..tag..i..'.alpha', getProperty('psychicTrail2'..tag..i..'.alpha') - (0.6 / (trailLength - 1)));
			setProperty('psychicTrail3'..tag..i..'.alpha', getProperty('psychicTrail3'..tag..i..'.alpha') - (0.6 / (trailLength - 1)));
		end
	end
	removeLuaSprite('psychicTrail'..tag..(num - trailLength));
	removeLuaSprite('psychicTrail2'..tag..(num - trailLength));
	removeLuaSprite('psychicTrail3'..tag..(num - trailLength));

	if not (image == '') then
		trailTag = 'psychicTrail'..tag..num;
		trailTag2 = 'psychicTrail2'..tag..num;
		trailTag3 = 'psychicTrail3'..tag..num;
		makeAnimatedLuaSprite(trailTag, image, x + 10, y);
		setProperty(trailTag..'.offset.x', offsetX);
		setProperty(trailTag..'.offset.y', offsetY);
		setProperty(trailTag..'.scale.x', scaleX);
		setProperty(trailTag..'.scale.y', scaleY);
		setProperty(trailTag..'.flipX', flipX);
		setProperty(trailTag..'.flipY', flipY);
		setProperty(trailTag..'.antialiasing', antialiasing);
		setProperty(trailTag..'.alpha', 0.24);
		setProperty(trailTag..'.color', color);
		setBlendMode(trailTag, 'add');
		addAnimationByPrefix(trailTag, 'stuff', frame, 0, false);
		addLuaSprite(trailTag, true);
		makeAnimatedLuaSprite(trailTag2, image, x - 10, y);
		setProperty(trailTag2..'.offset.x', offsetX);
		setProperty(trailTag2..'.offset.y', offsetY);
		setProperty(trailTag2..'.scale.x', scaleX);
		setProperty(trailTag2..'.scale.y', scaleY);
		setProperty(trailTag2..'.flipX', flipX);
		setProperty(trailTag2..'.flipY', flipY);
		setProperty(trailTag2..'.antialiasing', antialiasing);
		setProperty(trailTag2..'.alpha', 0.24);
		setProperty(trailTag2..'.color', color2);
		setBlendMode(trailTag2, 'add');
		addAnimationByPrefix(trailTag2, 'stuff', frame, 0, false);
		addLuaSprite(trailTag2, true);
		makeAnimatedLuaSprite(trailTag3, image, x, y);
		setProperty(trailTag3..'.offset.x', offsetX);
		setProperty(trailTag3..'.offset.y', offsetY);
		setProperty(trailTag3..'.scale.x', scaleX);
		setProperty(trailTag3..'.scale.y', scaleY);
		setProperty(trailTag3..'.flipX', flipX);
		setProperty(trailTag3..'.flipY', flipY);
		setProperty(trailTag3..'.antialiasing', antialiasing);
		setProperty(trailTag3..'.alpha', 0.24);
		setProperty(trailTag3..'.color', color3);
		setBlendMode(trailTag3, 'add');
		addAnimationByPrefix(trailTag3, 'stuff', frame, 0, false);
		addLuaSprite(trailTag3, true);
	end
end