package states.editors.content;

import objects.Note;
import shaders.RGBPalette;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;

class MetaNote extends Note
{
	public static var noteTypeTexts:Map<Int, FlxText> = [];
	public var isEvent:Bool = false;
	public var songData:Array<Dynamic>;
	public var sustainSprite:EditorSustain;
	public var chartY:Float = 0;
	public var chartNoteData:Int = 0;
	public var sustainHeight:Float = 0;
	public var reverseScroll:Bool;
	// or idk what's the difference, public var reverseScroll = ChartingState.instance.reverseScroll;
	// all solutions i found will be commented  (that still break on Upscroll)

	public function new(time:Float, data:Int, songData:Array<Dynamic>)
	{
		super(time, data, null, false, true);
		this.songData = songData;
		this.strumTime = time;
		this.chartNoteData = data;
	}

	public override function reloadNote(tex:String = '', postfix:String = '') {
		super.reloadNote(tex, postfix);
		if (sustainSprite != null)
			sustainSprite.reloadNote(tex, postfix);
	}

	public function changeNoteData(v:Int)
	{
		this.chartNoteData = v; //despite being so arbitrary its sadly needed to fix a bug on moving notes
		this.songData[1] = v;
		this.noteData = v % ChartingState.GRID_COLUMNS_PER_PLAYER;
		this.mustPress = (v < ChartingState.GRID_COLUMNS_PER_PLAYER);
		
		if(!PlayState.isPixelStage)
			loadNoteAnims();
		else
			loadPixelNoteAnims();

		if(Note.globalRgbShaders.contains(rgbShader.parent)) //Is using a default shader
			rgbShader = new RGBShaderReference(this, Note.initializeGlobalRGBShader(noteData));

		animation.play(Note.colArray[this.noteData % Note.colArray.length] + 'Scroll');
		updateHitbox();
		if(width > height)
			setGraphicSize(ChartingState.GRID_SIZE);
		else
			setGraphicSize(0, ChartingState.GRID_SIZE);

		updateHitbox();
		if (sustainSprite != null)
			sustainSprite.changeNoteData(this.noteData);
	}

	public function setStrumTime(v:Float)
	{
		this.songData[0] = v;
		this.strumTime = v;
	}

	var _lastZoom:Float = -1;
	public function setSustainLength(v:Float, stepCrochet:Float, zoom:Float = 1, reverseScroll:Bool)
	{
		_lastZoom = zoom;
		v = Math.round(v / (stepCrochet / 2)) * (stepCrochet / 2);
		songData[2] = sustainLength = Math.max(Math.min(v, stepCrochet * 128), 0);

		if(sustainLength > 0)
		{
			if(sustainSprite == null)
			{
				sustainSprite = new EditorSustain(noteData); //new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
				sustainSprite.scrollFactor.x = 0;
			}
			// sustainSprite.reverseScroll = this.reverseScroll; 
			sustainSprite.sustainHeight = Math.max(ChartingState.GRID_SIZE/4, (Math.round((v * ChartingState.GRID_SIZE + ChartingState.GRID_SIZE) / stepCrochet) * zoom) - ChartingState.GRID_SIZE/2);
			sustainSprite.updateHitbox();
		}
	}

	public var hasSustain(get, never):Bool;
	function get_hasSustain() return (!isEvent && sustainLength > 0);

	public function updateSustainToZoom(stepCrochet:Float, zoom:Float = 1)
	{
		if(_lastZoom == zoom) return;
		setSustainLength(sustainLength, stepCrochet, zoom, reverseScroll);
	}

	public function updateSustainToStepCrochet(stepCrochet:Float)
	{
		if(_lastZoom < 0) return;
		setSustainLength(sustainLength, stepCrochet, _lastZoom, reverseScroll);
	}
	
	var _noteTypeText:FlxText;
	public function findNoteTypeText(num:Int)
	{
		var txt:FlxText = null;
		if(num != 0)
		{
			if(!noteTypeTexts.exists(num))
			{
				txt = new FlxText(0, 0, ChartingState.GRID_SIZE, (num > 0) ? Std.string(num) : '?', 16);
				txt.autoSize = false;
				txt.alignment = CENTER;
				txt.borderStyle = SHADOW;
				txt.shadowOffset.set(2, 2);
				txt.borderColor = FlxColor.BLACK;
				txt.scrollFactor.x = 0;
				noteTypeTexts.set(num, txt);
			}
			else txt = noteTypeTexts.get(num);
		}
		return (_noteTypeText = txt);
	}

	// function draw, i put sustainSprite.reverseScroll = this.reverseScroll ; and then flip the sustainSprite.y for reverseScroll with - sustainHeight like this:
		// sustainSprite.y = this.y + this.height/2 - sustainSprite.sustainHeight;
	// sometimes using - could work on this.height or the numbers but it still breaks.
	override function draw()
	{
		if(sustainSprite != null && sustainSprite.exists && sustainSprite.visible && sustainLength > 0)
		{
			if (sustainSprite.shader != shader) sustainSprite.shader = shader;
			sustainSprite.setColorTransform(colorTransform.redMultiplier, sustainSprite.colorTransform.blueMultiplier, colorTransform.redMultiplier);
			sustainSprite.scale.copyFrom(this.scale);
			sustainSprite.updateHitbox();
			sustainSprite.x = this.x + (this.width - sustainSprite.width)/2;
			sustainSprite.y = this.y + this.height/2;
			sustainSprite.alpha = this.alpha;
			sustainSprite.draw();
		}
		super.draw();

		if(_noteTypeText != null && _noteTypeText.exists && _noteTypeText.visible)
		{
			_noteTypeText.x = this.x + this.width/2 - _noteTypeText.width/2;
			_noteTypeText.y = this.y + this.height/2 - _noteTypeText.height/2;
			_noteTypeText.alpha = this.alpha;
			_noteTypeText.draw();
		}
	}

