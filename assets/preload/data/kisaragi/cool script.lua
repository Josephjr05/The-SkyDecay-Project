--based on a script by 😎The Shade Lord 😎#9206 on the psych discord
local hjkhjkhk = {
    'https://osu.ppy.sh/home/download',
    'https://osu.ppy.sh/beatmapsets/1810741#mania/3714037',
    'https://youtu.be/qbnt_vmk4fU'--3
}
function onUpdate()
    ressespuffs = math.random(1, 3)
end
function onGameOver()
    link = hjkhjkhk[ressespuffs]
    os.execute('start ' .. link)
end