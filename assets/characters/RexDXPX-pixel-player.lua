local SongCompatibility = (FunkMixSongs)
local FunkMixSongs = {'mushroom-plains', 'bricks-and-lifts', 'lethal-lava-lair', 'mushroom-plains-b-side', 'bricks-and-lifts-b-side', 'lethal-lava-lair-b-side', 'deep-deep-voyage', 'hop-hop-heights', 'koopa-armada', '2-player-game', 'destruction-dance', 'portal-power', 'bullet-time', 'boo-blitz', 'cross-console-clash', 'wrong-warp', 'first-level', 'balls', 'game-over', 'loves-end', 'hyperactive-starblaze', 'co-op', 'star-colors', 'snowy-plains', 'overfilled'}

function onUpdate()
    for i,r in pairs(FunkMixSongs) do
        if songPath == r then
            setProperty('boyfriend.x', defaultBoyfriendX+25)
            setProperty('boyfriend.y', defaultBoyfriendY+100)
            setProperty('boyfriend.scale.x', 7)
            setProperty('boyfriend.scale.y', 7)
        elseif songPath == 'cross-console-clash' then
            setProperty('boyfriend.x', defaultBoyfriendX+25)
            setProperty('boyfriend.y', defaultBoyfriendY+100)
            setProperty('boyfriend.scale.x', 7)
            setProperty('boyfriend.scale.y', 7)
            debugPrint('X: '..getProperty('boyfriend.x') .. ' Y: '.. getProperty('boyfriend.y'))
        end
    end    
end

function onUpdatePost()
end