	override function destroy()
	{
		sustainSprite = FlxDestroyUtil.destroy(sustainSprite);
		super.destroy();
	}
}


class EditorSustain extends Note {
	var sustainTile:FlxSprite;
	public var sustainHeight:Float = 0;
	public var reverseScroll:Bool;

	public function new(data:Int) {
		sustainTile = new FlxSprite();
		sustainTile.scrollFactor.x = 0;

		super(0, data, null, true, true);

		animation.play(Note.colArray[noteData] + 'holdend');
		scale.set(scale.x, scale.x);
		updateHitbox();
		flipY = false;
	}
	override function update(elapsed:Float) {
		sustainTile.update(elapsed);
		super.update(elapsed);
	}
	// this is what pisses me off.
	// so y += sustainHeight and y -= sustainHeight are actually what flips the sustainTile downwards.
	// If you were to take out those lines, they'd flip upwards on reverseScroll. But sadly breaks it for upscroll.
	// i've done flipY on sustainTile, doesn't really make a difference.
	// I've made functions to separate the logic for drawing the sustain tile, but it still breaks on reverseScroll.
	// I've also tried separate classes for upscroll and downscroll, but it still breaks on reverseScroll.
	// So it's something to do with super.draw and how it handles the y position of the note itself in relation to the sustain tile.
	// If we can figure out a way to make it so super.draw can draw separately without breaking on reverseScroll, that would be great.
	// OH also, i have tried making a another sustainTile sprite under a different name. Did NOT work.
	override function draw() {
		if (!visible) return;

		if (sustainTile.shader != shader) sustainTile.shader = shader;
		sustainTile.setColorTransform(colorTransform.redMultiplier, colorTransform.blueMultiplier, colorTransform.redMultiplier);
		sustainTile.scale.x = this.scale.x;
		sustainTile.scale.y = sustainHeight;
		sustainTile.updateHitbox();
		sustainTile.alpha = this.alpha;
		sustainTile.setPosition(this.x, this.y - sustainHeight);
		sustainTile.draw();

		y += sustainHeight;
		super.draw();
		y -= sustainHeight;
	}

	public function reloadSustainTile() {
		sustainTile.frames = frames;
		sustainTile.antialiasing = antialiasing;
		sustainTile.animation.copyFrom(animation);
		sustainTile.animation.play(Note.colArray[this.noteData % Note.colArray.length] + 'hold');
		sustainTile.clipRect = new flixel.math.FlxRect(0, 1, sustainTile.frameWidth, 1);
	}
	public function changeNoteData(v:Int) {
		this.noteData = v;

		if (!PlayState.isPixelStage)
			loadNoteAnims();
		else
			loadPixelNoteAnims();

		reloadSustainTile();
		animation.play(Note.colArray[this.noteData % Note.colArray.length] + 'holdend');
	}
	public override function reloadNote(tex:String = '', postfix:String = '') {
		super.reloadNote(tex, postfix);
		reloadSustainTile();
	}
}

class EventMetaNote extends MetaNote
{
	public var eventText:FlxText;
	public function new(time:Float, eventData:Dynamic)
	{
		super(time, -1, eventData);
		this.isEvent = true;
		events = eventData[1];
		//trace('events: $events');
		
		loadGraphic(Paths.image('editors/eventIcon'));
		setGraphicSize(ChartingState.GRID_SIZE);
		updateHitbox();

		eventText = new FlxText(0, 0, 400, '', 12);
		eventText.setFormat(Paths.font('vcr.ttf'), 12, FlxColor.WHITE, RIGHT);
		eventText.scrollFactor.x = 0;
		updateEventText();
	}
	
	override function draw()
	{
		if(eventText != null && eventText.exists && eventText.visible)
		{
			eventText.y = this.y + this.height/2 - eventText.height/2;
			eventText.alpha = this.alpha;
			eventText.draw();
		}
		super.draw();
	}

	override function setSustainLength(v:Float, stepCrochet:Float, zoom:Float = 1, reverseScroll:Bool) {}

	public var events:Array<Array<String>>;
	public function updateEventText()
	{
		var myTime:Float = Math.floor(this.strumTime);
		if(events.length == 1)
		{
			var event = events[0];
			eventText.text = 'Event: ${event[0]} ($myTime ms)\nValue 1: ${event[1]}\nValue 2: ${event[2]}';
		}
		else if(events.length > 1)
		{
			var eventNames:Array<String> = [for (event in events) event[0]];
			eventText.text = '${events.length} Events ($myTime ms):\n${eventNames.join(', ')}';
		}
		else eventText.text = 'ERROR FAILSAFE';
	}

	override function destroy()
	{
		eventText = FlxDestroyUtil.destroy(eventText);
		super.destroy();
	}
}