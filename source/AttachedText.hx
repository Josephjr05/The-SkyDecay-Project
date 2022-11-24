package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class AttachedText extends Alphabet
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0, ?bold = false, ?scale:Float = 1) {
<<<<<<< HEAD
		super(0, 0, text, bold);

		this.scaleX = scale;
		this.scaleY = scale;
		this.isMenuItem = false;
=======
		super(0, 0, text, bold, false, 0.05, scale);
		isMenuItem = false;
>>>>>>> e08a47df190a58543331b227cb7eb17426863f65
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		super.update(elapsed);
	}
}