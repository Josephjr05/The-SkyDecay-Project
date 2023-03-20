local __Keys = {
	azerty = {
	Z = {y = -1, x = 0},
 	 Q = {y = 0, x = -1},
  	  S = {y = 1, x = 0},
   	   D = {y = 0, x = 1},
	},
	qwerty = {
	W = {y = -1, x = 0},
 	 A = {y = 0, x = -1},
  	  S = {y = 1, x = 0},
   	   D = {y = 0, x = 1},
	}
}

local function getModDir() local dir = debug.getinfo(1,"S").source:match([[^@?(.*[\/])[^\/]-$]]):match("/[^/]*/") if (dir ~= '/scripts/' and dir ~= '/data/') then return dir else return '/' end end
local dataBase = dofile('mods'..getModDir()..'scripts/dataBase.lua')

local function bruh()
	if not dataBase.getData('User_Data', 'Tutorial') then
		return false
	else
		return true
	end
end

-- since User_Data existed everything got messed up R.I.P optimization
if not dataBase.storageExists('User_Data') then
	dataBase.newStorage('User_Data')
	dataBase.saveData('User_Data', 'Tutorial', true)
	dataBase.saveData('User_Data', 'KeyBoard', __Keys.azerty)
	dataBase.saveData('User_Data', 'DarkMode', true)
	dataBase.saveData('User_Data', 'Font', 'albasuper.ttf')
	dataBase.saveData('User_Data', 'Language', 'English')
end

local darkMode = dataBase.getData('User_Data', 'DarkMode') ~= nil and (dataBase.getData('User_Data', 'DarkMode'))
local keyBoard = dataBase.getData('User_Data', 'DarkMode') ~= nil and (dataBase.getData('User_Data', 'KeyBoard')) or __Keys.azerty

local _Vars = {
	Tutorial = bruh(), --kms kms kms kms kms kms kms kms kms kms kms kms kms kms kms kms
	givenAName = false,
	isLoadedFromSave = false,
	preferences = {
		keyboard = keyBoard,
		paths = {
			'assets/images/',
			'assets/shared/images/',
			'mods/images/'
		},
		darkMode = darkMode,
		font = dataBase.getData('User_Data', 'Font') or 'albasuper.ttf',
		language = dataBase.getData('User_Data', 'Language') or 'Language',
	},
	LoopedSounds = {}
}

local _Data = {
	curObjects = dataBase.getData('ToolBox', 'Data', true).curObjects ~= nil and dataBase.getData('ToolBox', 'Data').curObjects or {"dad", "gf", "boyfriend"},
	newObjects = dataBase.getData('ToolBox', 'Data', true).newObjects ~= nil and dataBase.getData('ToolBox', 'Data').newObjects or {},
	Events = dataBase.getData('ToolBox', 'Data', true).Events ~= nil and dataBase.getData('ToolBox', 'Data').Events or {},
	curObj = dataBase.getData('ToolBox', 'Data', true).curObj ~= nil and dataBase.getData('ToolBox', 'Data').curObj or 1,

	defaultSpeed = dataBase.getData('ToolBox', 'Data', true).defaultSpeed ~= nil and dataBase.getData('ToolBox', 'Data').defaultSpeed or 1,
	defaultZoom = dataBase.getData('ToolBox', 'Data', true).defaultZoom ~= nil and dataBase.getData('ToolBox', 'Data').defaultZoom or 1,
	isPixelStage = dataBase.getData('ToolBox', 'Data', true).isPixelStage ~= nil and dataBase.getData('ToolBox', 'Data').isPixelStage or false,

	charData = dataBase.getData('ToolBox', 'Data', true).charData ~= nil and dataBase.getData('ToolBox', 'Data').charData or {
		dad = {x = 100, y = 100, camPos = {x = 0,  y = 0}, extraProperties = {}},
		gf = {x = 400, y = 130, camPos = {x = 0,  y = 0}, extraProperties = {}},
		boyfriend = {x = 770, y = 450, camPos = {x = 0,  y = 0}, extraProperties = {}}
	}
}

if not dataBase.storageExists('ToolBox') then
	dataBase.newStorage('ToolBox')
	dataBase.saveData('ToolBox', 'Data', _Data)
end



