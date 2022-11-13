-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: options in pause menu
-- Dependencies of script: PauseSubstate.lua, publicTimeTxt.lua
-- How to use:
--   Open pause menu
--   Left mouse click on gray thing in right bottom corner of screen
--   Scroll with mouse
--   Left mouse click on bool or list option to change value
--   Left mouse hold and scroll with mouse on int or float option to change value
--   Press the R key or right mouse click to reset value to default
--   Left mouse click on "Click to Open" thing to close it

function onCustomSubstateCreatePost(name)
	if name == "PauseMenu" then
		addHaxeLibrary('FlxMath', 'flixel.math')
		addHaxeLibrary('FlxText', 'flixel.text')
		addHaxeLibrary('Reflect')
		runHaxeCode([[
			setVar('pos', [FlxG.width - 400, FlxG.height - 150, 400, 150]);
			setVar('optionsArray', [
				{name: "downScroll", type: "bool", values: ["Upscroll", "Downscroll"], value: 0},
				{name: "middleScroll", type: "bool", values: ["Middlescroll - OFF", "Middlescroll - ON"], value: 0},
				{name: "ghostTapping", type: "bool", values: ["Ghost Tapping - OFF", "Ghost Tapping - ON"], value: 0},
				//{name: "controllerMode", type: "bool", values: ["Controller Mode - OFF", "Controller Mode - ON"], value: 0},
				{name: "noReset", type: "bool", values: ["Reset Button - ON", "Reset Button - OFF"], value: 0},
				//{name: "keyBinds", type: "custom"},
				//{name: "gameplaySettings", type: "custom"},

				{name: "HUD Elements", type: "title"},
				{name: "opponentStrums", type: "bool", values: ["Opponent Notes - OFF", "Opponent Notes - ON"], value: 0},
				{name: "hitsoundVolume", type: "float", values: ["Hitsound Volume - %v%"], value: 0, min: 0, step: 0.1, max: 1},
				//{name: "arrowHSV", type: "custom"},
				{name: "noteSplashes", type: "bool", values: ["Note Splashes - OFF", "Note Splashes - ON"], value: 0},
				{name: "camZooms", type: "bool", values: ["Camera Zooms - OFF", "Camera Zooms - ON"], value: 0},
				{name: "scoreZoom", type: "bool", values: ["Score Text Static", "Score Text Zoom on Hit"], value: 0},
				{name: "healthBarAlpha", type: "float", values: ["Health Bar Transparency - %v%"], value: 0, min: 0, step: 0.1, max: 1},
				{name: "hideHud", type: "bool", values: ["Show HUD", "Hide HUD"], value: 0},
				{name: "timeBarType", type: "list", values: ["Time Bar Type - Time Left", "Time Bar Type - Time Elapsed", "Time Bar Type - Song Name", "Time Bar Type - Disabled"], value: 0},

				{name: "Graphics", type: "title"},
				{name: "showFPS", type: "bool", values: ["FPS Counter - OFF", "FPS Counter - ON"], value: 0},
				{name: "framerate", type: "int", values: ["Framerate - %v FPS"], value: 0, min: 60, step: 1, max: 240},

				{name: "Offsets", type: "title"},
				//{name: "comboOffset", type: "custom"},
				{name: "ratingOffset", type: "int", values: ["Rating Offset - %vms"], value: 0, min: -30, step: 1, max: 30},
				{name: "sickWindow", type: "int", values: ["Sick Window - %vms"], value: 0, min: 15, step: 1, max: 45},
				{name: "goodWindow", type: "int", values: ["Good Window - %vms"], value: 0, min: 15, step: 1, max: 90},
				{name: "badWindow", type: "int", values: ["Bad Window - %vms"], value: 0, min: 15, step: 1, max: 135},
				{name: "safeFrames", type: "int", values: ["Safe Frames - %v"], value: 0, min: 2, step: 1, max: 10}
			]);

			setVar('bg_dragger', null);
			setVar('text_dragger', null);
			setVar('bg', null);
			setVar('textArray', []);

			setVar('text_draggerOffsetY', 10);
			setVar('scrollStep', 20);
			setVar('mouseOffsetY', 25);
			setVar('opened', false);

			setVar('color_focus', 0xffffffff);
			setVar('color_unfocus', 0xffcccccc);
			setVar('color_title', 0xffbeccb1);

			setVar('objects_pm', []);

			setVar('bg', new FlxSprite(getVar('pos')[0], FlxG.height).makeGraphic(getVar('pos')[2], getVar('pos')[3], 0xff808080));
			getVar('objects_pm').push(getVar('bg'));

			setVar('bg_dragger', new FlxSprite(getVar('pos')[0], FlxG.height + 50).makeGraphic(getVar('pos')[2], getVar('pos')[3] - 100, 0xff606060));
			getVar('objects_pm').push(getVar('bg_dragger'));

			setVar('text_dragger', new FlxText(getVar('pos')[0] + 120, FlxG.height + 50 + getVar('text_draggerOffsetY'), 0, 'Click to Open'));
			getVar('text_dragger').setFormat(Paths.font('vcr.ttf'), 20);
			getVar('objects_pm').push(getVar('text_dragger'));

			FlxG.mouse.visible = true;
		]])
		
		for i = 0, tonumber(getStaticProperty("getVar('optionsArray').length")) - 1 do
			runHaxeCode([[
				var t:FlxText = new FlxText(getVar('pos')[0], FlxG.height, 0, ']]..getOptionText(i)..[[');
				t.setFormat(Paths.font('vcr.ttf'), 19, getVar('color_unfocus'));
				getVar('textArray').push(t);
				getVar('objects_pm').push(t);

				getVar('optionsArray')[ ]]..i..[[ ].defaultValue = getVar('optionsArray')[ ]]..i..[[ ].value;
			]])
		end
		

		runHaxeCode([[
			for (op in getVar('objects_pm'))
			{
				op.cameras = [game.camOther];
				game.add(op);
			}

			FlxTween.tween(getVar('text_dragger'), {y: getVar('bg').y - 50 + getVar('text_draggerOffsetY')}, 0.4);
			FlxTween.tween(getVar('bg_dragger'), {y: getVar('bg').y - 50 + getVar('text_draggerOffsetY')}, 0.4);
		]])
	end
