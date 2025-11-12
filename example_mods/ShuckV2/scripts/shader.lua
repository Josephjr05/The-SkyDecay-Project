--[[ 
  bloomShader.lua
  Applies a bloom/glow effect to the entire game view.
  Place your "bloom.frag" file in mods/yourmod/shaders/
  Then, put this script in mods/yourmod/scripts/

  You can apply this shader to any camera or sprite (camGame, camHUD, or a background).
]]

function onCreatePost()
    -- 1️⃣ Load the shader (filename without .frag)
    initLuaShader("bloom")
    makeLuaSprite("bloom")
    makeGraphic("bloom", screenWidth, screenHeight)

    -- 2️⃣ Apply to a camera or sprite
    -- Options: 'camGame' (main gameplay), 'camHUD' (UI), or 'camOther'
    setSpriteShader("camGame", "bloom")

    -- 3️⃣ Default bloom settings (you can tweak)
    setShaderFloat("camGame", "Threshold", 0.4)  -- lower = more bloom
    setShaderFloat("camGame", "Intensity", 1.2)  -- higher = stronger glow

    -- Note: iResolution and iChannel0 are handled automatically by Psych Engine
end

function onUpdate(elapsed)
    -- ⏱️ Continuously update time for animations (even though bloom doesn’t use it much)
    setShaderFloat("camGame", "iTime", os.clock())

    -- 💡 Optional: You can change bloom in real time like this:
    -- setShaderFloat("camGame", "Threshold", getPropertyFromClass("flixel.FlxG", "mouse.x") / 1000)
end

--[[ 
  🎨 CUSTOMIZATION GUIDE:
  • To apply to HUD instead:
      setSpriteShader("camHUD", "bloom")

  • To make bloom stronger:
      setShaderFloat("camGame", "Intensity", 2.0)

  • To reduce glow spread (less fuzzy):
      increase "Threshold" (e.g., 0.6 or 0.8)

  • You can also create dynamic effects, e.g. pulse:
      setShaderFloat("camGame", "Intensity", 1.2 + math.sin(os.clock() * 2) * 0.3)
]]
