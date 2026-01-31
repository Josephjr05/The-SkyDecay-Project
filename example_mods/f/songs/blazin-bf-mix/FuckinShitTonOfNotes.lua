
function onCreate()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		for _, noteLoader in ipairs({ 'BlazinNoteBF', 'BlazinTauntNoteBF','BlazinDarnellHitNote','BlazinBFStyleNote', 'BlazinBFHitNote','BlazinBFUppercut','BlazinDarnellUppercut'}) do
			if getPropertyFromGroup('unspawnNotes', i, 'noteType') == noteLoader then
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true);
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			end
        end
	end
end


function goodNoteHit(i,d,t,s)
	if t == 'BlazinNoteBF' or t == 'BlazinDarnellHitNote' or t == 'BlazinBFStyleNote' or t == 'BlazinBFUppercut' or t == 'BlazinDarnellUppercut' or t == "BlazinTauntNoteBF" then
    shitHit('boyfriend',d,t,false)
	elseif t == 'BlazinBFHitNote' then
		lolGetFucked('boyfriend',d,t,true)
	end
end

function opponentNoteHit(i,d,t,s)
	if t == 'BlazinNoteBF' or t == 'BlazinDarnellHitNote' or t == 'BlazinBFStyleNote' or t == 'BlazinBFUppercut' or t == 'BlazinDarnellUppercut' or t == "BlazinTauntNoteBF" then
		shitHit('boyfriend',d,t,false)
		elseif t == 'BlazinBFHitNote' then
			lolGetFucked('boyfriend',d,t,true)
		end
end

function noteMiss(i,d,t,s)
	if t == 'BlazinNoteBF' or t == 'BlazinDarnellHitNote' or t == 'BlazinBFStyleNote' or t == 'BlazinBFHitNote' then
    lolGetFucked('boyfriend',d,t,true)
	elseif t == 'BlazinBFUppercut' or t == 'BlazinDarnellUppercut' or t == "BlazinTauntNoteBF" then
	shitHit('boyfriend',d,t,false)
	end
end

function shitHit(ch,d,t,m)
	------------------------------------------------------------------------------------------Regular BlazinNote
	if t == 'BlazinNoteBF' then
		if d == 0 then
			setObjectOrder('boyfriendGroup', 11)
			playAnim('dad','block',true)
			playAnim('boyfriend','punchHigh'..getRandomInt(1,2),true)
			cameraShake('camGame', 0.002, 0.1);
		elseif d == 1 then
			setObjectOrder('boyfriendGroup', 11)
			playAnim('dad','dodge',true)
			playAnim('boyfriend','punchLow'..getRandomInt(1,2),true)
		elseif d == 2 then
			setObjectOrder('boyfriendGroup', 10)
			playAnim('dad','punchLow'..getRandomInt(1,2),true)
			playAnim('boyfriend','dodge',true)
		elseif d == 3 then
			setObjectOrder('boyfriendGroup', 10)
			playAnim('dad','punchHigh'..getRandomInt(1,2),true)
			playAnim('boyfriend','block',true)
			cameraShake('camGame', 0.002, 0.1);
		end
		setProperty('boyfriend.specialAnim',true)
	end
------------------------------------------------------------------------------------------Taunt
	if t == 'BlazinTauntNoteBF' then
		if d == 1 then
			playAnim('dad','cringe',true)
		elseif d == 0 then
			playAnim('dad','pissed',true)
		end
	end
------------------------------------------------------------------------------------------Darnell gets hit
	if t == 'BlazinDarnellHitNote' then
		setObjectOrder('boyfriendGroup', 11)
		if d == 1 or d == 0 then
			playAnim('dad','hitHigh',true)
			playAnim('boyfriend','punchHigh'..getRandomInt(1,2),true)
		elseif d == 2 or d == 3 then
			playAnim('dad','hitLow',true)
			playAnim('boyfriend','punchLow'..getRandomInt(1,2),true)
		end
		setProperty('boyfriend.specialAnim',true)
		cameraShake('camGame', 0.002, 0.1);
	end
------------------------------------------------------------------------------------------Style on the haters
	if t == 'BlazinBFStyleNote' then
		playAnim(ch,getProperty('singAnimations')[d+1]..(m and 'miss-alt' or '-alt'),true)
		setProperty(ch..'.holdTimer',0)
		setObjectOrder('boyfriendGroup', 10)
		if d == 0 then
		  playAnim('dad','punchLow'..getRandomInt(1,2),true)
		elseif d == 1 then
		  playAnim('dad','punchHigh'..getRandomInt(1,2),true)
		elseif d == 2 then
		  playAnim('dad','punchHigh'..getRandomInt(1,2),true)
		elseif d == 3 then
		  playAnim('dad','punchLow'..getRandomInt(1,2),true)
		end
	end
------------------------------------------------------------------------------------------Darnell gets fucked (he's gay)
	if t == 'BlazinBFUppercut' then
		if d == 0 or d == 3 then
			playAnim('dad','hitSpin',true)
			playAnim('boyfriend','punchHigh'..getRandomInt(1,2),true)
			setProperty('dad.specialAnim',true)
		elseif d == 1 then
			playAnim('dad','idle',true)
			playAnim('boyfriend','uppercutPrep',true)
		elseif d == 2 then
			playAnim('dad','uppercutHit',true)
			playAnim('boyfriend','uppercut',true)
		end
		setProperty('boyfriend.specialAnim',true)
		setObjectOrder('boyfriendGroup', 11)
	end
------------------------------------------------------------------------------------------BF gets fucked (he's actually gay)
	if t == 'BlazinDarnellUppercut' then
		if d == 0 or d == 3 then
			playAnim('boyfriend','hitSpin',true)
			playAnim('dad','punchHigh'..getRandomInt(1,2),true)
			cameraShake('camGame', 0.002, 0.1);
		elseif d == 1 then
			playAnim('dad','uppercutPrep',true)
			setProperty('dad.specialAnim',true)
		elseif d == 2 then
			playAnim('boyfriend','uppercutHit',true)
			playAnim('dad','uppercut',true)
			setProperty('dad.specialAnim',true)
			cameraShake('camGame', 0.002, 0.1);
		end
		setProperty('boyfriend.specialAnim',true)
		setObjectOrder('boyfriendGroup', 10)
	end
end


function lolGetFucked(ch,d,t,m)
		setObjectOrder('boyfriendGroup', 10)
		if d == 1 or d == 0 then
			playAnim('boyfriend','hitHigh',true)
			playAnim('dad','punchHigh'..getRandomInt(1,2),true)
		elseif d == 2 or d == 3 then
			playAnim('boyfriend','hitLow',true)
			playAnim('dad','punchLow'..getRandomInt(1,2),true)
		end
		setProperty('boyfriend.specialAnim',true)
		cameraShake('camGame', 0.002, 0.1);
end