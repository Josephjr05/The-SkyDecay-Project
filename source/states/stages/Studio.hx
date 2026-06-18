package states.stages;


import shaders.RadialBlur;
import flixel.util.FlxDestroyUtil;
import objects.FlxFixedText;
import shaders.Crt;
import openfl.filters.ShaderFilter;
import objects.Rain;

var bg:BGSprite;
var wall:BGSprite;
var floor:BGSprite;
var black:FlxSprite;
var collab:BGSprite;
var bases:BGSprite;
var planetshaper:BGSprite;

//low quality
var bgLQ:BGSprite;

//qyoh stuff
var stars:BGSprite;

// var lyrics:FlxFixedText;

var crt = new Crt();
var crtnoise:Bool = false;
var boom = new RadialBlur();

var gorl:objects.Character;

class Studio extends BaseStage {
	override function create() {
		if (ClientPrefs.data.lowQuality){
			bgLQ = new BGSprite('stages/camellia/studio/studioLQ', 100, -50);
			bgLQ.setGraphicSize(Std.int(bgLQ.width*2.5));
			add(bgLQ);
			return;
		}
		bg = new BGSprite('stages/camellia/studio/city', -200, -300, .5, .5);
		bg.setGraphicSize(Std.int(bg.width*1.55));
		add(bg);
		// switch(curSong){
		// 	case "sudden-shower"|"drenched-in-air"|"fly-wit-me":
		// 		for (i in 0...100){
		// 			var r:Rain = new Rain();
		// 			add(r);
		// 		}
		// 	case "r-u-still-xxxx":
		// 		planetshaper = new BGSprite("stages/camellia/planet/planetshaper", 300, -300);
		// 		planetshaper.setGraphicSize(Std.int(bg.width * .6));
		// 		add(planetshaper);
		// 	case "antineutrino-witchcraft":
		// 		stars = new BGSprite("stages/camellia/concert/qyoh/ninestars", 600, 200);
		// 		stars.setGraphicSize(Std.int(stars.width*4));
		// 		add(stars);
		// 		FlxTween.tween(stars, {angle: 360}, 5, {ease:FlxEase.backInOut, type:FlxTween.LOOPING});
		// }
		wall = new BGSprite('stages/camellia/studio/wall', -200, -300);
		wall.setGraphicSize(Std.int(wall.width*1.55));
		add(wall);

		floor = new BGSprite('stages/camellia/studio/FG_Floor', -200, -150, .9, .9);
		floor.setGraphicSize(Std.int(floor.width*1.55));
		add(floor);

		//default colors
		wall.color = 0xfffe00af;
		floor.color = 0xffac35b3;

		switch(songName) {
		case '+eraby+e-connec+10n':
			wall.color = 0xff00F99F;
			floor.color = 0xff32D6BF;
		case 'nuclear-star':
			wall.color = 0x4da6ff;
			floor.color = 0x0080ff;
		// 	case "ashed-wings":
		// 		black = new FlxSprite(0,0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		// 		black.alpha = 0;
		// 		// black.cameras = [camArrows];
		// 		add(black);
		// 		wall.color = 0xffdbdbdb; 
		// 		wall.color = 0xff9595bd;
		// 		if (ClientPrefs.data.shaders){
		// 			camGame.setFilters([new ShaderFilter(crt)]);
		// 			// camArrows.setFilters([new ShaderFilter(crt)]);
		// 			camHUD.setFilters([new ShaderFilter(crt)]);
		// 			crt.distortionOn.value = [false];
		// 			crt.perspectiveOn.value = [false];
		// 			crt.scanlinesOn.value = [false];
		// 			crt.vignetteOn.value = [false];
		// 		}
		// 		lyrics = new FlxFixedText(0,0,0,"",200);
		// 		lyrics.font = Paths.font("DANGER ZONE.ttf");
		// 		lyrics.cameras = [camOther];
		// 		lyrics.x = 400;
		// 		lyrics.y = 50;
		// 		add(lyrics);
		}
	}

	override function update(elapsed:Float) {
		if (crtnoise)
		crt.iTime.value = [elapsed];
	}

	// function stepHit() {
	// 	var cycle:Int = 1;
	// 	if (ClientPrefs.data.lowQuality)
	// 		return;
		// switch(curSong){
		// 	case "+eraby+e-connec+10n":
		// 		switch(curStep){
		// 			case 672|688|698|700|704|719|726|736|751|761|765|768|782|2880|2896|2905
		// 			|2908|2912|2928|2934|2944|2960|2969|2973|2976|2990|2993|2998:
		// 				stageFlashTerabyte();
		// 			case 928|3280:
		// 				for (i in [PlayState.boetrail,PlayState.girltrail, PlayState.snailtrail]){
		// 					i.active = true;
		// 					i.visible = true;
		// 				}
		// 			case 2271:
		// 				for (i in [PlayState.boetrail,PlayState.girltrail, PlayState.snailtrail]){
		// 					i.active = false;
		// 					i.visible = false;
		// 				}
		// 			case 4576:
		// 				for (anal in [dad, boyfriend, gf, wall, floor])
		// 					FlxTween.color(anal, 2, anal.color, 0xff000000);
		// 		}
		// }
	// }

	//fart
	function stageFlashTerabyte(){
		floor.color = 0xff00ffff;
		wall.color = 0xff00ffff;
			FlxTween.color(floor, 0.5, floor.color, 0xff32D6BF);
			FlxTween.color(wall, 0.5, wall.color, 0xff00F99F);
	}
	//stealth dash
	function stageFlashStealth(){
		floor.color = 0xffffffff;
		wall.color = 0xffffa54a;
			FlxTween.color(floor, 0.5, floor.color, 0xffb2b2b2);
			FlxTween.color(wall, 0.5, wall.color, 0xffe1750a);

	}
	//Antineutrino Witchcraft
	function stageFlashAntineutrino(){
		floor.color = 0xffff488e;
		wall.color = 0xffaa5c90;
			FlxTween.color(floor, 0.5, floor.color, 0xffe565ff);
			FlxTween.color(wall, 0.5, wall.color, 0xff6e005c);

	}
	//ashed wings :3
	function makeDark(){
		camHUD.flash(0xff000000, 0.5);
		wall.color = 0xff353536;
		floor.color = 0xff353536;
		boyfriend.color = 0xff474747;
		dad.color = 0xff474747;
		gf.color = 0xff474747;
	}
	function makeLight(){
		camHUD.flash(0xff000000, 0.5);
		wall.color = 0xffdbdbdb;
		floor.color = 0xff9595bd;
		boyfriend.color = 0xffffffff;
		dad.color = 0xffffffff;
		gf.color = 0xffffffff;
	}
}