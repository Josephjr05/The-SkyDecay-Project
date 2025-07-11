minN = 0;
maxN = 500;
RNGG = 1555;
RNGGG = 1555;
DEATHRNG = 30;
ONCE = 0;
function onCreate()

    makeLuaSprite('sky', 'stages/battlefield/sky', -250 , -250);
    addLuaSprite('sky', false);
    setScrollFactor('sky',0.1,0.1);
    makeLuaSprite('sky1', 'stages/battlefield/effect1', -250 , -150);
    addLuaSprite('sky1', true);
    setScrollFactor('sky1',0.1,0.1);
    makeLuaSprite('mount', 'stages/battlefield/mounta',-50, 120);
    addLuaSprite('mount', false);
    setScrollFactor('mount',0.3,0.3);
    makeLuaSprite('buldings', 'stages/battlefield/buldings',-500, -350);
    addLuaSprite('buldings', false);
    setScrollFactor('buldings',0.45,0.45);

    makeLuaSprite('steve', 'stages/battlefield/steve',-400, 368);
    addLuaSprite('steve', false);
    setScrollFactor('steve',0.52,0.52);

    makeLuaSprite('landscape', 'stages/battlefield/landscape',-700, -350);
    addLuaSprite('landscape', false);
    setScrollFactor('landscape',0.6,0.6);




    makeAnimatedLuaSprite('smoke','stages/battlefield/smoke',290,40);
    addAnimationByPrefix('smoke','SMOKE V2','SMOKE V2',24,true);
    addLuaSprite('smoke');
    setScrollFactor('smoke',1,1);
    objectPlayAnimation('smoke','SMOKE V2',true);



    makeLuaSprite('mainstage', 'stages/battlefield/mainstage',-700,0);
    addLuaSprite('mainstage', false);
    setScrollFactor('mainstage',1 ,1 );

    makeAnimatedLuaSprite('john' .. RNGG,'stages/battlefield/john',-1000,700 + math.random(-15 ,20 ));
    addAnimationByPrefix('john' .. RNGG,'TANKMANRUNNIN','TANKMANRUNNIN',24,true);
    addLuaSprite('john' .. RNGG);
    setScrollFactor('john' .. RNGG,1.5,1.5);
    objectPlayAnimation('john' .. RNGG,'TANKMANRUNNIN',true);
    doTweenX('john' .. RNGG, 'john' .. RNGG, 2000, 0.0001, 'linear')
    setObjectOrder('john' .. RNGG, 15);

    RNGGG = RNGGG + 1;
    makeAnimatedLuaSprite('runjohn' .. RNGGG,'runjohn',-1000,200);
    addLuaSprite('runjohn', false);
    setObjectOrder('runjohn', 1)   
    addAnimationByPrefix('runjohn' .. RNGGG,'JOHNRUN','JOHNRUN',24,true);
    addAnimationByPrefix('runjohn' .. RNGGG,'JOHNDIE','JOHNDIE',24,false);
    addLuaSprite('runjohn' .. RNGGG);
    setScrollFactor('runjohn' .. RNGGG,1 ,1 );
    objectPlayAnimation('runjohn' .. RNGGG,'JOHNRUN',true);
    doTweenX('runjohn' .. RNGGG, 'runjohn' .. RNGGG, 2000, 0.0001, 'linear')
    setObjectOrder('runjohn' .. RNGGG, 5);



RNGG = 0;
RNGGG = 0;

end