function dunpack(t, i)
    i = i or 1
    if t[i] ~= nil then
        if type(t[i]) ~= 'string' then
            return tostring(t[i]).. (i ~= #t and ", ".. dunpack(t, i + 1) or "")
        else
        	if string.find(t[i], '---@:') then
        		return string.gsub(tostring(t[i]), '---@:', '')..(i ~= #t and ", ".. dunpack(t, i + 1) or "")
        	else
            	return '"'..tostring(t[i])..'"'..(i ~= #t and ", ".. dunpack(t, i + 1) or "")
            end
        end
    end
end

function table.contains(tbl, k) for _, __ in pairs(tbl) do if __ == k then return true end end end
function toMultiFunction(t, i)
	i = i or 1
	if t[i] ~= nil then
		local lesoak 
		if t[i].func ~= 'callHaxe' then
	    	lesoak = 'PlayState.instance.callOnLuas("'..t[i].func..'", ['..dunpack(t[i].args)..']);\n'..(i ~= #t and toMultiFunction(t, i+1) or '\n')
	    else
	    	lesoak = t[i].cont..'\n'..(i ~= #t and toMultiFunction(t, i+1) or '\n')
	    end
	    return lesoak
	end
end
local function leUnpack(t, i) i = i or 1 return (t[i] ~= nil and t[i]..(i ~= #t and ', '..leUnpack(t, i+1) or leUnpack(t, i+1)) or "") end
local function tableToFuncToStr(tbl, edible) return 'function('..(tbl.args ~= nil and leUnpack(tbl.args) or '')..')\n    '..(tbl.content ~= nil and tbl.content or '')..'\n'..edible..'end' end
function tableToStr(tbl, edible, optimize, bracket) -- leave the other 2 options empty if you dont know what you're doing
    edible, bracket = edible or '', bracket or false
    optimize = (optimize == nil and true or optimize)
    local collapse, deform, returnThis = {'[', ']'}, '"', '{\n'
    for _, v in pairs(tbl) do
        if type(_) == 'string' then if not string.find(_, ' ') and not bracket then collapse = {'', ''} deform = '' end end
        if type(v) ~= 'table' then
            if type(v) == 'string' then v = string.gsub(('"'..v..'"'), '\n', '\\n') end
            returnThis = returnThis.. (optimize and (edible ..'  ') or '')..collapse[1]..(type(_) == 'number' and _ or deform.._..deform)..collapse[2]..' = '..tostring(v)..',\n'
        else
            local leok = ''
            if (v.args ~= nil) and v.content ~= nil and string.upper(v[1]) == 'FUNCTION' then leok = tableToFuncToStr(v, edible..'  ') else leok = tableToStr(v, optimize and (edible..'  ') or '', optimize, bracket) end
            returnThis = returnThis.. (optimize and (edible ..'  ') or '')..collapse[1]..(type(_) == 'number' and _ or deform.._..deform)..collapse[2]..' = '..leok..',\n'
        end
    end
    return (string.find(returnThis, ',', #returnThis - 2) and returnThis:sub(1, #returnThis - 2) or returnThis)..'\n'..(optimize and (edible) or '')..'}'
end

luaDebugMode = true

local _Funcs = {
	multiSet = function(object, w)
		for _, __ in pairs(w) do
			setProperty(object..'.'.._, __)
		end
	end,
	loopSound = function(tag, sound, fade, duration, from, to) _Vars.LoopedSounds[tag] = {sound = sound, volume = getSoundVolume(tag), fade = fade or false, duration = duration or nil, from = from or nil, to = to or nil} end,
	['tableToStr'] = tableToStr,
	['mouseOverlaps'] = function(spr, cam)
		local mx, my = getMouseX(cam or 'other'), getMouseY(cam or 'other')
	
		local x, y, w, h = getProperty(spr .. '.x'), getProperty(spr .. '.y'),
						   getProperty(spr .. '.width'),
						   getProperty(spr .. '.height')
	
		return mx >= x and mx <= x + w and my >= y and my <= y + h;
	end,
	['Button'] = {
		Make = function(tag, x, y, txt, font, hex, txtsize, func, multX, multY, image, scalex, scaley, camera) -- multX&Y for txt only!!
			image = image or 'stageEditor-Assets/buttons/dark/Wide-Button'
			font = _Vars.preferences.font
			scalex, scaley = scalex or 1, scaley or 1
			addHaxeLibrary('FlxButton', 'flixel.ui')
			runHaxeCode(tag..' = new FlxButton('..tostring(x)..', '..tostring(y)..', "'..txt..'"'..', function(){\n'..toMultiFunction(func)..'\n});\n'..
				(camera ~= nil and tag..'.cameras = ['..camera..'];\n' or '')..
				tag..'.loadGraphic(Paths.image("'..image..'"), false, 0, 0);\n'..
				tag..'.scale.set('..tostring(scalex)..', '..tostring(scaley)..');\n'..
				tag..'.label.size = '..tostring(txtsize)..';\n'..
				tag..'.label.font = '..'Paths.font("'..font..'");\n'..
				tag..'.label.color = 0xFF'..hex..';\n'..
				tag..'.antialiasing = true;\n'..
				tag..'.label.antialiasing = true;\n'..
				tag..'.updateHitbox();\n'..
				'for (point in '..tag..'.labelOffsets)\npoint.set(point.x+'..tag..'.width/2-'..tag..'.label.width/2+('..tostring(multX)..'), '..'point.y +'..tag..'.height/2-'..tag..'.label.height/2+('..tostring(multY)..'));\n\n'..
				'game.add('..tag..');')
		end,

		Update = {
			Label = function(tag, multX, multY)
				runHaxeCode('for (point in '..tag..'.labelOffsets)\npoint.set(point.x+'..tag..'.width/2-'..tag..'.label.width/2+('..tostring(multX)..'), '..'point.y +'..tag..'.height/2-'..tag..'.label.height/2+('..tostring(multY)..'));')
			end
		}
	},
	['TextInput'] = {
		Make = function(tag, x, y, text, width, txtsize, font, hex, image, multX, multY, scalex, scaley, alignment)
			addHaxeLibrary('FlxInputText', 'flixel.addons.ui')
			image = image or 'stageEditor-Assets/buttons/dark/Wide-Button'
			font = _Vars.preferences.font
			alignment = alignment or 'center'
			scalex, scaley = scalex or 1, scaley or 1
			multX = multX or 0 multY = multY or 0

			runHaxeCode(
				tag..'___BG = new FlxSprite('..tostring(x)..', '..tostring(y)..').loadGraphic(Paths.image("'..image..'"));\n'..
				tag..'___BG.scale.set('..tostring(scalex)..', '..tostring(scaley)..');\n'..
				tag..'___BG.scrollFactor.set(0, 0);\n'..
				tag..'___BG.updateHitbox();\ngame.add('..tag..'___BG);\n'..

				tag..' = new FlxInputText(0, 0, '..tostring(width)..', "'..text..'", '..tostring(txtsize)..', 0xFF'..hex..', 0x00000000, false);\n'..
				tag..'.x = '..tag..'___BG.x+'..tag..'___BG.width/2-'..tostring(width/2)..'+('..multX..');\n'..
				tag..'.y = '..tag..'___BG.y+'..tag..'___BG.height/2-'..tag..'.height/2+('..multY..');\n'..
				tag..'.font = Paths.font("'..font..'");\n'..
				tag..'.alignment = "'..alignment..'";\n'..
				tag..'.scrollFactor.set(0, 0);\n'..
				'game.add('..tag..');'
			)
		end,
		updatePos = function(tag, multX, multY)
			multX, multY = multX or 0, multY or 0
			runHaxeCode(
				tag..'.x = '..tag..'___BG.x+'..tag..'___BG.width/2-'..tag..'.width/2+('..multX..');\n'..
				tag..'.y = '..tag..'___BG.y+'..tag..'___BG.height/2-'..tag..'.height/2+('..multY..');\n'
			)
		end
	},
	['Gradient'] = function(tag, x, y, width, height, colors, camera) -- im sobbing
		camera = camera or 'game.camOther'
		addHaxeLibrary('FlxGradient', 'flixel.util')
		addHaxeLibrary('FlxSpriteUtil', 'flixel.util')
		runHaxeCode(
			tag..' = FlxGradient.createGradientFlxSprite('..width..', '..height..', ['..table.concat(colors, ', ')..']);\n'..
			tag..'_tempMask = new FlxSprite('..x..', '..y..').makeGraphic('..width..', '..height..', 0x00000000);\n'..

			tag..'.scrollFactor.set(0, 0);\n'..
			tag..'.setPosition('..x..', '..y..');\n'..
			tag..'.cameras = ['..camera..'];\n'..
			'game.add('..tag..');\n'..

			'FlxSpriteUtil.drawRoundRect('..tag..'_tempMask, 0, 0, '..width..', '..height..', 30, 30, '..colors[1]..');\n'..
			-- 'game.add('..tag..');\n'..
			tag..'_tempMask.scrollFactor.set(0, 0);\n'..
			tag..'_tempMask.cameras = ['..camera..'];\n'..
			'FlxSpriteUtil.alphaMaskFlxSprite('..tag..', '..tag..'_tempMask, '..tag..');\n'
		)
	end,
	-- ['Particle'] = function(tag, x, y, colorRange)
	-- 	addHaxeLibrary('FlxRange', 'flixel.util.helpers')
	-- 	addHaxeLibrary('FlxParticle', 'flixel.effects.particles')
	-- 	runHaxeCode(
	-- 		tag..' = new FlxParticle();\n'..
	-- 		tag..'.makeGraphic(215, 215, '..colorRange[1]..');\n'..
	-- 		tag..'.scrollFactor.set(0, 0);\n'..
	-- 		tag..'.x = '..x..';\n'..
	-- 		tag..'.y = '..y..';\n'..
	-- 		-- tag..'.colorRange = new FlxRange('..colorRange[1]..', '..colorRange[2]..');\n'..
	-- 		'game.add('..tag..');'
	-- 	)
	-- end,
	['Change'] = {
		Object = function(who) 
			_Data.curObj = _Data.curObj + who
			if _Data.curObj > #_Data.curObjects then
				_Data.curObj = 1
			elseif _Data.curObj < 1 then
				_Data.curObj = #_Data.curObjects
			end
		end,
		Speed = function(x)
			_Data.defaultSpeed = _Data.defaultSpeed + x
			if _Data.defaultSpeed < 1 then _Data.defaultSpeed = 1 end
		end,
		Zoom = function(x)
			_Data.defaultZoom = _Data.defaultZoom + (x * _Data.defaultSpeed)
		end
	},
	['Move'] = { 
		['Object'] = function(x, y)
			setProperty(_Data.curObjects[_Data.curObj]..'.x', getProperty(_Data.curObjects[_Data.curObj]..'.x')+(x * _Data.defaultSpeed))
			setProperty(_Data.curObjects[_Data.curObj]..'.y', getProperty(_Data.curObjects[_Data.curObj]..'.y')+(y * _Data.defaultSpeed))
		end,
		['Camera'] = function()
			for _, __ in pairs({LEFT = {x = -2, y = 0}, UP = {y = -2, x = 0}, DOWN = {y = 2, x = 0}, RIGHT = {x = 2, y = 0}}) do
				if keyboardPressed(_) then
					setProperty('camFollow.x', getProperty('camFollow.x') + __.x * _Data.defaultSpeed)
					setProperty('camFollow.y', getProperty('camFollow.y') + __.y * _Data.defaultSpeed)
					return true
				end
			end
		end
	},
	['Make_Quick'] = {
		Sprite = function(tag, spr, x, y, cam, add, isGraphic, isAnimated, w, h, hex)
    		if not isGraphic and not isAnimated then
    		    makeLuaSprite(tag, spr, x, y)
    		    setObjectCamera(tag, cam)
    		elseif isGraphic and not isAnimated then
    		    makeLuaSprite(tag, '', x, y)
    		    makeGraphic(tag, w, h, hex)
    		    setObjectCamera(tag, cam)
    		elseif not isGraphic and isAnimated then
    		    makeAnimatedLuaSprite(tag, spr, x, y)
    		    setObjectCamera(tag, cam)
    		end
		
    		if add then
    		    addLuaSprite(tag, true)
    		end
		end,
		Text = function(tag, text, x, y, font, hex, size, camera, add)
			camera = camera or 'game'
			makeLuaText(tag, text, 0, x, y)
			setObjectCamera(tag, camera)
			setTextSize(tag, size)
			if font ~= nil then setTextFont(tag, font) end
			setTextColor(tag, hex)
			if add then addLuaText(tag, true) end
		end
	},
	Save = {
		Lua = function(fileName)
			local functionContent = {}
			for _, __ in pairs(_Data.Events) do functionContent[_] = {func = { [1] = "FUNCTION", content = __.content, args = ""}, stringified = {[1] = "FUNCTIO", content = __.content, args = ""} } end
			local luaSave = 'local newObjects = '..tableToStr(_Data.newObjects, '', true, true)..'\n'..'local Events = '..tableToStr(functionContent, '', true, true)..'\nlocal charData ='..tableToStr(_Data.charData, '', true, true)..'\n\n'..
			[[
local stageName
function onCreatePost()
  stageName = scriptName:match("[^/]*.lua$"):sub(1, -5)
  for _, __ in pairs(charData) do
	setObjectOrder(_, __.order)
	for pr, op in pairs(__.extraProperties) do
	  	setProperty(_..'.'..pr, op)
	end
	if __.order ~= nil then -- check so the characters animations doesnt go twice as fast
		setObjectOrder(_, __.order)
	end
	setBlendMode(_, __.blendmode)
	callOnLuas('stageLoadedCharacters', {stageName, _}, false, false)
  end
  for _, __ in pairs(newObjects) do
      if not __.isText then
        if __.isAnimated then
          makeAnimatedLuaSprite(_, __.path, __.x, __.y)
        else
          makeLuaSprite(_, __.path, __.x, __.y)
          if __.isGraphic then makeGraphic(_, __.width, __.height, __.hex) end
        end
        addLuaSprite(_)
      else
        makeLuaText(_, __.text, 0, __.x, __.y)
        setTextColor(_, __.hex)
        setTextSize(_, __.size)
        setTextFont(_, __.font)
        addLuaText(_)
      end
      setObjectCamera(_, __.camera)
	  if __.order ~= nil then setObjectOrder(_, __.order) end
	  for pr, op in pairs(__.extraProperties) do
		setProperty(_..'.'..pr, op)
	  end
	  setBlendMode(_, __.blendmode)
  end
  callOnLuas('stageCreated', {tostring(stageName)}, false, false)
end

local __nnt = {dad = {}, gf = {}, boyfriend = {}}
function onUpdatePost(elapsed)
	for _, __ in pairs(Events) do
		__.func()
		callOnLuas('stageOnEvent', {tostring(stageName), _}, false, false)
	end
	for _, __ in pairs(charData) do
		if __.order ~= nil then
		  if __nnt[_][getProperty(_..'.animation.curAnim.name')] == nil then
			  __nnt[_][getProperty(_..'.animation.curAnim.name')] = getProperty(_..'.animation.curAnim.frameRate')/2
      else
        if getProperty(_..'.animation.curAnim.frameRate') ~= __nnt[_][getProperty(_..'.animation.curAnim.name')] then
          setProperty(_..'.animation.curAnim.frameRate', __nnt[_][getProperty(_..'.animation.curAnim.name')])
        end
		  end
		end
	end
end

function stageDiscardEvents(stage)
	if stage == stageName then
	  Events = {}
	end
end

local stringifiedEvents = {}
for _, __ in pairs(Events) do
	stringifiedEvents[_] = __.stringified
end

return {newObjects = newObjects, charData = charData, Events = stringifiedEvents}
-- Stage Made With Cherry's LUA Stage Editor (Spacin' Vanilla Update)
			]]
			saveFile('stages/'..fileName..'.lua', luaSave)
		end,
		Json = function(fileName)
			local jsonSave = '{\n"directory": "",\n"defaultZoom": '..tostring(_Data.defaultZoom)..',\n"isPixelStage": '..tostring(_Data.isPixelStage)..',\n\n'..
				'"boyfriend": ['.._Data.charData.boyfriend.x..', '..(_Data.charData.boyfriend.y)-(_Vars.isLoadedFromSave and 0 or 350)..'],\n'..
				'"girlfriend": ['.._Data.charData.gf.x..', '.._Data.charData.gf.y..'],\n'..
				'"opponent": ['.._Data.charData.dad.x..', '.._Data.charData.dad.y..'],\n\n\n'..
				'"camera_boyfriend": ['..(_Data.charData.boyfriend.camPos.x)-(getMidpointX('boyfriend')-100)..', '..(_Data.charData.boyfriend.camPos.y)-(getMidpointY('boyfriend')-100)..'],\n'..
				'"camera_girlfriend": ['.._Data.charData.gf.camPos.x..', '.._Data.charData.gf.camPos.y..'],\n'..
				'"camera_opponent": ['..(_Data.charData.dad.camPos.x)-(getMidpointX('dad')+150)..', '..(_Data.charData.dad.camPos.y)-(getMidpointY('dad')-100)..']\n}'
			saveFile('stages/'..fileName..'.json', jsonSave)
		end
	},
	LoadData = function(stage)
		local StageData = dofile('mods/stages/'..stage..'.lua')
		_Data.newObjects = StageData.newObjects
		_Data.charData = StageData.charData
		for _, __ in pairs(StageData.newObjects) do
			if not table.contains(_Data.curObjects, _) then
				table.insert(_Data.curObjects, _)
			end
		end
		for _, __ in pairs(StageData.Events) do
			table.insert(_Data.Events, __.stringified)
		end
		StageData = nil
		dataBase.saveData('ToolBox', 'Data', _Data)
	end,
	LoadData2 = function(stage)
		local stageLOAD = getTextFromFile('scripts/Stage-Editor/stageLOAD.lua')
		local stageContent = getTextFromFile('stages/'..stage..'.lua')
		saveFile('stages/'..stage..'-TEMPO__.lua', 
			stageLOAD..'\n\n'..
			stageContent..
			'\n\nreturn returnData'
		)
		local stageData = dofile('mods/stages/'..stage..'-TEMPO__.lua')(stage)
		if stageData.onCreate ~= nil then
			stageData.onCreate()
		end
		if stageData.onCreatePost ~= nil then
			stageData.onCreatePost()
		end
		if stageData.onStartCountdown ~= nil then
			stageData.onStartCountdown()
		end

		_Data.newObjects = stageData.newObjects
		_Data.charData = stageData.charData
		_Data.defaultZoom = stageData.defaultZoom
		_Data.isPixelStage = stageData.isPixelStage

		for _, __ in pairs(stageData.newObjects) do
			if not table.contains(_Data.curObjects, _) then
				table.insert(_Data.curObjects, _)
			end
		end

		dataBase.saveData('ToolBox', 'Data', _Data)
		deleteFile('stages/'..stage..'-TEMPO__.lua')
	end
}

function _Funcs.Move.Camera2(curSelected)
	_Funcs.multiSet('camFollow', {x = _Data.charData[curSelected].camPos.x, y = _Data.charData[curSelected].camPos.y})
	if _Funcs.Move.Camera() then
		_Data.charData[curSelected].camPos.x = getProperty('camFollow.x')
		_Data.charData[curSelected].camPos.y = getProperty('camFollow.y')
	end
end

function _Funcs.MakeSprite(tag, path, camera, animated, graphic, width, height, hex)
	if tag == 'Sprite Tag' or tag == 'Graphic Tag' or tag:match("^%s*$") then
		tag = 'sprite'..#_Data.curObjects+1
	end
	if _Data['curObjects'][tag] == nil then table.insert(_Data.curObjects, tag) end
	_Data.newObjects[tag] = {
		path = path,
		camera = camera,

		isAnimated = animated,
		isGraphic = graphic,
		isText = false,

		width = width or nil,
		height = height or nil,
		hex = hex or nil,

		extraProperties = {},
		animations = (animated and {} or nil),

		x = 0,
		y = 0
	}
	dataBase.saveData('ToolBox', 'Data', _Data)
	playSound('confirmMenu', 0.6)
	customDebugPrint(tag..' Has Been Created! Go Back To Main Menu to Reposition it', _Vars.preferences.darkMode and '352040' or 'ffffff', 28, _Vars.preferences.font, _Vars.preferences.darkMode and 'c7f9f0' or 'ff7c6a', 2)
end

function _Funcs.MakeText(tag, text, font, hex, size, camera)
	if tag == 'Text Tag' or tag:match("^%s*$") then
		tag = 'text'..#_Data.curObjects+1
	end
	if font == 'Font' or font:match("^%s*$") then font = nil end
	if size == 'Size' or size:match("^%s*$") or tonumber(size) == nil then size = 8 end
	camera = camera or 'game'
	
	if _Data['curObjects'][tag] == nil then table.insert(_Data.curObjects, tag) end

	_Data.newObjects[tag] = {
		text = text,
		camera = camera,

		isAnimated = false,
		isGraphic = false,
		isText = true,

		hex = hex,
		size = tonumber(size),
		font = font,

		extraProperties = {},
		
		x = 0,
		y = 0
	}
	dataBase.saveData('ToolBox', 'Data', _Data)
	playSound('confirmMenu', 0.6)
	customDebugPrint(tag..' Has Been Created! Go Back To Main Menu to Reposition it', _Vars.preferences.darkMode and '352040' or 'ffffff', 28, _Vars.preferences.font, _Vars.preferences.darkMode and 'c7f9f0' or 'ff7c6a', 2)
end

function _Funcs.makeEvent(variable, amount, functionCode)
	local eventTableToFunction = {
		'FUNCTIO',
		args = '',
		content = 'if '..variable..' == ('..amount..') then\n        '..functionCode..'\n    end'
	}
	table.insert(_Data.Events, eventTableToFunction)
	dataBase.saveData('ToolBox', 'Data', _Data)
end

function _Funcs.MakeAnimation(object, animationTag, animPrefix, framerate, looped)
	if tonumber(framerate) == nil or framerate:match("^%s*$") then framerate = 24 end
	if _Data.newObjects[object] ~= nil then
		if animationTag:match("^%s*$") or animationTag == 'Animation' then
			animationTag = 'animation'..#_Data.newObjects[object].animations+1
		end
		if _Data.newObjects[object].isAnimated then
			_Data.newObjects[object].animations[animationTag] = {
				Prefix = animPrefix,
				Looped = looped,
				FPS = tonumber(framerate)
			}
			dataBase.saveData('ToolBox', 'Data', _Data)
			playSound('confirmMenu', 0.6)
			customDebugPrint('Animation '..animationTag..' Has Been Added', _Vars.preferences.darkMode and '352040' or 'ffffff', 28, _Vars.preferences.font, _Vars.preferences.darkMode and 'c7f9f0' or 'ff7c6a', 2)
		else
			playSound('cancelMenu', 0.6)
			customDebugPrint(object..'Is Not Animated', 'ff0000', 28, _Vars.preferences.font, _Vars.preferences.darkMode and 'c7f9f0' or 'ff7c6a', 2)
		end
	else
		playSound('cancelMenu', 0.6)
		customDebugPrint(object..' Does not Exist', 'ff0000', 28, _Vars.preferences.font, _Vars.preferences.darkMode and '352040' or 'ffffff', 2)
	end
end

function callTableFunc(a, b, c, d, ...)
    if b ~= 'nil' then
        if c ~= 'nil' then
            if d ~= 'nil' then
                _Funcs[a][b][c][d](...)
            else
                _Funcs[a][b][c](...)
            end
        else
            _Funcs[a][b](...)
        end
    else
        _Funcs[a](...)
    end
end

-- function callHaxe(args, content)
-- 	local ok = 'function('..(args ~= '' and leUnpack(args) or '')..'){\n'..content..'}'
-- 	return ok
-- end

function editVars(a, b, c, d, e)
	if (b ~= nil and b ~= 'nil') then
		if (c ~= nil and c ~= 'nil') then
			if (d ~= nil and d ~= 'nil') then
				_Vars[a][b][c][d] = e
			else
				_Vars[a][b][c] = e
			end
		else
			_Vars[a][b] = e
		end
	else
		_Vars[a] = e
	end
end

function editData(a, b, c, d, e)
	if b ~= nil then
		if c ~= nil then
			if d ~= nil then
				_Data[a][b][c][d] = e
			else
				_Data[a][b][c] = e
			end
		else
			_Data[a][b] = e
		end
	else
		_Data[a] = e
	end
end

function _Funcs.leJuice(...)
    debugPrint(...)
end

local function tablefind(tab,el)
	for index, value in pairs(tab) do
	    if value == el then
	    return index
      end
   end
end

local tweeners = {}

function doTween(typis, tagg, var, val, dur, ease, typ, func, count)
    count = count or 0
    typ = typ or "persist"
    func = func or function()
            return "ok"
        end
    if string.lower(typ) == "backwards" then
        _G["doTween" .. typis](tagg, var, getProperty(var .. "." .. string.lower(typis)), dur, ease)
        setProperty(var .. "." .. string.lower(typis), val)
    else
        _G["doTween" .. typis](tagg, var, val, dur, ease)
    end
    
    tweeners[tagg .. "Data"] = {
        twnType = typis,
        tag = tagg,
        variable = var,
        value = val,
        duration = dur,
        ease = ease,
        FlxType = typ,
        pastVal = getProperty(var .. "." .. string.lower(typis)),
        onComplete = func,
        Repeat = count,
        Repeated_Times = 0
    }
end


function onTweenCompleted(tag)
    local pe, su =
        pcall(
        function()
            for _, q in pairs(tweeners) do
                if tag == q.tag then
                    if string.lower(q.FlxType) == "oneshot" then
                        table.remove(tweeners, tablefind(tweeners, tag .. "Data"))
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "pingpong" then
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "looping" then
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "persist" or string.lower(q.FlxType) == "backwards" then
                        q.onComplete()
                        q.finished = true
                    end
                end
                --pingpong
                if q.Repeat == 0 then
                    if tag == q.tag .. "BACK" then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "FORTH", q.variable, q.value, q.duration, q.ease)
                    end
                    if tag == q.tag .. "FORTH" then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                    end
                else
                    if tag == q.tag .. "BACK" and q.Repeated_Times ~= q.Repeat then
                        q.Repeated_Times = q.Repeated_Times + 1
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "FORTH", q.variable, q.value, q.duration, q.ease)
                    end
                    if tag == q.tag .. "FORTH" and q.Repeated_Times ~= q.Repeat then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                    end
                end

                if q.Repeat == 0 then
                    if tag == q.tag .. "LOOP" then
                        q.onComplete()
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                    end
                else
                    if tag == q.tag .. "LOOP" and q.Repeated_Times ~= q.Repeat then
                        q.Repeated_Times = q.Repeated_Times + 1
                        q.onComplete()
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                    end
                end
            end
        end
    )
    if not pe then
        debugPrint(su)
    end
end

local _debugTxt = {}
function customDebugPrint(text, color, size, font, borderc, borders)
    local function makeLeTxt()
        local ok = '_debugPrint_'..getRandomInt(1, 4300)..'_'
        makeLuaText(ok, text, 0, 0, 20)
        setObjectCamera(ok, 'other')
        addLuaText(ok, true)
        setTextSize(ok, size or 25)
        setTextColor(ok, color or 'ffffff')
        borders = borders or 2
        borderc = borderc or '000000'
        setTextBorder(ok, borders, borderc)
        if font ~= nil then setTextFont(ok, font) end
        setProperty(ok..'.x', 0)
        setProperty(ok..'.y', 0)
        table.insert(_debugTxt, ok)
        doTween('Alpha', ok, ok, 0, 10, 'smoothStepInOut', 'oneshot', function() removeLuaText(ok) table.remove(_debugTxt, tablefind(_debugTxt, ok)) end)
    end
    if #_debugTxt == 0 then
        makeLeTxt()
    else
        makeLeTxt()
        for i = 1, #_debugTxt-1 do
            setProperty(_debugTxt[i]..'.y', getProperty(_debugTxt[i]..'.y')+getProperty(_debugTxt[#_debugTxt]..'.height')+getProperty(_debugTxt[#_debugTxt]..'.y')-15)
        end
    end
end

_Funcs.customDebugPrint = customDebugPrint

function onSoundFinished(tag)
	luaDebugMode = true
	for _, __ in pairs(_Vars.LoopedSounds) do
		if _Vars.LoopedSounds[tag] ~= nil then
			playSound(__.sound, __.volume, _)
			if __.fade then
				soundFadeIn(_, 1, 0, 0.6)
			end
		end
	end
end

return {
	['Keys'] = __Keys,
	['dunpack'] = dunpack,
	['Variables'] = _Vars,
	['Data'] = _Data,
	['setVar'] = function(a, b, c, d, e) editVars(a, b, c, d, e) end,
	['setData'] = function(a, b, c, d, e) editData(a, b, c, d, e) end,
	['Functions'] = _Funcs,
	['callTableFunc'] = function(a, b, c, d, ...) callTableFunc(a, b, c, d, ...) end,
	['doTween'] = doTween,
	['toggleCamera'] = function() return 0 end
} -- 😊