end

function getOptionText(index)
	if getStaticProperty("getVar('optionsArray')["..tostring(index).."].type") == 'title' then
		return getStaticProperty("getVar('optionsArray')["..tostring(index).."].name")
	end

	local cp = getPropertyFromClass('ClientPrefs', getStaticProperty("getVar('optionsArray')["..tostring(index).."].name"))
	if cp == nil then
		return '  '..getStaticProperty("getVar('optionsArray')["..tostring(index).."].name")
	end

	if getStaticProperty("getVar('optionsArray')["..tostring(index).."].type") == 'bool' then
		return '  '..getStaticProperty("getVar('optionsArray')["..tostring(index).."].values["..tostring(cp).."]")
	elseif getStaticProperty("getVar('optionsArray')["..tostring(index).."].type") == 'int' or getStaticProperty("getVar('optionsArray')["..tostring(index).."].type") == 'float' then
		cp = tonumber(getStaticProperty("FlxMath.roundDecimal("..tostring(cp)..", 1)"))
		if stringEndsWith(getStaticProperty("getVar('optionsArray')["..tostring(index).."].values[0]"), '%') then
			cp = cp * 100
		end
		return '  '..getStaticProperty("StringTools.replace(getVar('optionsArray')["..tostring(index).."].values[0], '%v', '"..tostring(cp).."')")
	elseif getStaticProperty("getVar('optionsArray')["..tostring(index).."].type") == 'list' then
		for i = 0, tonumber(getStaticProperty("getVar('optionsArray')["..tostring(index).."].values.length")) - 1 do
			if stringEndsWith(getStaticProperty("getVar('optionsArray')["..tostring(index).."].values["..tostring(i).."]"), cp) then
				return '  '..getStaticProperty("getVar('optionsArray')["..tostring(index).."].values["..tostring(i).."]")
			end
		end
	end

	return '  '..getStaticProperty("getVar('optionsArray')["..tostring(index).."].name");
