package states.freeplay.osu;

// import archipelago.APEntryState;
import backend.Highscore;
import backend.Song;
import backend.WeekData;
// import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import lime.utils.Assets;
import states.freeplay.OsuFreeplayState;
import states.freeplay.backend.DifficultyStars;

class DifficultySelectorSubState extends MusicBeatSubstate
{
    private var listLength:Int = Difficulty.list.length;

    var sprite:FlxSprite;
    private static var difficulty:Int = 0;

    var currentDifficultyId:String = 'normal';

    var missingTextBG:FlxSprite;
    var missingText:FlxText;

    var song:Dynamic;

    var canDo:Bool = false;
    var difficultyStars:DifficultyStars;
    var diffTextnecausetherewasnoimage:FlxText;

    // For unknown songs trap - store original difficulties (removed archipelago behavior)
    var originalDifficultyList:Array<String> = [];
    var actualSelectedDifficulty:Int = 0;

    public function new(song:Dynamic)
    {
        super();

        this.song = song;

        var background:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        background.alpha = 0.85;
        add(background);

        difficultySprites = new Map<String, FlxSprite>();

        sprite = new FlxSprite().loadGraphic(Paths.image('menudifficulties/${Difficulty.list[difficulty].toLowerCase()}'));
        sprite.screenCenter();
        add(sprite);

        difficultyStars = new DifficultyStars(0, 0);
        difficultyStars.visible = true;
        difficultyStars.scrollFactor.set();
        difficultyStars.screenCenter();
        difficultyStars.y += 15;
        difficultyStars.x += 25;
        add(difficultyStars);

        missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        missingTextBG.alpha = 0.6;
        missingTextBG.visible = false;
        add(missingTextBG);

        missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
        missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        missingText.scrollFactor.set();
        missingText.visible = false;
        add(missingText);

        diffTextnecausetherewasnoimage = new FlxText(50, 0, FlxG.width - 100, '', 24);
        diffTextnecausetherewasnoimage.setFormat(Paths.font("difficulty.ttf"), 80, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        diffTextnecausetherewasnoimage.scrollFactor.set();
        diffTextnecausetherewasnoimage.visible = false;
        add(diffTextnecausetherewasnoimage);

        new FlxTimer().start(0.2, function(tmr:FlxTimer) {
            canDo = true;
        });

        Mods.currentModDirectory = song.folder;
        PlayState.storyWeek = song.week;

        // Normal difficulty loading behaviour (no Archipelago/unknownSongs branch)
        switch (song.songName)
        {
            case 'Small Argument' | 'Beat Battle 2' | 'GeoStar' | 'Zeventeen' | 'Tag And Seek' | 'Rawr' | 'Funky Fanta' | 'Fightback' | 'Fangirl Frenzy' | 'Slowdown' | 'Pack-A-Punch':
                Difficulty.list = ['Hard'];
            case 'Rise' | 'Test Field' | 'Pack A Punch' | 'Driller':
                Difficulty.list = ['Normal'];
            case "Beat Battle":
                Difficulty.list = ["Normal", "Reasonable", "Unreasonable", "Semi-Impossible", "Impossible"];
            case "Testimony":
                Difficulty.list = ["4K", "Canon"];
            default:
                Difficulty.loadFromWeek();
        }

        listLength = Difficulty.list.length;
        WeekData.setDirectoryFromWeek();
        changeDiff();
    }

    public function setDifficultyStars(?difficulty:Int):Void
    {
        if (difficulty == null) return;
        difficultyStars.setNumber(difficulty);
        showStars();
    }

    /**
     * Make the album stars visible.
     */
    public function showStars():Void
    {
        difficultyStars.visible = true;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(canDo)
        {
            if(controls.UI_LEFT_P || controls.UI_RIGHT_P)
            {
                changeDiff(controls.UI_LEFT_P? -1 : 1);
            }
            if(controls.BACK)
                close();
            if(controls.ACCEPT)
            {
                var actualDifficulty:Int = difficulty;

                try
                {
                    persistentUpdate = false;
                    var songLowercase:String = Paths.formatToSongPath(song.songName);
                    var poop:String = Highscore.formatSong(songLowercase, actualDifficulty);
                    Mods.currentModDirectory = song.folder;
                    Song.loadFromJson(poop, songLowercase);
                    PlayState.isStoryMode = false;
                    PlayState.storyDifficulty = actualDifficulty;
                    trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
                }
                catch(e:Dynamic)
                {
                    trace('ERROR! $e');

                    var errorStr:String = e.toString();
                    if(errorStr.startsWith('[file_contents,assets/songs/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart

                    missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
                    missingText.screenCenter(Y);
                    missingText.visible = true;
                    missingTextBG.visible = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'));

                    super.update(elapsed);
                    return;
                }

                LoadingState.prepareToSong();
                LoadingState.loadAndSwitchState(new states.PlayState());
            }
            if (FlxG.keys.firstJustPressed() != FlxKey.NONE && missingText.visible)
            {
                missingText.visible = false;
                missingTextBG.visible = false;
            }
        }
    }

    function changeDiff(diff:Int = 0)
    {
        difficulty += diff;

        if(difficulty > listLength - 1)
            difficulty = 0;
        if(difficulty < 0)
            difficulty = listLength - 1;

        buildDifficultySprite(Difficulty.list[difficulty].toLowerCase());

        // Automatic star detection based on chart content 
        var autoStars:Int = computeAutoStarsForDifficulty(difficulty); 
        if (autoStars > 0) { setDifficultyStars(autoStars); return; 
        } else { 
            difficultyStars.visible = false; 
        }

        difficultyStars.visible = false;
    }

    // Returns computed stars (1..10) or 0 on failure 
    function computeAutoStarsForDifficulty(diff:Int):Int { 
        var prevSong:Dynamic = PlayState.SONG; 
        var stars:Int = 0;
        // Attempt to load the song chart for the chosen difficulty, count notes/sustains/events, 
        // compute notes-per-second and derive a star value heuristically. 
        try { 
            var songLowercase:String = Paths.formatToSongPath(song.songName);
            var poop:String = Highscore.formatSong(songLowercase, diff);

            Mods.currentModDirectory = song.folder;
            Song.loadFromJson(poop, songLowercase);

            var noteCount:Int = 0;
            var sustainCount:Int = 0;
            var eventsCount:Int = 0;

            if (PlayState.SONG != null) {
                if (PlayState.SONG.notes != null) {
                    for (section in PlayState.SONG.notes) {
                        if (section == null || section.sectionNotes == null) continue;
                        for (noteArr in section.sectionNotes) {
                            if (noteArr == null) continue;
                            var sustainVal:Float = 0;
                            if (noteArr.length > 2 && noteArr[2] != null) {
                                try { sustainVal = cast(noteArr[2], Float); } catch(_) {
                                    try { sustainVal = cast(noteArr[2], Int); } catch(_) { sustainVal = 0; }
                                }
                            }
                            if (sustainVal > 0) sustainCount++; else noteCount++;
                        }
                    }
                }
                if (PlayState.SONG.events != null) eventsCount = PlayState.SONG.events.length;
            }
        
            var totalNotes:Int = noteCount + sustainCount;
            if (totalNotes <= 0) {
                stars = 0;
            } else {
                // Determine duration
                var duration:Float = 0;
                try {
                    if (Reflect.hasField(PlayState.SONG, 'length')) duration = cast(Reflect.field(PlayState.SONG, 'length'), Float);
                    else if (Reflect.hasField(PlayState.SONG, 'songLength')) duration = cast(Reflect.field(PlayState.SONG, 'songLength'), Float);
                    else if (Reflect.hasField(PlayState.SONG, 'lengthInSeconds')) duration = cast(Reflect.field(PlayState.SONG, 'lengthInSeconds'), Float);
                } catch(_) { duration = 0; }
            
                if (duration <= 0) {
                    var lastTime:Float = 0;
                    if (PlayState.SONG != null && PlayState.SONG.notes != null) {
                        for (section in PlayState.SONG.notes) {
                            if (section == null || section.sectionNotes == null) continue;
                            for (noteArr in section.sectionNotes) {
                                if (noteArr == null || noteArr.length < 1) continue;
                                var t:Float = 0;
                                try { t = cast(noteArr[0], Float); } catch(_) {
                                    try { t = cast(noteArr[0], Int); } catch(_) { t = 0; }
                                }
                                if (t > lastTime) lastTime = t;
                                if (noteArr.length > 2 && noteArr[2] != null) {
                                    var sv:Float = 0;
                                    try { sv = cast(noteArr[2], Float); } catch(_) {
                                        try { sv = cast(noteArr[2], Int); } catch(_) { sv = 0; }
                                    }
                                    if (sv > 0) lastTime = Math.max(lastTime, t + sv);
                                }
                            }
                        }
                    }
                    duration = Math.max(1, lastTime);
                }
            
                var nps:Float = totalNotes / Math.max(1, duration);
            
                var score:Float = (nps * 3.5) + (sustainCount * 0.05) + (eventsCount * 0.02);
            
                stars = Std.int(Math.round(Math.max(1, Math.min(10, score))));
            }
        } catch(e:Dynamic) {
            // On any failure, return 0 (no stars)
            if (prevSong != null) {
                try { PlayState.SONG = prevSong; } catch(_) {}
            }
            return 0;
        }

        // Restore previous song if needed
        if (prevSong != null) {
            try { PlayState.SONG = prevSong; } catch(_) {}
        }

        return stars;
    }

    function setDifficultyText(?diff:String) {
        if (diffTextnecausetherewasnoimage != null) {
            diffTextnecausetherewasnoimage.text = diff.toUpperCase();
            diffTextnecausetherewasnoimage.screenCenter();
            diffTextnecausetherewasnoimage.y += 2;
            diffTextnecausetherewasnoimage.visible = true;
        }
    }

    var difficultySprites:Map<String, FlxSprite>;
    function buildDifficultySprite(?diff:String):Void
    {
        if (diff == null) diff = currentDifficultyId;
        remove(sprite);
        sprite = difficultySprites.get(diff);
        if (sprite == null)
        {
            sprite = new FlxSprite(0, 0);

            if (Paths.exists(Paths.file('images/menudifficulties/${diff}.xml')))
            {
                sprite.frames = Paths.getSparrowAtlas('menudifficulties/${diff}');
                sprite.animation.addByPrefix('idle', 'idle0', 24, true);
                if (ClientPrefs.data.flashing) sprite.animation.play('idle');
            }
            else
            {
                sprite.loadGraphic(Paths.image('menudifficulties/${diff}'));
            }

            difficultySprites.set(diff, sprite);
        }

        if (!Paths.exists(Paths.file('images/menudifficulties/${diff}.png'))) {
            sprite.visible = false;
            setDifficultyText(diff);
        } else if (diffTextnecausetherewasnoimage != null) diffTextnecausetherewasnoimage.visible = false;
        sprite.updateHitbox();
        sprite.screenCenter();
        add(sprite);
    }
}
