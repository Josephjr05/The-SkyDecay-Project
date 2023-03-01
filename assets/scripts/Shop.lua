-- Thanks for downloading this! If you need help don't be afraid to DM me on Discord!
-- XooleDev#7217
-- You are allowed to use this for your mod as long as you credit me. (And I'd like to see the mod once it finishes.)
local SelectX = 990
local SelectY = -150

local CanSelect

SelectAmount = 1
SelectAmountBack = -1

local MaxProductLimit = 4
local MinProductLimit = 1

local ProductSelected
local ProductPrice

local GotProduct1

local TextNum
function onCreate()
	initSaveData('DataFolder', 'Folder')
	flushSaveData('DataFolder')
	MoneyAmount = getDataFromSave('DataFolder', 'Money') -- Do NOT Remove Money, unless you're changing all the variables.

	if songName == 'Shop' then
		function onStartCountdown() 
			if not allowCountdown then
				return Function_Stop
			end
		
			if allowCountdown then
				return Function_Continue
			end
		end
		playMusic('Shop', 0.8, true)

		makeLuaSprite('ShopControls', 'ui/shopinfo', -40, -230)
		addLuaSprite('ShopControls', true)
		setScrollFactor('ShopControls', 1, 1);

		makeLuaSprite('ShopProducts', 'ui/ShopProducts', 800, -100)
		addLuaSprite('ShopProducts', true)
		setScrollFactor('ShopProducts', 1, 1);
		
		makeLuaSprite('ProductAbout', 'ui/ProductAbout', 910, 720)
		addLuaSprite('ProductAbout', true)
		setScrollFactor('ProductAbout', 1, 1);

		makeLuaText('ProductsDescription', 'Go on...', 0, 610, 750)
		setObjectCamera('ProductsDescription', 'game')
		setTextFont('ProductsDescription', 'NotoSans-Regular')
		setTextSize('ProductsDescription', 46)
		addLuaText('ProductsDescription', true)

		makeLuaText('ProductPriceText', '???', 0, 1600, 750)
		setObjectCamera('ProductPriceText', 'game')
		setTextFont('ProductPriceText', 'NotoSans-Regular')
		setTextSize('ProductPriceText', 46)
		addLuaText('ProductPriceText', true)

		makeLuaText('PlayersMoney', '???', 0, 610, 800)
		setObjectCamera('PlayersMoney', 'game')
		setTextFont('PlayersMoney', 'NotoSans-Regular')
		setTextSize('PlayersMoney', 46)
		addLuaText('PlayersMoney', true)

		ProductSelected = 0

		return Function_Continue;
	end
end

function onUpdate()
	if songName == 'Shop' then
		if keyJustPressed('pause') then
			exitMenu()
		end

		GotProduct1 = getDataFromSave('DataFolder', 'GotProduct1')

		setTextString('ProductPriceText', ProductPrice)
		setTextString('PlayersMoney', MoneyAmount)

		if MoneyAmount == 'Money' then
			MoneyAmount = 0
		end

		if keyboardJustPressed('SPACE') then
			if MoneyAmount >= ProductPrice then
				if ProductSelected == 1 then -- 1
					if GotProduct1 == 1 then
						
					else
						GotProduct1 = 1
						BuyProduct1()
					end
				end
			else
				playSound('YouCant');
			end
		end

		if keyboardJustPressed('RIGHT') or keyboardJustPressed('LEFT') then

			if ProductSelected >= MaxProductLimit and keyboardJustPressed('RIGHT') then
				SelectX = 990
				SelectY = -150
				ProductSelected = 1
			elseif ProductSelected <= MinProductLimit and keyboardJustPressed('LEFT') then
				SelectX = 990
				SelectY = 200
				ProductSelected = 4
			else
				if keyboardJustPressed('RIGHT') then
					ProductSelected = ProductSelected + 1
				end
				if keyboardJustPressed('LEFT') then
					ProductSelected = ProductSelected - 1
				end
			end
			if ProductSelected == 1 then
				ProductPrice = 350
				SelectX = 990
				SelectY = -150
			elseif ProductSelected == 2 then
				ProductPrice = 400
				SelectX = 1250
				SelectY = -150
			elseif ProductSelected == 3 then
				ProductPrice = 300
				SelectX = 1430
				SelectY = -20
			elseif ProductSelected == 4 then
				ProductPrice = 250
				SelectX = 1630
				SelectY = -150
			end
			removeLuaSprite('selectIcon')
			playSound('select');
			makeLuaSprite('selectIcon', 'ui/Select', SelectX, SelectY)
			addLuaSprite('selectIcon', true)
		end
		if ProductSelected == 1 then
			setTextString('ProductsDescription', 'Product 1 description')
		elseif ProductSelected == 2 then
			setTextString('ProductsDescription', 'Product 2 description')
		elseif ProductSelected == 3 then
			setTextString('ProductsDescription', 'Product 3 description')
		elseif ProductSelected == 4 then
			setTextString('ProductsDescription', 'Product 4 description')
		elseif ProductSelected == 5 then
			setTextString('ProductsDescription', 'Product 5 description')
		elseif ProductSelected == 5 then
			setTextString('ProductsDescription', 'Product 6 description')'
		end



		if GotProduct1 == 1 then
						
		else
			setDataFromSave('DataFolder', 'GotProduct1', 0)
			-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
			-- https://gamebanana.com/tuts/15414
			-- Make sure the one here is HIDING in Freeplay, or in Story Mode if doing a week.
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if keyJustPressed('pause') and songName == 'Shop' then
		exitMenu();
	end
end

function exitMenu()
	setDataFromSave('DataFolder', 'Money', MoneyAmount)
	exitSong(true);
end

function onEndSong()
	playSound('chaching');
	MoneyAmount = MoneyAmount + math.random(100, 150)
	setDataFromSave('DataFolder', 'Money', MoneyAmount)
end


function BuyProduct1()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice


	setDataFromSave('DataFolder', 'GotProduct1', 1)
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end