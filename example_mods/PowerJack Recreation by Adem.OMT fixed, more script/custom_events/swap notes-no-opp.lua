local flipit = false
function onEvent(name, value1, value2)
	if name == 'swap notes-no-opp' then
		if value1 == 'true' then
			setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX0)
			setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX1)
			setPropertyFromGroup('playerStrums', 2, 'x', defaultOpponentStrumX2)
			setPropertyFromGroup('playerStrums', 3, 'x', defaultOpponentStrumX3 )
			setPropertyFromGroup('playerStrums', 4, 'x', defaultOpponentStrumX4 )
		
			setPropertyFromGroup('opponentStrums', 0, 'x', defaultPlayerStrumX0 + 4000)
			setPropertyFromGroup('opponentStrums', 1, 'x', defaultPlayerStrumX1 + 4000)
			setPropertyFromGroup('opponentStrums', 2, 'x', defaultPlayerStrumX2 + 4000)
			setPropertyFromGroup('opponentStrums', 3, 'x', defaultPlayerStrumX2 + 16000)
			setPropertyFromGroup('opponentStrums', 4, 'x', defaultPlayerStrumX3 + 4000)	
		
		end
		
		if value1 == 'false' then
			setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0)
			setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1)
			setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2)
			setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 )
			setPropertyFromGroup('playerStrums', 4, 'x', defaultPlayerStrumX4 )
		
			setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0)
			setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1)
			setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2)
			setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3)
			setPropertyFromGroup('opponentStrums', 4, 'x', defaultOpponentStrumX4)
		end
		
		if value2 == 'true' then
			
			flipit = true
		end
		if value2 == 'false' then
			
			flipit = false
		end
	end
end

function onUpdatePost()
	if flipit then	
		P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)

		P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
	
		setProperty('iconP1.x',P1Mult - 110)
	
		setProperty('iconP1.origin.x',240)
	
		setProperty('iconP1.flipX',true)
	
		setProperty('iconP2.x',P2Mult + 110)
	
		setProperty('iconP2.origin.x',-100)
	
		setProperty('iconP2.flipX',true)
		
		setProperty('healthBarP2.x',(getProperty('healthBarP2.x') - 1000))
	
		setProperty('healthBarP1.flipX',true)
		setProperty('healthBarP2.flipX',true)
	end
	
	if not flipit then

		setProperty('iconP1.flipX',false)
		
		setProperty('iconP2.flipX',false)
		
		setProperty('healthBar.flipX',false)
		setProperty('healthBarP1.flipX',false)
		setProperty('healthBarP2.flipX',false)
	end

	

end

function opponentNoteHit()
	if flipit then	
		health = getProperty('health')
		if getProperty('health') > 0.05 then
			setProperty('health', health- 0.03);
		end
	end
end
