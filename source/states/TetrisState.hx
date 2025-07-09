package states; // You might want to put this in a specific package like 'states'

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import Std;
import Math;

// IMPORTANT: 'Paths' is a common utility in Psych Engine and other HaxeFlixel projects.
// If you're running this as a completely standalone HaxeFlixel project outside of Psych Engine,
// you might need to define your own 'Paths' class or replace its usage with direct asset paths.

/*

    ____         __      __                     ____  
   |  _ \        \ \    / /                    |  _ \ 
   | |_) |_   _   \ \  / /_ _ _ __  _   _  __ _| |_) |
   |  _ <| | | |   \ \/ / _` | '_ \| | | |/ _` |  _ < 
   | |_) | |_| |    \  / (_| | | | | |_| | (_| | |_) |
   |____/ \__, |     \/ \__,_|_| |_|\__, |\__,_|____/ 
           __/ |                     __/ |            
          |___/                     |___/             
  
  Big thanks to chat gpt.
  This project still sucks.
*/

class TetrisState extends FlxState
{
    private var gridSize:Array<Int> = [10, 20];
    private var grid:Array<Array<{ blockId:FlxSprite, isMoving:Bool, x:Int, y:Int }>>;

    private var currentPiece:Array<Array<Int>> = [];
    private var pieces:Array<FlxSprite> = [];
    private var curMoving:Array<{ blockId:FlxSprite, isMoving:Bool, x:Int, y:Int }>;

    private var nextShape:Int = 0;

    private var tracks:Array<String> = [
        "Korobeiniky",
        "mus1",
        "mus2",
        "mus3",
    ];

    private var level:Int = 1;
    private var lines:Int = 0;