end

function onCustomSubstateUpdatePost(name, elapsed)
	if name == 'PauseMenu' then
		local wheel = tonumber(getStaticProperty("FlxG.mouse.wheel"))
		if overlap("getVar('bg')") then
			if wheel ~= 0 then
				updatePosition(wheel)
			end
			if getStaticProperty("getVar('opened')") == 'true' then
				updateValues()
			end
		elseif overlap("getVar('bg_dragger')") and mouseClicked('left') then
			updatePositionDragger()
		end
	end
end

function updatePositionDragger()
	if getStaticProperty("getVar('opened')") == 'true' then
		runHaxeCode("for (i in 0...getVar('textArray').length) getVar('textArray')[i].y = getVar('pos')[1] + (20 * i);")
		updatePosition()
		runHaxeCode([[
			for (txt in getVar('textArray'))
				FlxTween.tween(txt, {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut,
					onUpdate: function (tween) {getVar('text_dragger').y = getVar('bg').y - 50 + getVar('text_draggerOffsetY');}
				});
			FlxTween.tween(getVar('bg'), {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut,
				onUpdate: function (tween) {getVar('bg_dragger').y = getVar('bg').y - 50;},
				onComplete: function (tween) {setVar('opened', false);}
			});
		]])
	else
		runHaxeCode([[
			for (i in 0...getVar('textArray').length)
				FlxTween.tween(getVar('textArray')[i], {y: getVar('pos')[1] + (20 * i)}, 0.4, {ease: FlxEase.quartInOut,
					onUpdate: function (tween){getVar('text_dragger').y = getVar('bg').y - 50 + getVar('text_draggerOffsetY');}
				});
			FlxTween.tween(getVar('bg'), {y: getVar('pos')[1]}, 0.4, {ease: FlxEase.quartInOut,
				onUpdate: function (tween) {getVar('bg_dragger').y = getVar('bg').y - 50;},
				onComplete: function (tween) {setVar('opened', true);}
			});
		]])
	end
end

function updatePosition(wheel)
	if wheel == nil then wheel = 0 end

	if not mousePressed('left') and wheel > 0 and tonumber(getStaticProperty("getVar('textArray')[0].y")) < tonumber(getStaticProperty("getVar('pos')[1]")) then
		for i = 0, getStaticProperty("getVar('textArray').length") - 1 do
			runHaxeCode("getVar('textArray')["..tostring(i).."].y += getVar('scrollStep');")
		end
	end
	if not mousePressed('left') and wheel < 0 and tonumber(getStaticProperty("getVar('textArray')[getVar('textArray').length - 1].y")) + tonumber(getStaticProperty("getVar('textArray')[getVar('textArray').length - 1].height")) > tonumber(getStaticProperty("getVar('pos')[1]")) + tonumber(getStaticProperty("getVar('pos')[3]")) then
		for i = 0, getStaticProperty("getVar('textArray').length") - 1 do
			runHaxeCode("getVar('textArray')["..tostring(i).."].y -= getVar('scrollStep');")
		end
	end

	for i = 0, getStaticProperty("getVar('textArray').length") - 1 do
		local _y = tonumber(getStaticProperty("getVar('textArray')["..tostring(i).."].y"))
		local _y1 = tonumber(getStaticProperty("getVar('pos')[1]"))
		local _height = tonumber(getStaticProperty("getVar('textArray')["..tostring(i).."].height"))
		local _height1 = tonumber(getStaticProperty("getVar('pos')[3]"))

		if _y > _y1 then
			runHaxeCode("getVar('textArray')["..tostring(i).."].visible = true;")
		end
		if _y + _height < _y1 + _height1 then
			runHaxeCode("getVar('textArray')["..tostring(i).."].visible = true;")
		end

		if _y < _y1 then
			runHaxeCode("getVar('textArray')["..tostring(i).."].visible = false;")
		end
		if _y + _height > _y1 + _height1 then
			runHaxeCode("getVar('textArray')["..tostring(i).."].visible = false;")
		end
	end
