--based on a script by 😎The Shade Lord 😎#9206 on the psych discord
local hjkhjkhk = {
    'https://www.youtube.com/watch?v=41llBu0c2fU',
    'https://www.youtube.com/watch?v=FUJJS5bIQIc',
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=fC7oUOUEEi4',
    'https://www.youtube.com/watch?v=nVAsYEf44-A',
    'https://www.youtube.com/watch?v=0iCtC-EOzEo',
    'https://www.youtube.com/watch?v=tY-3zhmiKfU',
    'https://www.youtube.com/watch?v=ronPG90mvr8',
    'https://www.youtube.com/watch?v=0Yz-dm3Zqmo',
    'https://www.youtube.com/watch?v=pZz2Y76aPJI',
    'https://www.youtube.com/watch?v=K8NKNKub2HI',
    'https://www.youtube.com/watch?v=IsS_VMzY10I',
    'https://www.youtube.com/watch?v=PobQzVsj7GE',
    'https://www.youtube.com/watch?v=BsIa_LKojJI'--14
}
function onUpdate()
    ressespuffs = math.random(1, 14)
end
function onGameOver()
    link = hjkhjkhk[ressespuffs]
    os.execute('start ' .. link)
end