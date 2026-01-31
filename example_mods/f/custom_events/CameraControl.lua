function onEvent(n, v1, v2)
        if n == 'CameraControl' then
          local position = stringSplit(stringTrim(v1), ',')
          for i = 1, #position do position[i] = tonumber(stringTrim(position[i])) end
          callMethod('camFollow.setPosition', {position[1], position[2]})
          callMethod('camGame.snapToTarget', {''})
          setProperty('camGame.zoom',v2)
          setProperty('defaultCamZoom',v2)
        end
       end