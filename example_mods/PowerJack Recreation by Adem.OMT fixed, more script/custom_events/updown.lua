function onEvent(name,value1,value2)
      if name == 'updown' then
           if value1 == 'on' then
        noteTweenY('upand0', 0, defaultOpponentStrumY0-5, 0.3, 'sineInOut')
        noteTweenY('downand1', 1, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
        noteTweenY('upand2', 2, defaultOpponentStrumY0-5, 0.3, 'sineInOut')
        noteTweenY('downand3', 3, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
        noteTweenY('upand4', 4, defaultOpponentStrumY0-5, 0.3, 'sineInOut')
        noteTweenY('downand5', 5, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
        noteTweenY('upand6', 6, defaultOpponentStrumY0-5, 0.3, 'sineInOut')
        noteTweenY('downand7', 7, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
        upanddown = true

        elseif value1 == 'off' then
    upanddown = false
    noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0, 0.5)
    noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1, 0.5)
    noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2, 0.5)
    noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3, 0.5)
    noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0, 0.5)
    noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1, 0.5)
    noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2, 0.5)
    noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3, 0.5)
    noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0, 0.5)
    noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1, 0.5)
    noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2, 0.5)
    noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3, 0.5)
    noteTweenY('defaultOpponentStrumY0', 0, defaultOpponentStrumY0, 0.5)
    noteTweenY('defaultOpponentStrumY1', 1, defaultOpponentStrumY1, 0.5)
    noteTweenY('defaultOpponentStrumY2', 2, defaultOpponentStrumY2, 0.5)
    noteTweenY('defaultOpponentStrumY3', 3, defaultOpponentStrumY3, 0.5)

      end
end
    end

function onTweenCompleted(tag)
  if tag == 'down' then
    noteTweenY('upa', 0, -200, 0.1, 'linear')
    noteTweenY('upa1', 1, -200, 0.1, 'linear')
    noteTweenY('upa2', 2, -200, 0.1, 'linear')
    noteTweenY('upa3', 3, -200, 0.1, 'linear')
    noteTweenY('upa4', 4, -200, 0.1, 'linear')
    noteTweenY('upa5', 5, -200, 0.1, 'linear')
    noteTweenY('upa6', 6, -200, 0.1, 'linear')
    noteTweenY('upa7', 7, -200, 0.1, 'linear')
  end
  
  if tag == 'up' then
        noteTweenY('downa', 0, 200, 0.1, 'linear')
        noteTweenY('downa1', 1, 200, 0.1, 'linear')
        noteTweenY('downa2', 2, 200, 0.1, 'linear')
        noteTweenY('downa3', 3, 200, 0.1, 'linear')
        noteTweenY('downa4', 4, 200, 0.1, 'linear')
        noteTweenY('downa5', 5, 200, 0.1, 'linear')
        noteTweenY('downa6', 6, 200, 0.1, 'linear')
        noteTweenY('downa7', 7, 200, 0.1, 'linear')
  end
  if tag == 'downa' or tag == 'upa' then
    spin = true
  end
  if upanddown == true then
  if tag == 'upand0' then
    noteTweenY('downand0', 0, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand1', 1, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand2', 2, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand3', 3, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand4', 4, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand5', 5, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand6', 6, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand7', 7, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
  end
  if tag == 'downand0' then
    noteTweenY('upand0', 0, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand1', 1, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand2', 2, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand3', 3, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand4', 4, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand5', 5, defaultOpponentStrumY0+25, 0.3, 'sineInOut')
    noteTweenY('upand6', 6, defaultOpponentStrumY0-25, 0.3, 'sineInOut')
    noteTweenY('downand7', 7, defaultOpponentStrumY0+25, 0.3, 'sineInOut')

  end
    end
       end


