function onCreate()
    --variables
	Dodged = false;
    canDodge = false;
    DodgeTime = 0;
	
    precacheImage('slash warning sheet');
end

function onEvent(name, value1, value2)
    if name == "sl4sh dodge" then
    --Get Dodge time
    DodgeTime = (1);
	
    --Make Dodge Sprite
	makeAnimatedLuaSprite('warning', 'slash warning sheet', 250, 100);
    addAnimationByPrefix('warning', 'warning', 'slash warning', 24, true);
	luaSpritePlayAnimation('warning', 'warning');
    setProperty('warning.antialiasing', false)
    scaleObject('warning', 2.5, 2.5)
	setObjectCamera('warning', 'other');
    addLuaSprite('warning', true); 
    playSound('slash/slashwarning', 0.3)
	
	--Set values so you can dodge
	canDodge = true;
	runTimer('Died', DodgeTime);
	
	end
end

function onUpdate()
   if canDodge == true and keyJustPressed('accept') then
   
   Dodged = true;
   
   removeLuaSprite('warning');
   canDodge = false
   
   end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == 'Died' and Dodged == false then
   setProperty('health', 0.6);
   characterPlayAnim('dad', 'attack', true);
   setProperty('dad.skipDance', true);
   setProperty('dad.specialAnim', true);
   triggerEvent('colored flash', '1', 'ff0000')
   playSound('slash/slashhit', 0.3)

   
   elseif tag == 'Died' and Dodged == true then
   characterPlayAnim('dad', 'attack', true);
   setProperty('dad.skipDance', true);
   setProperty('dad.specialAnim', true);
   playSound('slash/slashmiss', 0.3)
   Dodged = false
   end
end