package objects;

class Rain extends FlxSprite{
	public function new() {
		super();
		makeGraphic(5, 10, FlxColor.WHITE);
		resetSnowflake();
	}
	public function resetSnowflake():Void {
		angle = -16;
		x = FlxG.random.float(-500, FlxG.width+500);
		y = -500;
		scale.x = FlxG.random.float(0.5, 1.5);
		scale.y = FlxG.random.float(0.5, 3);
		velocity.y = FlxG.random.float(2000, 3000);
		velocity.x = 500/*FlxG.random.float(2000, 3000)*/;
		//trace("poop");
	}

	override function update(elapsed:Float)
	{
		x += velocity.x * elapsed;
		y += velocity.y * elapsed;
		if (y > FlxG.height)
			resetSnowflake();
	}
}