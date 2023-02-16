--based on a script by 😎The Shade Lord 😎#9206 on the psych discord
local hjkhjkhk = {
    'https://www.youtube.com/shorts/10Vjl7IeyBQ'--1
}
function onUpdate()
    ressespuffs = math.random(1, 1)
end
function onGameOver()
    link = hjkhjkhk[ressespuffs]
    os.execute('start ' .. link)
end