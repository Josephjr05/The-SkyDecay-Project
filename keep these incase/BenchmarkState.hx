package;

import flixel.FlxG;
import flixel.FlxState;
import model.objects.flixel.Flixel;

class BenchmarkState extends FlxState
{
	var daFlixelLogo:Flixel;

	override public function create()
	{
		super.create();

		daFlixelLogo = new Flixel();
		add(daFlixelLogo);
	}

	override function destroy()
	{
		super.destroy();
		daFlixelLogo.destroy();
	}
}