function onUpdate(elapsed)
if curStep == 0 then
doTweenX('bfScaleTweenX', 'mount.scale', 1.2, 0.00001, 'elasticInOut')
doTweenX('bfScaleTweenX', 'landscape.scale', 0.8, 0.00001, 'elasticInOut')
doTweenY('bfScaleTweenY', 'landscape.scale', 0.8, 0.00001, 'elasticInOut')
ONCE = ONCE + 1;
    if ONCE == 1 then
    	RNGG = RNGG + 1;
    	makeAnimatedLuaSprite('john' .. RNGG,'john',10000,780 + math.random(-15 ,20 ));
    	addAnimationByPrefix('john' .. RNGG,'TANKMANRUNNIN','TANKMANRUNNIN',24,true);
    	addLuaSprite('john' .. RNGG);
    	setScrollFactor('john' .. RNGG,1.5,1.5);
    	objectPlayAnimation('john' .. RNGG,'TANKMANRUNNIN',true);

    end
    if ONCE == 1 then
    	RNGGG = RNGGG + 1;
    	makeAnimatedLuaSprite('runjohn' .. RNGGG,'runjohn',10000,200 + math.random(-10 ,10 ));
    	addAnimationByPrefix('runjohn' .. RNGGG,'JOHNRUN','JOHNRUN',24,true);
    	addAnimationByPrefix('runjohn' .. RNGGG,'JOHNDIE','JOHNDIE',24,false);
    	addLuaSprite('runjohn' .. RNGGG);
    	setScrollFactor('runjohn' .. RNGGG,1 ,1 );
    	objectPlayAnimation('runjohn' .. RNGGG,'JOHNRUN',true);

    end
    if ONCE == 1 then
    	makeAnimatedLuaSprite('lasershoot','lasershoot',-1000,10000);
    	addAnimationByPrefix('lasershoot','laser shoot','laser shoot',24,false);
    	setProperty('lasershoot.angle', math.random(-10 ,10));
    	addLuaSprite('lasershoot');
    	setScrollFactor('lasershoot',1.3 ,1.3 );
    	objectPlayAnimation('lasershoot','laser shoot',false);
    	setObjectOrder('lasershoot', 30);
    end
    if ONCE == 1 then
        makeAnimatedLuaSprite('bullethole0','bullethole',10000,200);
        addAnimationByPrefix('bullethole0','gunshot','gunshot',24,false);
        addLuaSprite('bullethole0');
        setScrollFactor('bullethole0',1 ,1 );
        objectPlayAnimation('bullethole0','gunshot',false);
    end

end

if math.random(minN ,maxN ) == 0 then
    if getProperty('health') > 0 then
    	RNGG = RNGG + 1;
    	makeAnimatedLuaSprite('john' .. RNGG,'john',-1000,780 + math.random(-15 ,20 ));
    	addAnimationByPrefix('john' .. RNGG,'TANKMANRUNNIN','TANKMANRUNNIN',24,true);
    	addLuaSprite('john' .. RNGG);
    	setScrollFactor('john' .. RNGG,1.5,1.5);
    	objectPlayAnimation('john' .. RNGG,'TANKMANRUNNIN',true);
    	doTweenX('john' .. RNGG, 'john' .. RNGG, 2000, math.random(200 ,400 ) / 100.0, 'linear')
    	setObjectOrder('john' .. RNGG, 30);
    end
end

if math.random(minN ,maxN * 0.8 ) == 10 then
    if getProperty('health') > 0 then
    	RNGGG = RNGGG + 1;

    	addAnimationByPrefix('runjohn' .. RNGGG,'JOHNRUN','JOHNRUN',24,true);
    	addAnimationByPrefix('runjohn' .. RNGGG,'JOHNDIE','JOHNDIE',24,false);
    	addLuaSprite('runjohn' .. RNGGG);
    	setScrollFactor('runjohn' .. RNGGG,1 ,1 );
    	objectPlayAnimation('runjohn' .. RNGGG,'JOHNRUN',true);
    	doTweenX('runjohn' .. RNGGG, 'runjohn' .. RNGGG, 2000, math.random(250 ,650 ) / 100.0, 'linear')
    	setObjectOrder('runjohn' .. RNGGG, 5);
    end
end

