function goodNoteHit(i,d,t,s)
    shitHit('boyfriend',d,t,false)
end

function opponentNoteHit(i,d,t,s)
    shitHit('dad',d,t,false)
end
function noteMiss(i,d,t,s)
    shitHit('boyfriend',d,t,true)
end

function shitHit(ch,d,t,m)
      if t == 'GfSectionAlt' then
          playAnim(ch,getProperty('singAnimations')[d+1]..(m and 'miss-alt' or '-alt'),true)
          setProperty(ch..'.holdTimer',0)
      end
end


function onCreate()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GfSectionAlt' then
            setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'texture', '');
		end
	end
end