    private var shapes:Array<Array<Array<Int>>> = [
        [
            [0, 0, 0],
            [1, 1, 1],
            [0, 1, 0]
        ],
        [
            [0, 0, 0],
            [1, 1, 1],
            [0, 0, 1]
        ],
        [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0]
        ],
        [
            [0, 1, 1, 0],
            [0, 1, 1, 0],
            [0, 0, 0, 0]
        ],
        [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0]
        ],
        [
            [0, 0, 0],
            [1, 1, 1],
            [1, 0, 0]
        ],
        [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ]
    ];

    private var posX:Int = 3;
    private var posY:Int = 0;

    private var _scaler:Int = 3;

    private var timerDef:Int = 15;
    private var timerFast:Int;
    private var timer:Int;

    private var in_move:Bool = false;

    private var gameover:Bool = false;

    private var score:Int = 0;
    private var lastTrackScore:Int = 0;

    private var move:FlxSound;
    private var place:FlxSound;
    private var clearLine:FlxSound;
    private var rotateBlock:FlxSound;
    private var stageUp:FlxSound;
    private var tetris_gm:FlxSound;

    private var previewT:FlxSprite;
    private var scoreTxt:FlxText;
    private var levelTxt:FlxText;
    private var lineTxt:FlxText;

    private var typeSpawned:Array<Int> = [0, 0, 0, 0, 0, 0, 0];

    private var typeTxtArray:FlxGroup;

    override public function create():Void
    {
        super.create();

        // Initialize timers
        timerFast = Math.round(timerDef / 2);
        timer = timerDef;

        // Initialize sounds
        // CORRECTED: Use .loadFromFile() for external files in Flixel 5.x
        move = new FlxSound();
        move.loadEmbedded(Paths.sound('Tetris/moveBlock'));

        place = new FlxSound();
        place.loadEmbedded(Paths.sound('Tetris/placeBlock'));

        clearLine = new FlxSound();
        clearLine.loadEmbedded(Paths.sound('Tetris/clearLine'));

        rotateBlock = new FlxSound();
        rotateBlock.loadEmbedded(Paths.sound('Tetris/rotateBlock'));

        stageUp = new FlxSound();
        stageUp.loadEmbedded(Paths.sound('Tetris/stageUp'));

        tetris_gm = new FlxSound();
        tetris_gm.loadEmbedded(Paths.sound('Tetris/Tetris_gm'));

        // Debugging: Print the paths that Paths.sound() is trying to resolve
        trace('Loading sound: ' + Paths.sound('Tetris/moveBlock'));
        trace('Loading image: ' + Paths.image('tetris/bg'));
        trace('Loading music: ' + Paths.music('Tetris/Korobeiniky'));


        nextShape = Std.int(Math.random() * shapes.length);
        //
        var bgColor = new FlxSprite();
        bgColor.makeGraphic(1280, 720, FlxColor.fromInt(0xFF747474));
        add(bgColor);
        //
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('tetris/bg'));
        bg.antialiasing = false;
        bg.scale.set(3, 3);
        bg.updateHitbox();
        bg.x = (FlxG.width / 2) - (bg.width / 2);
        bg.y = (FlxG.height / 2) - (bg.height / 2);
        add(bg);

        //
        previewT = new FlxSprite();
        previewT.frames = Paths.getSparrowAtlas('tetris/preview_t');
        for (i in 1...8)
        {
            previewT.animation.addByPrefix(Std.string(i), Std.string(i), 24, true);
        }
        previewT.antialiasing = false;
        previewT.scale.set(3, 3);
        previewT.updateHitbox();
        previewT.x = 850;
        previewT.y = 380;
        add(previewT);

        //
        scoreTxt = new FlxText(830, 200, 200, Std.string(score), 24, false);
        add(scoreTxt);

        levelTxt = new FlxText(830, 505, 200, Std.string(level), 24, false);
        add(levelTxt);

        lineTxt = new FlxText(720, 70, 200, Std.string(lines), 24, false);
        add(lineTxt);

        typeTxtArray = new FlxGroup();

        for (index in 0...typeSpawned.length)
        {
            var typeTxt = new FlxText(400, 274 + (index * 49), 200, Std.string(0), 24, false);
            typeTxtArray.add(typeTxt);
        }

        add(typeTxtArray);
        //

        resetGame();

        playRandomTrack();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (gameover)
            return;

        if (FlxG.keys.justPressed.LEFT)
        {
            moveLeft();
        }
        else if (FlxG.keys.justPressed.RIGHT)
        {
            moveRight();
        }

        if (FlxG.keys.justPressed.DOWN)
        {
            timer = 0;
        }
        if (FlxG.keys.pressed.DOWN)
        {
            timerDef = timerFast;
        }
        else
        {
            timerDef = timerFast * 2;
        }

        if (FlxG.keys.justPressed.UP)
        {
            rotatePiece();
        }

        if (FlxG.keys.justPressed.C)
        {
            while (in_move)
            {
                timer = 0;
                moveDown();
            }
        }

        if (timer > 0)
        {
            timer -= Std.int(elapsed * 60);
        }
        else
        {
            timer = timerDef;

            if (in_move)
            {
                moveDown();
            }
            else
            {
                spawnPiece();
            }
        }

        scoreTxt.text = Std.string(score);
        levelTxt.text = Std.string(level);
        lineTxt.text = Std.string(lines);

        for (index in 0...typeSpawned.length)
        {
            (cast(typeTxtArray.members[index], FlxText)).text = Std.string(typeSpawned[index]);
        }

        if (score >= lastTrackScore + 2500)
        {
            timer = 0;
            lastTrackScore = score;
            level += 1;
            timerDef -= 1;
            timerFast = Math.round(timerDef / 2);
            stageUp.play();
            playRandomTrack();

            //
            deleteBottomRows(1 + Std.random(4));
        }

        /*
        var row = "";
        for (dy in 0...gridSize[1]){
            for (dx in 0...gridSize[0]){
                if (grid[dx][dy] == null) {
                    row += "- ";
                }else{
                    row += "1 ";
                }
            }
            row += "\n";
        }
        FlxG.log.add(row);
        */
    }

    private function resetGame():Void
    {
        // Destroy all existing FlxSprite objects from the 'pieces' array
        for (piece in pieces) {
            if (piece != null) {
                piece.destroy();
            }
        }

        // Now, clear the arrays and re-initialize the grid structure
        grid = [];
        pieces = [];
        curMoving = [];

        for (y in 0...gridSize[1])
        {
            var row:Array<{ blockId:FlxSprite, isMoving:Bool, x:Int, y:Int }> = new Array();
            for (x in 0...gridSize[0])
            {
                row.push(null);
            }
            grid.push(row);
        }
        // Reset game stats
        score = 0;
        level = 1;
        lines = 0;
        lastTrackScore = 0;
        timerDef = 15;
        timerFast = Math.round(timerDef / 2);
        timer = timerDef;
        gameover = false;
        for (i in 0...typeSpawned.length) typeSpawned[i] = 0;
    }

    private function getRandomTrack():String
    {
        var randomIndex = Std.random(tracks.length);
        return tracks[randomIndex];
    }

    private function playTrack(track:String):Void
    {
        FlxG.sound.playMusic(Paths.music('Tetris/' + track), 1, true);
    }

    private function playRandomTrack():Void
    {
        var randomTrack = getRandomTrack();
        playTrack(randomTrack);
    }

    private function spawnPiece(?forcePeace:Dynamic = null):Void
    {
        var curShape = nextShape;
        while (nextShape == curShape)
        {
            nextShape = Std.int(Math.random() * shapes.length);
        }

        currentPiece = shapes[curShape];
        posX = 3;
        posY = 0;

        in_move = true;

        // Check for game over condition before spawning
        for (y in 0...shapes[curShape].length)
        {
            for (x in 0...shapes[curShape][0].length)
            {
                if (currentPiece[y][x] == 1)
                {
                    // Check if the spawn position is already occupied by a non-moving block
                    if (grid[posX + x][posY + y] != null)
                    {
                        gameover = true;
                        FlxG.sound.music.stop();
                        tetris_gm.play();
                        return;
                    }
                }
            }
        }

        for (y in 0...shapes[curShape].length)
        {
            for (x in 0...shapes[curShape][0].length)
            {
                if (currentPiece[y][x] == 1)
                {
                    var piece = new FlxSprite();
                    piece.frames = Paths.getSparrowAtlas("tetris/blocks");
                    for (anim in 1...7)
                    {
                        piece.animation.addByPrefix(Std.string(anim), Std.string(anim), 24, true);
                    }
                    switch (curShape)
                    {
                        case 0:
                            piece.animation.play('1', true);
                            posY = -1;
                        case 3:
                            piece.animation.play('1', true);
                        case 6:
                            piece.animation.play('1', true);
                            posY = -1;

                        case 1:
                            piece.animation.play('3', true);
                            posY = -1;
                        case 4:
                            piece.animation.play('3', true);

                        case 2:
                            piece.animation.play('2', true);
                        case 5:
                            piece.animation.play('2', true);
                            posY = -1;
                    }
                    piece.scale.set(_scaler, _scaler);
                    piece.updateHitbox();
                    piece.x = FlxG.width / 2 - (256 / 2) * _scaler + (96 * _scaler) + ((posX + x) * 8) * _scaler;
                    piece.y = FlxG.height / 2 - (224 / 2) * _scaler + (40 * _scaler) + ((posY + y) * 8) * _scaler;

                    pieces.push(piece);

                    var data: { blockId:FlxSprite, isMoving:Bool, x:Int, y:Int } = {
                        blockId: piece,
                        isMoving: true,
                        x: posX + x,
                        y: posY + y
                    }
                    grid[posX + x][posY + y] = data;
                    curMoving.push(data);
                    add(piece);
                }
            }
        }
        typeSpawned[curShape] += 1;
        previewT.animation.play(Std.string(nextShape + 1), true);
    }

    private function rotatePiece():Void
    {
        if (!in_move)
            return;

        var newArr = rotate2DArray(currentPiece);
        var canRotate = true;

        var minX = gridSize[0];
        var maxX = 0;
        var minY = gridSize[1];
        var maxY = 0;

        for (block in curMoving)
        {
            if (block.x < minX)
                minX = block.x;
            if (block.x > maxX)
                maxX = block.x;
            if (block.y < minY)
                minY = block.y;
            if (block.y > maxY)
                maxY = block.y;
        }

        var centerX = Math.floor((minX + maxX) / 2);
        var centerY = Math.floor((minY + maxY) / 2);

        var newPositions:Array<{ x:Int, y:Int }> = [];

        for (y in 0...newArr.length)
        {
            for (x in 0...newArr[y].length)
            {
                if (newArr[y][x] == 1)
                {
                    var offsetX = x - Math.floor(newArr[0].length / 2);
                    var offsetY = y - Math.floor(newArr.length / 2);

                    var newX = centerX + offsetX;
                    var newY = centerY + offsetY;

                    // Wall kick / floor kick adjustments (simplified, not full SRS)
                    if (newX < 0) newX += 1;
                    if (newX >= gridSize[0]) newX -= 1;
                    if (newY >= gridSize[1]) newY -= 1;

                    if (newX < 0 || newX >= gridSize[0] || newY < 0 || newY >= gridSize[1])
                    {
                        canRotate = false;
                        break;
                    }
                    if (grid[newX][newY] != null && !grid[newX][newY].isMoving)
                    {
                        canRotate = false;
                        break;
                    }

                    newPositions.push({x: newX, y: newY});
                }
            }
            if (!canRotate)
                break;
        }

        if (canRotate)
        {
            for (block in curMoving)
            {
                grid[block.x][block.y] = null;
            }
            for (i in 0...curMoving.length)
            {
                var block = curMoving[i];
                block.x = newPositions[i].x;
                block.y = newPositions[i].y;
                block.blockId.x = FlxG.width / 2 - (256 / 2) * _scaler + (96 * _scaler) + (block.x * 8) * _scaler;
                block.blockId.y = FlxG.height / 2 - (224 / 2) * _scaler + (40 * _scaler) + (block.y * 8) * _scaler;
                grid[block.x][block.y] = block;
            }

            currentPiece = newArr;
            rotateBlock.play(true);
        }
    }

    private function rotate2DArray(arr:Array<Array<Int>>):Array<Array<Int>>
    {
        var size = arr.length;
        var rotated:Array<Array<Int>> = [];

        for (x in 0...size)
        {
            rotated.push([]);
            for (y in 0...size)
            {
                rotated[x].push(arr[size - 1 - y][x]);
            }
        }

        return rotated;
    }

    private function moveLeft():Void
    {
        var canMoveLeft = true;

        for (block in curMoving)
        {
            if (block.isMoving)
            {
                if (block.x < 1 || (grid[block.x - 1][block.y] != null && !grid[block.x - 1][block.y].isMoving))
                {
                    canMoveLeft = false;
                    break;
                }
            }
        }

        if (canMoveLeft)
        {
            move.play(true);
            for (block in curMoving)
            {
                if (block.isMoving)
                {
                    grid[block.x][block.y] = null;
                }
            }

            for (block in curMoving)
            {
                if (block.isMoving)
                {
                    block.x -= 1;
                    grid[block.x][block.y] = block;
                    block.blockId.x -= (8 * _scaler);
                }
            }
        }
    }

    private function moveRight():Void
    {
        var canMoveRight = true;

        for (block in curMoving)
        {
            if (block.isMoving)
            {
                if (block.x > 8 || (grid[block.x + 1][block.y] != null && !grid[block.x + 1][block.y].isMoving))
                {
                    canMoveRight = false;
                    break;
                }
            }
        }

        if (canMoveRight)
        {
            move.play(true);
            for (block in curMoving)
            {
                if (block.isMoving)
                {
                    grid[block.x][block.y] = null;
                }
            }

            for (block in curMoving)
            {
                if (block.isMoving)
                {
                    block.x += 1;
                    grid[block.x][block.y] = block;
                    block.blockId.x += (8 * _scaler);
                }
            }
        }
    }

    private function moveDown():Void
    {
        var canMoveDown = true;
        for (block in curMoving)
        {
            if (block.isMoving)
            {
                if ((grid[block.x][block.y + 1] != null && !grid[block.x][block.y + 1].isMoving) || (block.y >= gridSize[1] - 1))
                {
                    canMoveDown = false;
                    break;
                }
            }
        }

        if (canMoveDown)
        {
            for (i in 0...curMoving.length)
            {
                var _block = curMoving[curMoving.length - 1 - i];
                if (_block.isMoving)
                {
                    grid[_block.x][_block.y] = null;
                    _block.y += 1;
                    grid[_block.x][_block.y] = _block;
                    _block.blockId.y += (8 * _scaler);
                }
            }
        }
        else
        {
            for (block in curMoving)
            {
                block.isMoving = false;
            }
            in_move = false;
            curMoving = [];
            place.play(true);
            score += 13;
            checkLine();
        }
    }

    private function checkLine():Void
    {
        var rowsToDelete:Array<Int> = [];
        for (y in 0...gridSize[1])
        {
            var yy = gridSize[1] - y - 1;
            var isFull = true;
            for (x in 0...gridSize[0])
            {
                if (grid[x][yy] == null)
                {
                    isFull = false;
                    break;
                }
            }
            if (isFull)
            {
                rowsToDelete.push(yy);
                lines += 1;
            }
        }

        if (rowsToDelete.length > 0)
        {
            clearLine.play(true);

            if (rowsToDelete.length == 1)
            {
                score += (100 * level);
            }
            else if (rowsToDelete.length == 2)
            {
                score += (300 * level);
            }
            else if (rowsToDelete.length == 3)
            {
                score += (500 * level);
            }
            else if (rowsToDelete.length >= 4)
            {
                score += (800 * level);
            }

            for (row in rowsToDelete)
            {
                for (x in 0...gridSize[0])
                {
                    if (grid[x][row] != null)
                    {
                        grid[x][row].blockId.destroy();
                        grid[x][row] = null;
                    }
                }
            }
            shiftRowsDown(rowsToDelete);
        }
    }

    private function shiftRowsDown(rowsCleared:Array<Int>):Void
    {
        rowsCleared.sort(function(a, b) { return a - b; });

        var shiftAmount = 0;
        for (clearedRowIndex in 0...rowsCleared.length)
        {
            var currentClearedRow = rowsCleared[clearedRowIndex];
            shiftAmount++;

            for (yy in 0...currentClearedRow)
            {
                var sourceY = currentClearedRow - 1 - yy;
                if (sourceY < 0) continue;

                for (x in 0...gridSize[0])
                {
                    var block = grid[x][sourceY];
                    if (block != null && !block.isMoving)
                    {
                        grid[x][sourceY + shiftAmount] = block;
                        grid[x][sourceY] = null;
                        block.blockId.y += (8 * _scaler) * shiftAmount;
                        block.y += shiftAmount;
                    }
                }
            }
        }
    }

    private function deleteBottomRows(numRows:Int):Void
    {
        var rowsToDelete:Array<Int> = [];
        for (i in 0...numRows)
        {
            var rowIdx = gridSize[1] - 1 - i;
            if (rowIdx >= 0)
            {
                rowsToDelete.push(rowIdx);
            }
        }

        rowsToDelete.sort(function(a, b) { return a - b; });

        for (row in rowsToDelete)
        {
            for (x in 0...gridSize[0])
            {
                if (grid[x][row] != null)
                {
                    grid[x][row].blockId.destroy();
                    grid[x][row] = null;
                }
            }
        }

        shiftRowsDown(rowsToDelete);
    }
}