if math.random(minN ,maxN * 0.5 ) == 10 then
    if getProperty('health') > 0 then
    	makeAnimatedLuaSprite('lasershoot','lasershoot',-1000,200+math.random(0 ,1000));
    	addAnimationByPrefix('lasershoot','laser shoot','laser shoot',24,false);
    	setProperty('lasershoot.angle', math.random(-10 ,10));
    	addLuaSprite('lasershoot');
    	setScrollFactor('lasershoot',1.3 ,1.3 );
    	objectPlayAnimation('lasershoot','laser shoot',false);
    	setObjectOrder('lasershoot', 30);
    end
end



if curStep == 320 then
    makeAnimatedLuaSprite('bullethole1','bullethole',0,200);
    addAnimationByPrefix('bullethole1','gunshot','gunshot',24,false);
    addLuaSprite('bullethole1');
    setScrollFactor('bullethole1',1 ,1 );
    objectPlayAnimation('bullethole1','gunshot',false);

end
if curStep == 383 then
    makeAnimatedLuaSprite('bullethole2','bullethole',-150,160);
    addAnimationByPrefix('bullethole2','gunshot','gunshot',24,false);
    addLuaSprite('bullethole2');
    setScrollFactor('bullethole2',1 ,1 );
    objectPlayAnimation('bullethole2','gunshot',false);

end
if curStep == 703 then
    makeAnimatedLuaSprite('bullethole3','bullethole',-300,150);
    addAnimationByPrefix('bullethole3','gunshot','gunshot',24,false);
    addLuaSprite('bullethole3');
    setScrollFactor('bullethole3',1 ,1 );
    objectPlayAnimation('bullethole3','gunshot',false);

end
if curStep == 767 then
    makeAnimatedLuaSprite('bullethole4','bullethole',-200,300);
    addAnimationByPrefix('bullethole4','gunshot','gunshot',24,false);
    addLuaSprite('bullethole4');
    setScrollFactor('bullethole4',1 ,1 );
    objectPlayAnimation('bullethole4','gunshot',false);

end

if curStep == 1 then
    doTweenX('steve', 'steve',2000, 25, 'linear')
    doTweenY('stevee', 'steve',370, 0.3, 'linear')
end


if curStep == 320 then
minN = 0;
maxN = 180;
DEATHRNG = 2;
end

if curStep == 447 then
minN = 0;
maxN = 500;
DEATHRNG = 7;
end

if curStep == 703 then
minN = 0;
maxN = 180;
DEATHRNG = 2;
end

if curStep == 831 then
minN = 0;
maxN = 500;
DEATHRNG = 7;
end

end

function onTweenCompleted(tag)
if tag == ('john1') then
RNGG = RNGG - 1;
end
if tag == ('john2') then
RNGG = RNGG - 1;
end
if tag == ('john3') then
RNGG = RNGG - 1;
end
if tag == ('john4') then
RNGG = RNGG - 1;
end
if tag == ('john5') then
RNGG = RNGG - 1;
end
if tag == ('runjohn1') then
RNGG = RNGG - 1;
end
if tag == ('runjohn2') then
RNGG = RNGG - 1;
end
if tag == ('runjohn3') then
RNGG = RNGG - 1;
end
if tag == ('runjohn4') then
RNGG = RNGG - 1;
end
if tag == ('runjohn5') then
RNGG = RNGG - 1;
end
if tag == ('steve') then
doTweenX('steve2', 'steve',-400, 0.0001, 'linear')


end
if tag == ('steve2') then

doTweenX('steve', 'steve',2000, 25, 'linear')

end
if tag == ('stevee') then


doTweenY('steveee', 'steve',368, 0.02, 'linear')

end
if tag == ('steveee') then


doTweenY('stevee', 'steve',369, 0.02, 'linear')

end
end

function onBeatHit()
if math.random(0 ,DEATHRNG ) == 1 then
    if curStep > 1 then
    	objectPlayAnimation('runjohn' .. RNGGG,'JOHNDIE',false);
    	cancelTween('runjohn' .. RNGGG);
    	RNGGG = RNGGG - 1;
    end
end
end