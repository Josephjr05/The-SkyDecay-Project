function goodNoteHit(i,d,t,s)
    shitHit('gf',d,t,false)
end

function opponentNoteHit(i,d,t,s)
    shitHit('gf',d,t,false)
end
function noteMiss(i,d,t,s)
    shitHit('gf',d,t,true)
end

function shitHit(ch,d,t,m)
      if t == 'DuetNote' then
          playAnim('gf',getProperty('singAnimations')[d+1]..(m and 'miss' or ''),true)
          setProperty('gf.holdTimer', 0)
      end
end



function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'DuetNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', '');
		end
	end
end
