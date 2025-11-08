package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import backend.Paths;
import Std;

import flixel.util.FlxTimer;

class TetrisState extends MusicBeatState {
    private var gridSize:Array<Int> = [10,20];
    private var grid:Array<Array<Dynamic>> = [];

    private var currentPiece:Array<Array<Int>> = [];
    private var pieces:Array<FlxSprite> = [];
    private var curMoving:Array<Dynamic> = [];

    private var nextShape:Int = 0;

    private var tracks:Array<String> = [
        "Tetris/Korobeiniky",
        "Tetris/mus1",
        "Tetris/mus2",
        "Tetris/mus3"
    ];

    private var level:Int = 1;
    private var lines:Int = 0;

    private var shapes:Array<Array<Array<Int>>> = [
        [
            [0,0,0],
            [1,1,1],
            [0,1,0]
        ],
        [
            [0,0,0],
            [1,1,1],
            [0,0,1]
        ],
        [
            [1,1,0],
            [0,1,1],
            [0,0,0]
        ],
        [
            [0,1,1,0],
            [0,1,1,0],
            [0,0,0,0]
        ],
        [
            [0,1,1],
            [1,1,0],
            [0,0,0]
        ],
        [
            [0,0,0],
            [1,1,1],
            [1,0,0]
        ],
        [
            [0,0,0,0],
            [1,1,1,1],
            [0,0,0,0],
            [0,0,0,0]
        ]
    ];

    private var posX:Int = 3;
    private var posY:Int = 0;
    private var _scaler:Int = 3;

   private var timerDef:Int = 15; private 
   var timerFast:Int; 
   private var timer:Float;

    private var in_move:Bool = false;
    private var gameover:Bool = false;

    private var score:Int = 0;
    private var lastTrackScore:Int = 0;

    private var moveS:FlxSound;
    private var placeS:FlxSound;
    private var clearLineS:FlxSound;
    private var rotateBlockS:FlxSound;
    private var stageUpS:FlxSound;
    private var tetris_gm:FlxSound;

    private var previewT:FlxSprite;
    private var scoreTxt:FlxText;
    private var levelTxt:FlxText;
    private var lineTxt:FlxText;

    private var typeSpawned:Array<Int> = [0,0,0,0,0,0,0];
    private var typeTxtArray:FlxTypedGroup<FlxText>;

    private var resetCooldown:Float = 0;
    private var canReset:Bool = true;
    private var resetDelay:Float = 0.1;

    private var gameoverTimerStarted:Bool = false;

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();

        nextShape = Std.random(shapes.length);

        timerFast = Std.int(timerDef / 2); timer = timerDef;

        // load sounds
        moveS = new FlxSound(); moveS.loadEmbedded(Paths.sound("Tetris/moveBlock"));
        placeS = new FlxSound(); placeS.loadEmbedded(Paths.sound("Tetris/placeBlock"));
        clearLineS = new FlxSound(); clearLineS.loadEmbedded(Paths.sound("Tetris/clearLine"));
        rotateBlockS = new FlxSound(); rotateBlockS.loadEmbedded(Paths.sound("Tetris/rotateBlock"));
        stageUpS = new FlxSound(); stageUpS.loadEmbedded(Paths.sound("Tetris/stageUp"));
        tetris_gm = new FlxSound(); tetris_gm.loadEmbedded(Paths.sound("Tetris/Tetris_gm"));

        // background overlay
        var bgColor = new FlxSprite();
        bgColor.makeGraphic(1280, 720, 0xFF747474);
        add(bgColor);

