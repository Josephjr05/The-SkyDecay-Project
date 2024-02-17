startSwing = false;
startRotating = false;
swingVal = 0;
reset = false;
notes = nil;

-- Wacky modchart I did (-Bolo)
-- BTW IF YOUR RAM IS RAISING WHILE PLAYING IS BECAUSE OF THIS FUCKING BORKEN LUA 

function start(song)
    setProperty('PlayStateChangeables','middleScroll',true);

end

function postStart(song)

end

function update(elapsed)
    currentBeat = (songPos / 1000)*(bpm*rate/60);

    notes = getNotes()

    for i = 0,3 do 
        local PlayerReceptor = _G['Player_receptor_'..i];

        if startSwing then 
            if swingVal < 6 then
                swingVal = swingVal + 0.025
            end
            PlayerReceptor.laneFollowsReceptor = 0;
            PlayerReceptor.x = (PlayerReceptor.defaultX + swingVal * math.sin(((currentBeat/4) + i*0.25) * math.pi))+swingVal*math.sin(currentBeat)
            
       
        end

        if startRotating then 
            PlayerReceptor.angle = PlayerReceptor.angle + elapsed*6*rate;
        end

        for k,v in ipairs(notes) do
            local note = _G[v];
            

            if not note.isSustain and note.data == i then 
                note.angle = PlayerReceptor.angle;
            end
        end

    end

    
  


end

local function strumSplit()

    for i = 0,1 do 
        local rec = _G['Player_receptor_'..i];
        rec.laneFollowsReceptor = 1;
        rec:tweenPos(rec.defaultX-150,rec.y,3/rate,'expoout');
        rec:tweenAngle(rec.angle-360,3/rate,'expoout');
    end

    for k = 2,3 do 
        local TwiceReceptors = _G['Player_receptor_'..k];
        TwiceReceptors.laneFollowsReceptor = 1;
        TwiceReceptors:tweenPos(TwiceReceptors.defaultX+150,TwiceReceptors.y,3/rate,'expoout');
        TwiceReceptors:tweenAngle(TwiceReceptors.angle+360,3/rate,'expoout');
   end
end 

local function spin()
    camGame.zoom = camGame.zoom + 0.03;
    camHUD.zoom = camHUD.zoom + 0.06;
    for i = 0,3 do 
        local CoolReceptor = _G['Player_receptor_'..i];
        CoolReceptor:tweenAngle(CoolReceptor.angle+360,0.35/rate,'smoothstepout');
    end



end

local function resetStrumPos()
    if not reset then
        for i = 0,3 do 
            local CoolReceptor = _G['Player_receptor_'..i];
            CoolReceptor:tweenPos(CoolReceptor.defaultX,CoolReceptor.y,0.25/rate,'smoothstepout');
            CoolReceptor:tweenAngle(CoolReceptor.defaultAngle,0.5/rate,'smoothstepout');
        end



        reset = true
    end
end 

function beatHit(beat)


    if beat == 296 then
        startSwing = true;
        startRotating = true;
    end
    
    if beat == 360 then
        startSwing = false;
        startRotating = false;
        resetStrumPos();
    end

    if beat == 328 then 
        startRotating = false;
        spin()
    end

    if beat == 330 then 
        spin()
    end

    if beat == 332 then 
        startRotating = true;
    end

    if beat == 480 then
        strumSplit()
    end
end