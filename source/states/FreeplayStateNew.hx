package states;

import backend.WeekData;

import objects.HealthIcon;
import states.editors.ChartingState.AttachedFlxText;

class SongBox extends FlxSprite {
    public var icon:String;
    public var category:String;
    public var name:String;
    public var artist:String;

    public function new(icon:String, category:String, name:String, composer:String)
    {
        super();

        this.icon = icon;
        this.category = category;
        this.name = name;
        artist = composer;

        loadGraphic(Paths.image('freeplay/bars/background${FlxG.random.int(1, 2)}'));
        setGraphicSize(700, 105);
        updateHitbox();
    }
}

class FreeplayStateNew extends MusicBeatState {
    //songs
    var songs:Array<Songs> = [];

    //grps
    var boxes:FlxTypedGroup<SongBox> = new FlxTypedGroup<SongBox>();
    var other:FlxTypedGroup<Dynamic> = new FlxTypedGroup<Dynamic>();

    //variables like currentSelected, etc.
    var curSelected:Int = 0;
    var holdTime:Float = 0;

    //variables like vocals
    public static var vocals:FlxSound = null;

    override function create() {

        FlxG.mouse.visible = true;
        persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff646464);
		add(bg);

        for (i in 0...WeekData.weeksList.length) {
            var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];

			if(leWeek.hideFreeplay) continue;

            for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[3];
				if(colors == null || colors.length < 3)
					colors = [146, 113, 253];

                var songName = song[0];
                var category = leWeek.fileName;
                var icon = song[1];
                var composer = song[2];
                if(composer.length == 0 || composer == null) composer = 'Unknown';

                songs.push(new Songs(songName, category, icon, composer, colors));
			}
        }

        add(boxes);
        add(other);

        for(i in 0...songs.length) {
            var songBox:SongBox = new SongBox(songs[i].icon, songs[i].songCategory, songs[i].songName, songs[i].artist);
            songBox.screenCenter();
            songBox.x += 420;
            songBox.y = 307.5 + ((i - 3) * 88);
            songBox.ID = i;
            boxes.add(songBox);

            var healthIcon = new HealthIcon(songBox.icon, false);
            healthIcon.scale.set(0.6, 0.6);
            healthIcon.sprTracker = songBox;
            healthIcon.xAdd = -730;
            healthIcon.yAdd = 7;
            other.add(healthIcon);

            //may use this to smallen the text loading
            // for(easy in [songBox.category, songBox.artist, songBox.name])
            //     trace(easy);

            var text:AttachedFlxText = new AttachedFlxText(0, 0, FlxG.width / 2, songBox.category, 20);
            text.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.GRAY, LEFT);
            text.sprTracker = songBox;
            text.yAdd = 7;
            text.xAdd = 110;
            other.add(text);

            var text:AttachedFlxText = new AttachedFlxText(0, 0, FlxG.width / 2, songBox.artist, 20);
            text.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.GRAY, LEFT);
            text.sprTracker = songBox;
            text.yAdd = 32;
            text.xAdd = 110;
            other.add(text);

            var text:AttachedFlxText = new AttachedFlxText(0, 0, FlxG.width / 2, songBox.name , 20);
            text.setFormat(Paths.font("vcr.ttf"), 30, 0xffdddddd, LEFT);
            text.sprTracker = songBox;
            text.yAdd = 60;
            text.xAdd = 110;
            other.add(text);
        }
    }

    function changeSong(change:Int = 0)
	{
		curSelected += change;

		if(curSelected > songs.length - 1)
			curSelected = 0;
		if(curSelected < 0)
			curSelected = songs.length - 1;
	}

    var isHover:Bool = false;
    var listRow:Int = 0;
    override function update(elapsed:Float)
    {
        //logic for the boxes x position
        for(box in boxes) box.x = FlxMath.lerp(box.x, box.ID == curSelected? 710 : 810, FlxMath.bound(elapsed * 9, 0, 1));
        for(box in boxes) box.y = FlxMath.lerp(box.y, 307.5 + ((box.ID - listRow - 3) * 88), FlxMath.bound(elapsed * 9, 0, 1));

        //Fuck this i'm removing all support except mouse support

        isHover = false;

        for(box in boxes) {
            if(FlxG.mouse.overlaps(box)) {
                curSelected = box.ID;
                isHover = true;
            }
            if(!isHover && !FlxG.mouse.overlaps(box) && box.ID == boxes.length - 1)
                curSelected = -1;
        }

        if(FlxG.mouse.justPressed && curSelected != -1)
            chooseSong();

        if(FlxG.mouse.wheel != 0 && boxes.length > 7)
            listRow += -FlxG.mouse.wheel;

        if(listRow < 0) listRow = 0;
        if(listRow > boxes.length - 7) listRow = boxes.length - 7;

        super.update(elapsed);
    }

    function chooseSong()
    {
        
    }

    public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}

class Songs
{
	public var songName:String;
    public var songCategory:String;
    public var icon:String;
    public var artist:String;
    public var color:Array<Int>;

	public function new(name:String, category:String, icon:String, artist:String, color:Array<Int>)
	{
        songName = name;
        songCategory = category;
        this.icon = icon;
        this.artist = artist;
        this.color = color;
	}
}

//i fucking hate making this state