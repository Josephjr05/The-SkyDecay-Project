function onCreate()
         setProperty('gf.alpha', 1)
         setScrollFactor('gfGroup', 1, 1)
   end

function onStepHit()
         if curStep == 2560 then
        setProperty('gf.alpha', 0)
    end

         if curStep == 2814 then
         setProperty('gf.alpha', 1)
   end 
end