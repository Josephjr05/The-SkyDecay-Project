local months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'}
local timeTab = {}

function onCreatePost()	
    timeTab = os.date('*t')
    --debugPrint(timeTab)
    --Pendejo mamaverga
    yepp = ""
    if timeTab.hour < 12 then yepp = 'A.M.' else yepp = 'P.M.' end
    part1 = months[timeTab.month] .. '. ' .. timeTab.day .. ' ' .. timeTab.year
    part2 = timeTab.hour .. ':'.. timeTab.min .. ' '.. yepp 

    makeLuaText('time', 'Recreation by Adem.OMT', 0, 10, 36);
    setObjectCamera("time", 'hud'); 
    setTextColor('time', '0xffffff')
    setTextSize('time', 18);
    setTextBorder('time', 0, '000000')
    addLuaText("time");
    setTextAlignment('time', 'right');

	setObjectCamera('time', 'other')

  -- set the fps font to VCR
  addHaxeLibrary('Main');
  runHaxeCode([[
    Main.fpsVar.visible = false;
  ]]);
end

function onCreate()
    makeLuaText("fps", " ", -1, 10, 5)
    setTextSize("fps", 18)
    setObjectCamera("fps", 'other'); 
    setTextBorder("fps", 0, "000000")
    addLuaText("fps")
    
    makeLuaText("MemoryCounter", "MEM: 0 MB", -1, 10, 20)
    setTextSize("MemoryCounter", 18)
    setObjectCamera("MemoryCounter", 'other'); 
    setTextBorder("MemoryCounter", 0, "000000")
    addLuaText("MemoryCounter")
end

function onUpdate()
    local curFps = ""..getPropertyFromClass("Main", "fpsVar.currentFPS")
    local memory = round(getPropertyFromClass("openfl.system.System", "totalMemory") / 1000000, 1);
    local memPeak = memory
    local peakLv = 0
  

    timeTab = os.date('*t')
    yepp = ""
    if timeTab.hour < 12 then yepp = 'A.M.' else yepp = 'P.M.' end
    part1 = months[timeTab.month] .. '. ' .. timeTab.day .. ' ' .. timeTab.year
    part2 = timeTab.hour .. ':'.. minCheck() .. ' '.. yepp 

   
 
    setTextString("MemoryCounter", "Memory: " .. memory .. " MB")
    setTextString("fps", curFps .. " FPS")
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
  return x / n
end

function minCheck()
    if string.len(timeTab.min) < 2 then
        if tonumber(timeTab.min) < 10 then 
            return '0'..timeTab.min
        else
            return timeTab.min
        end
    else
        return timeTab.min
    end
end

function mathlerp(from,to,i)
  return from+(to-from)*i
end