end

function updateValues()
	for i = 0, getStaticProperty("getVar('optionsArray').length") - 1 do
		local type = getStaticProperty("getVar('optionsArray')["..tostring(i).."].type")
		local name = getStaticProperty("getVar('optionsArray')["..tostring(i).."].name")
		if type == 'bool' then
			if overlap("getVar('textArray')["..tostring(i).."]") then
				if mouseClicked('left') then
					runHaxeCode([[
						getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = ]]..tostring(intToBool(getPropertyFromClass('ClientPrefs', name), true))..[[;
						getVar('optionsArray')[ ]]..tostring(i)..[[ ].value++;
						if (getVar('optionsArray')[ ]]..tostring(i)..[[ ].value > getVar('optionsArray')[ ]]..tostring(i)..[[ ].values.length - 1) getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = 0;
					]])
					setOption(i, intToBool(tonumber(getStaticProperty("getVar('optionsArray')["..tostring(i).."].value"))))
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, intToBool(tonumber(getStaticProperty("getVar('optionsArray')["..tostring(i).."].defaultValue"))))
				end
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_focus');")
			else
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_unfocus');")
			end
		elseif type == 'int' or type == 'float' then
			if overlap("getVar('textArray')["..tostring(i).."]") then
				if mousePressed('left') and getPropertyFromClass('flixel.FlxG', 'mouse.wheel') ~= 0 then
					runHaxeCode([[
						getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = ]]..getPropertyFromClass('ClientPrefs', name)..[[;
		
						if (FlxG.mouse.wheel > 0) getVar('optionsArray')[ ]]..tostring(i)..[[ ].value += getVar('optionsArray')[ ]]..tostring(i)..[[ ].step;
						if (FlxG.mouse.wheel < 0) getVar('optionsArray')[ ]]..tostring(i)..[[ ].value -= getVar('optionsArray')[ ]]..tostring(i)..[[ ].step;
		
						if (getVar('optionsArray')[ ]]..tostring(i)..[[ ].value < getVar('optionsArray')[ ]]..tostring(i)..[[ ].min) getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = getVar('optionsArray')[ ]]..tostring(i)..[[ ].max;
						if (getVar('optionsArray')[ ]]..tostring(i)..[[ ].value > getVar('optionsArray')[ ]]..tostring(i)..[[ ].max) getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = getVar('optionsArray')[ ]]..tostring(i)..[[ ].min;
					]])
					if type == 'int' then
						setOption(i, tonumber(getStaticProperty("Std.int(getVar('optionsArray')["..tostring(i).."].value)")))
					else
						setOption(i, tonumber(getStaticProperty("getVar('optionsArray')["..tostring(i).."].value")))
					end
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, tonumber(getStaticProperty("getVar('optionsArray')["..tostring(i).."].defaultValue")))
				end
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_focus');")
			else
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_unfocus');")
			end
		elseif type == 'list' then
			if overlap("getVar('textArray')["..tostring(i).."]") then
				if mouseClicked('left') then
					runHaxeCode([[
						var list = getVar('optionsArray')[ ]]..tostring(i)..[[ ].values;
						var find = ']]..getPropertyFromClass('ClientPrefs', name)..[[';
						for (i in 0...list.length)
							if (StringTools.endsWith(list[i], find))
							{
								getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = i;
								break;
							}

						getVar('optionsArray')[ ]]..tostring(i)..[[ ].value++;
						if (getVar('optionsArray')[ ]]..tostring(i)..[[ ].value > getVar('optionsArray')[ ]]..tostring(i)..[[ ].values.length - 1)
							getVar('optionsArray')[ ]]..tostring(i)..[[ ].value = 0;
						trace(getVar('optionsArray')[ ]]..tostring(i)..[[ ].value);
					]])
					setOption(i, getStaticProperty("getVar('optionsArray')["..tostring(i).."].values[getVar('optionsArray')["..tostring(i).."].value].substring(getVar('optionsArray')["..tostring(i).."].values[getVar('optionsArray')["..tostring(i).."].value].lastIndexOf(' - ') + 3)"))
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, getStaticProperty("getVar('optionsArray')["..tostring(i).."].values[getVar('optionsArray')["..tostring(i).."].defaultValue].substring(getVar('optionsArray')["..tostring(i).."].values[getVar('optionsArray')["..tostring(i).."].defaultValue].lastIndexOf(' - ') + 3)"))
				end
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_focus');")
			else
				runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_unfocus');")
			end
		elseif type == 'title' then
			runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_title');")
		else
			runHaxeCode("getVar('textArray')["..tostring(i).."].color = getVar('color_unfocus');")
		end
	end
