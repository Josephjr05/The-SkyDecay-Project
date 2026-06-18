package states.stages.objects;

import flixel.math.FlxPoint;

class Speakers extends BGSprite {

    public var isVisible(get, never):Bool;
	inline function get_isVisible() {
		return visible && alpha >= 1/255;
	}

    public function new(x:Float, y:Float, isBig:Bool, onTheRight:Bool, hasReflections:Bool) {
        super('stages/camellia/concert/speaker',x, y, 1, 1, ['speaker'], false);
        if(isBig)
            setGraphicSize(Std.int(this.width*.75));
        else
            setGraphicSize(Std.int(this.width*.5));

        this.flipX = onTheRight?true:false;
        reflectionAlpha = hasReflections && ClientPrefs.data.shaders ? 0.5 : 0;
        reflectionY = isBig ? 580 : 380;
        antialiasing = ClientPrefs.data.antialiasing;
    }

    /**
    * Plays the speaker "bump" animation.
    */
    public function playMe() {
        if (animation.getByName('speaker') != null) {
            animation.play('speaker', true);
        }
    }

    public var reflectionAlpha:Float = 0;
    public var reflectionY:Float = 0;
    public var reflectionX:Float = 0;
    public var reflectionOffsets:Map<String, FlxPoint> = [];
    public var reflectionOffset = new FlxPoint();

	var olda:Float;
	var oldsy:Float;
	var oldoy:Float;

    override function draw() {
        if(reflectionAlpha > 0 && isVisible) {
            var olda = alpha;
            var oldsy = scale.y;
            alpha *= reflectionAlpha;
            x += reflectionX;
            y += reflectionY;
            scale.y = -scale.y;
            var oldoy = offset.y;
            offset.y = 0;
            y += oldoy;
            x += reflectionOffset.x;
            y += reflectionOffset.y;
            super.draw();
            x -= reflectionOffset.x;
            y -= reflectionOffset.y;
            y -= oldoy;
            offset.y = oldoy;
            scale.y = oldsy;
            y -= reflectionY;
            x -= reflectionX;
            alpha = olda;
        }
        super.draw();
    }
}