        // background art
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("tetris/bg"));
        bg.antialiasing = false;
        bg.scale.set(_scaler, _scaler);
        bg.updateHitbox();
        bg.x = (FlxG.width / 2) - (bg.width / 2);
        bg.y = (FlxG.height / 2) - (bg.height / 2);
        add(bg);

        // preview
        previewT = new FlxSprite();
        previewT.frames = Paths.getSparrowAtlas("tetris/preview_t");
        for (i in 1...8) previewT.animation.addByPrefix(Std.string(i), Std.string(i), 24, true);
        previewT.antialiasing = false;
        previewT.scale.set(_scaler, _scaler);
        previewT.updateHitbox();
        previewT.x = 850;
        previewT.y = 380;
        add(previewT);

        // HUD
        scoreTxt = new FlxText(830, 200, 200, Std.string(score), 24, false);
        add(scoreTxt);
        levelTxt = new FlxText(830, 505, 200, Std.string(level), 24, false);
        add(levelTxt);
        lineTxt = new FlxText(720, 70, 200, Std.string(lines), 24, false);
        add(lineTxt);

        typeTxtArray = new FlxTypedGroup<FlxText>();
        for (index in 0...typeSpawned.length) {
            var t = new FlxText(400, 274 + (index * 49), 200, "0", 24, false);
            typeTxtArray.add(t);
        }
        add(typeTxtArray);

        gameStart();
        playRandomTrack();
        spawnPiece();
    }

    private function restartGame():Void {
        gameover = false;

        if (tetris_gm != null) {
            tetris_gm.stop();
        }
        
        // remove pieces
        for (piece in pieces) {
            piece.destroy();
            remove(piece);
        }

        // Clear pieces
        pieces = [];
        
        // Clear moving pieces
        curMoving = [];

        // reset variables
        score = 0;
        level = 1;
        lines = 0;
        lastTrackScore = 0;

        timerDef = 15;
        timerFast = Std.int(timerDef / 2);
        timer = timerDef;

        typeSpawned = [0,0,0,0,0,0,0];

        // reset spawned types counters & HUD texts
        for (i in 0...typeSpawned.length) typeSpawned[i] = 0;
        scoreTxt.text = Std.string(score);
        levelTxt.text = Std.string(level);
        lineTxt.text = Std.string(lines);

        // reset type text UI
        for (index in 0...typeSpawned.length) {
            var t:FlxText = null;
            // typeTxtArray may be a FlxGroup; access members array
            if (typeTxtArray != null && typeTxtArray.members != null && index < typeTxtArray.members.length) {
                t = cast typeTxtArray.members[index];
            }
            if (t != null) t.text = "0";
        }

        // pick a new next shape & preview
        nextShape = Std.random(shapes.length);
        if (previewT != null) previewT.animation.play(Std.string(nextShape + 1), true);

        gameStart();
        playRandomTrack();
        spawnPiece();
    }

    function gameStart():Void { //This sets the grids. Doesn't work with restart game. So start first and then restartGame if needed!
        grid = [];
        for (y in 0...gridSize[1]) {
            var row = new Array<Dynamic>();
            for (x in 0...gridSize[0]) row.push(null);
            grid.push(row);
        }
    }

    private function getRandomTrack():String return tracks[Std.random(tracks.length)];
    private function playTrack(track:String):Void {
        FlxG.sound.playMusic(Paths.music(track), 1, true);
    }
    private function playRandomTrack():Void playTrack(getRandomTrack());

    private function spawnPiece(?forcePiece:Bool = false):Void {
        var curShape = nextShape;
        while (nextShape == curShape) nextShape = Std.random(shapes.length);

        currentPiece = shapes[curShape];
        posX = 3; posY = 0;
        in_move = true;

        // spawn collision -> gameover
        for (y in 0...shapes[curShape].length) {
            for (x in 0...shapes[curShape][0].length) {
                if (currentPiece[y][x] == 1 && grid[posX + x][posY + y] != null) {
                    gameover = true;
                    if (!gameoverTimerStarted) { 
                        gameoverTimerStarted = true; 
                        FlxG.sound.music.stop(); tetris_gm.play();
                    
                        var t:FlxTimer = new FlxTimer();
                        t.start(4, function(_t:FlxTimer) { // automatically restarts when you get a gameover. Does NOT softlock you finally.
                            restartGame();
                            gameover = false;
                            gameoverTimerStarted = false;
                        });
                    }
                    
                }
            }
        }

        // create sprites
        for (y in 0...shapes[curShape].length) {
            for (x in 0...shapes[curShape][0].length) {
                if (currentPiece[y][x] == 1) {
                    var piece = new FlxSprite();
                    piece.frames = Paths.getSparrowAtlas("tetris/blocks");
                    for (anim in 1...7) piece.animation.addByPrefix(Std.string(anim), Std.string(anim), 24, true);

                    switch (curShape) {
                        case 0: piece.animation.play("1", true); posY = -1;
                        case 3: piece.animation.play("1", true);
                        case 6: piece.animation.play("1", true); posY = -1;
                        case 1: piece.animation.play("3", true); posY = -1;
                        case 4: piece.animation.play("3", true);
                        case 2: piece.animation.play("2", true);
                        case 5: piece.animation.play("2", true); posY = -1;
                    }

                    piece.scale.set(_scaler, _scaler);
                    piece.updateHitbox();
                    piece.x = FlxG.width/2 - (256/2)*_scaler + (96*_scaler) + ((posX + x) * 8)*_scaler;
                    piece.y = FlxG.height/2 - (224/2)*_scaler + (40*_scaler) + ((posY + y) * 8)*_scaler;

                    pieces.push(piece);

                    var data = {
                        blockId: piece,
                        isMoving: true,
                        x: posX + x,
                        y: posY + y
                    };
                    grid[posX + x][posY + y] = data;
                    curMoving.push(data);
                    add(piece);
                }
            }
        }

        typeSpawned[curShape] += 1;
        previewT.animation.play(Std.string(nextShape + 1), true);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (gameover) return;

        if (controls.UI_LEFT_P) moveLeft();
        else if (controls.UI_RIGHT_P) moveRight();

        if (controls.UI_DOWN_P) timer = 0;
        if (controls.UI_DOWN_P) timerDef = timerFast;
        else timerDef = timerFast * 2;

        if (controls.UI_UP_P) rotatePiece();
        if (controls.ACCEPT) {
            while (in_move) {
                timer = 0;
                moveDown();
            }
        }

        if (controls.RESET && canReset)
        {
            canReset = false;
            resetCooldown = resetDelay;
            new FlxTimer().start(resetDelay, function(t:FlxTimer) {
                restartGame();
                canReset = true;
            });
        }

        if (controls.BACK) {
            FlxG.sound.playMusic(Paths.music("freakyMenuIvy"), 1, true);
            MusicBeatState.switchState(new MainMenuState());
        }

        if (timer > 0) timer -= elapsed * 60;
        else {
            timer = timerDef;
            if (in_move) moveDown(); else spawnPiece();
        }

        scoreTxt.text = Std.string(score);
        levelTxt.text = Std.string(level);
        lineTxt.text = Std.string(lines);

        for (index in 0...typeSpawned.length) {
            var t:FlxText = cast typeTxtArray.members[index];
            if (t != null) t.text = Std.string(typeSpawned[index]);
        }

        if (score >= lastTrackScore + 2500) {
            timer = 0;
            lastTrackScore = score;
            level += 1;
            timerDef -= 1;
            timerFast = Std.int(timerDef / 2);
            stageUpS.play();
            playRandomTrack();
            deleteBottomRows(1 + Std.random(4));
        }
    }

    // Improved rotation with simple wall kicks
    private function rotatePiece():Void {
        if (!in_move) return;

        var newArr = rotate2DArray(currentPiece);

        // find bounding center of current moving blocks
        var minX = gridSize[0], maxX = 0, minY = gridSize[1], maxY = 0;
        for (block in curMoving) {
            if (block.x < minX) minX = block.x;
            if (block.x > maxX) maxX = block.x;
            if (block.y < minY) minY = block.y;
            if (block.y > maxY) maxY = block.y;
        }

        var centerX = Std.int(Math.floor((minX + maxX) / 2));
        var centerY = Std.int(Math.floor((minY + maxY) / 2));

        // compute local offsets for the rotated piece
        var rawPositions:Array<{x:Int,y:Int}> = [];
        for (y in 0...newArr.length) {
            for (x in 0...newArr[y].length) {
                if (newArr[y][x] == 1) {
                    var offsetX = x - Std.int(Math.floor(newArr[0].length / 2));
                    var offsetY = y - Std.int(Math.floor(newArr.length / 3));
                    rawPositions.push({ x: offsetX, y: offsetY });
                }
            }
        }

        // wall-kick offsets to try
        var kicks:Array<{dx:Int, dy:Int}> = [
            { dx:0, dy:0 }, { dx:1, dy:0 }, { dx:-1, dy:0 },
            { dx:2, dy:0 }, { dx:-2, dy:0 }, { dx:0, dy:-1 },
            { dx:1, dy:-1 }, { dx:-1, dy:-1 }
        ];

        var successfulPositions:Array<{x:Int,y:Int}> = null;

        for (k in kicks) {
            var canPlace:Bool = true;
            var candidate:Array<{x:Int,y:Int}> = [];
            for (pos in rawPositions) {
                var newX = centerX + pos.x + k.dx;
                var newY = centerY + pos.y + k.dy;
                if (newX < 0 || newX >= gridSize[0] || newY < 0 || newY >= gridSize[1]) {
                    canPlace = false;
                    break;
                }
                if (grid[newX][newY] != null && !grid[newX][newY].isMoving) {
                    canPlace = false;
                    break;
                }
                candidate.push({ x: newX, y: newY });
            }
            if (canPlace) {
                successfulPositions = candidate;
                break;
            }
        }

        if (successfulPositions != null) {
            // clear old positions
            for (block in curMoving) grid[block.x][block.y] = null;
        
            // apply new positions
            for (i in 0...curMoving.length) {
                var block = curMoving[i];
                block.x = successfulPositions[i].x;
                block.y = successfulPositions[i].y;
                block.blockId.x = FlxG.width / 2 - (256 / 2) * _scaler + (96 * _scaler) + (block.x * 8) * _scaler;
                block.blockId.y = FlxG.height / 2 - (224 / 2) * _scaler + (40 * _scaler) + (block.y * 8) * _scaler;
                grid[block.x][block.y] = block;
            }
        
            currentPiece = newArr;
            rotateBlockS.play(true);
        }
    }

    private function rotate2DArray(arr:Array<Array<Int>>):Array<Array<Int>> {
        var size = arr.length;
        var rotated:Array<Array<Int>> = [];
        for (x in 0...size) {
            rotated.push([]);
            for (y in 0...size) rotated[x].push(arr[size - 1 - y][x]);
        }
        return rotated;
    }

    private function moveLeft():Void { var canMoveLeft = true; for (block in curMoving) { if (block.isMoving) { var bx = Std.int(block.x); var by = Std.int(block.y); if (bx < 1 || (grid[bx - 1][by] != null && !grid[bx - 1][by].isMoving)) { canMoveLeft = false; break; } } } if (canMoveLeft) { moveS.play(true); for (block in curMoving) if (block.isMoving) grid[Std.int(block.x)][Std.int(block.y)] = null; for (block in curMoving) { if (block.isMoving) { var bx = Std.int(block.x) - 1; var by = Std.int(block.y); block.x = bx; grid[bx][by] = block; block.blockId.x -= (8 * _scaler); } } } }

    private function moveRight():Void { var canMoveRight = true; for (block in curMoving) { if (block.isMoving) { var bx = Std.int(block.x); var by = Std.int(block.y); if (bx > gridSize[0] - 2 || (grid[bx + 1][by] != null && !grid[bx + 1][by].isMoving)) { canMoveRight = false; break; } } } if (canMoveRight) { moveS.play(true); for (block in curMoving) if (block.isMoving) grid[Std.int(block.x)][Std.int(block.y)] = null; for (block in curMoving) { if (block.isMoving) { var bx = Std.int(block.x) + 1; var by = Std.int(block.y); block.x = bx; grid[bx][by] = block; block.blockId.x += (8 * _scaler); } } } }

    private function moveDown():Void { var canMoveDown = true; for (block in curMoving) { if (block.isMoving) { var bx = Std.int(block.x); var by = Std.int(block.y); var nextY = by + 1; if (nextY >= gridSize[1] || (grid[bx][nextY] != null && !grid[bx][nextY].isMoving)) { canMoveDown = false; break; } } }

        if (canMoveDown) {
            for (i in 0...curMoving.length) {
                var _block = curMoving[curMoving.length - 1 - i];
                var blockSprite = _block.blockId;
                if (_block.isMoving) {
                    var bx = Std.int(_block.x);
                    var by = Std.int(_block.y);
                    grid[bx][by] = null;
                    grid[bx][by + 1] = _block;
                    blockSprite.y += (8 * _scaler);
                    _block.y = by + 1;
                }
            }
        } else {
            for (block in curMoving) block.isMoving = false;
            in_move = false;
            curMoving = [];
            placeS.play(true);
            score += 13;
            checkLine();
        }
    }

    private function checkLine():Void {
        var rowsToDelete:Array<Int> = [];
        for (y in 0...gridSize[1]) {
            var yy = gridSize[1] - y - 1;
            var isFull = true;
            for (x in 0...gridSize[0]) {
                if (grid[x][yy] == null) { isFull = false; break; }
            }
            if (isFull) { rowsToDelete.push(yy); lines += 1; }
        }

        if (rowsToDelete.length > 0) {
            clearLineS.play(true);
            switch (rowsToDelete.length) {
                case 1: score += (100 * level);
                case 2: score += (300 * level);
                case 3: score += (500 * level);
                default: if (rowsToDelete.length >= 4) score += (800 * level);
            }

            for (row in rowsToDelete) {
                for (x in 0...gridSize[0]) {
                    if (grid[x][row] != null) {
                        grid[x][row].blockId.destroy();
                        grid[x][row] = null;
                    }
                }
            }
            shiftRowsDown(rowsToDelete);
        }
    }

    private function shiftRowsDown(a:Array<Int>):Void {
        for (_y in 0...a.length) {
            var y = a.length - 1 - _y;
            var row = a[y];
            for (_yy in 0...row) {
                var yy = row - 1 - _yy;
                for (x in 0...10) {
                    var block = grid[x][yy];
                    if (block != null && !block.isMoving) {
                        grid[x][yy + 1] = block;
                        grid[x][yy] = null;
                        block.blockId.y += (8 * _scaler);
                    }
                }
            }
        }
    }

    private function deleteBottomRows(numRows:Int):Void {
        var rowsToDelete:Array<Int> = [];
        for (i in 0...numRows) rowsToDelete.push(gridSize[1] - 1 - i);

        for (row in rowsToDelete) {
            for (x in 0...gridSize[0]) {
                if (grid[x][row] != null) {
                    grid[x][row].blockId.destroy();
                    grid[x][row] = null;
                }
            }
        }
        shiftRowsDown(rowsToDelete);
    }
}