end

function setOption(index, value)
	-- notmiddlescroll - xstart: 732, xoffset: 112, xstartop: 92, xoffset: 112
	-- middlescroll - xstart: 412, xoffset: 112, xstartop: 82, xstartop2: 971
	local option = getStaticProperty("getVar('optionsArray')["..tostring(index).."].name")
	setPropertyFromClass('ClientPrefs', option, value)
	runHaxeCode("ClientPrefs.saveSettings();")

	runHaxeCode("getVar('textArray')["..tostring(index).."].text = '"..getOptionText(index).."';")
	print(option, value, getOptionText(index))

	if option == 'downScroll' then
		if value == true then
			setValueStrums('y', screenHeight - 150, false)

			setProperty('healthBar.y', screenHeight * 0.11)
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			setProperty('scoreTxt.y', getProperty('healthBar.y') + 36)
			setProperty('timeBar.y', screenHeight - 31)
			setProperty('botplayTxt.y', getProperty('timeBar.y') - 78)
		else
			setValueStrums('y', 50, false)

			setProperty('healthBar.y', screenHeight * 0.89)
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			setProperty('scoreTxt.y', getProperty('healthBar.y') + 36)
			setProperty('timeBar.y', 31)
			setProperty('botplayTxt.y', getProperty('timeBar.y') + 55)
		end

		setValueStrums('downScroll', value, false);

		runHaxeCode([[
			for (note in game.unspawnNotes)
				if (note.isSustainNote && note.prevNote != null)
					note.flipY = ]]..tostring(value)..[[;
			for (note in game.notes)
				if (note.isSustainNote && note.prevNote != null)
					note.flipY = ]]..tostring(value)..[[;
		]])
	elseif option == 'middleScroll' then
		if value == true then
			runHaxeCode([[
				var i:Int = 0;
				for (note in game.opponentStrums)
				{
					if (ClientPrefs.opponentStrums)
						note.alpha = 0.35;
					else
						note.visible = false;

					if (i < Std.int(game.opponentStrums.length / 2))
						note.x = 82 + (112 * i);
					else
						note.x = 971 + (112 * (i - Std.int(game.opponentStrums.length / 2)));
					i++;
				}
				i = 0;
				for (note in game.playerStrums)
				{
					note.x = 412 + (112 * i);
					i++;
				}
			]])
		else
			runHaxeCode([[
				var i:Int = 0;
				for (note in game.opponentStrums)
				{
					if (ClientPrefs.opponentStrums)
						note.alpha = 1;
					else
						note.visible = true;

					note.x = 92 + (112 * i);
					i++;
				}
				i = 0;
				for (note in game.playerStrums)
				{
					note.x = 732 + (112 * i);
					i++;
				}
			]])
		end
	elseif option == 'opponentStrums' then
		if value == true then
			runHaxeCode([[
				if (ClientPrefs.middleScroll)
					for (note in game.opponentStrums) note.alpha = 0.35;
				else
					for (note in game.opponentStrums) note.alpha = 1;
			]])
		else
			runHaxeCode("for (note in game.opponentStrums) note.alpha = 0;")
		end
	elseif option == 'healthBarAlpha' then
		setProperty('iconP1.alpha', value)
		setProperty('iconP2.alpha', value)
		setProperty('healthBar.alpha', value)
	elseif option == 'hideHud' then
		setProperty('iconP1.visible', not value)
		setProperty('iconP2.visible', not value)
		if value == true then
			setProperty('healthBar.alpha', 0)
		else
			setProperty('healthBar.alpha', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
		end
		setProperty('scoreTxt.visible', not value)
	elseif option == 'timeBarType' then
		if value == 'Time Left' or value == 'Time Elapsed' then
			setProperty('timeBar.visible', true)
			setTextSize('timeTxt', 32)

			runHaxeCode("game.modchartTexts.get('timeTxt').y = game.timeBar.y - 4 - (game.modchartTexts.get('timeTxt').height / 4);")
		elseif value == 'Song Name' then
			setProperty('timeBar.visible', true)
			setTextString('timeTxt', getStaticProperty('PlayState.SONG.song'))
			setTextSize('timeTxt', 24)
			runHaxeCode("game.modchartTexts.get('timeTxt').y = game.timeBar.y - 1 - (game.modchartTexts.get('timeTxt').height / 4);")
		elseif value == 'Disabled' then
			setProperty('timeBar.visible', false)
		end
	elseif option == 'showFPS' then
		setPropertyFromClass('Main', 'fpsVar.visible', value)
	elseif option == 'sickWindow' then
		runHaxeCode("game.ratingsData[0].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'goodWindow' then
		runHaxeCode("game.ratingsData[1].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'badWindow' then
		runHaxeCode("game.ratingsData[2].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'safeFrames' then
		setPropertyFromClass('Conductor', 'safeZoneOffset', (value / 60) * 1000);
	end
end

function setValueStrums(vari, value, isString)
	if isString then
		runHaxeCode([[
			for (note in PlayState.instance.playerStrums) Reflect.setProperty(note, ']]..vari..[[', ']]..value..[[');
			for (note in PlayState.instance.opponentStrums) Reflect.setProperty(note, ']]..vari..[[', ']]..value..[[');
		]])
	else
		runHaxeCode([[
			for (note in PlayState.instance.playerStrums) Reflect.setProperty(note, ']]..vari..[[', ]]..tostring(value)..[[);
			for (note in PlayState.instance.opponentStrums) Reflect.setProperty(note, ']]..vari..[[', ]]..tostring(value)..[[);
		]])
	end
end

function overlap(object_name)
	local d = {
		tonumber(getStaticProperty(object_name..".x")),
		tonumber(getStaticProperty(object_name..".y")),
		tonumber(getStaticProperty(object_name..".width")),
		tonumber(getStaticProperty(object_name..".height"))
	}
	local x = tonumber(getStaticProperty("Std.int(FlxG.mouse.getScreenPosition(game.camOther).x)"))
	local y = tonumber(getStaticProperty("Std.int(FlxG.mouse.getScreenPosition(game.camOther).y)"));
	if x > d[1] and x < (d[1] + d[3]) and y > d[2] and y < (d[2] + d[4]) then
		return true
	else
		return false
	end
end

function intToBool(value, reverse)
	if reverse then
		if value or value == 'true' then
			return 1
		else
			return 0
		end
	else
		if value == 1 or value == '1' then
			return true
		else
			return false
		end
	end
end

function getStaticProperty(variable)
	runHaxeCode([[ game.introSoundsSuffix = '' + ]]..variable..[[; ]])
	local dat = getProperty('introSoundsSuffix');
	runHaxeCode([[ game.introSoundsSuffix = ''; ]])
	return dat;
end
function setStaticProperty(variable, value)
	runHaxeCode(variable..' = '..value..';')
end

function onCustomSubstateDestroy(name)
	if name == "PauseMenu" then
		runHaxeCode([[
			for (op in getVar('objects_pm'))
				op.destroy();
			FlxG.mouse.visible = false;
		]])
	end
end