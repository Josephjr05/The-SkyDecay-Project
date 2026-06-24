package options;

import objects.Character;

import backend.ColorBlindness;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = Language.getPhrase('graphics_menu', 'Graphics Settings');
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		var option:Option = new Option('Color Filter: ', 
		'Choose your color blindness filter of your choice.', 
		'colorFilter', 
		STRING,
		['NONE', "DEUTERANOPIA", "PROTANOPIA", "TRITANOPIA"]);
		option.onChange = onChangeColorFilter;
		addOption(option);

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'antialiasing',
			BOOL);
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", //Description
			'shaders',
			BOOL);
		addOption(option);

		var option:Option = new Option('GPU Caching',
			"If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.",
			'cacheOnGPU',
			BOOL);
		addOption(option);

		var option:Option = new Option('GPU Functions',
			"If checked, allows the game to batch draw sprites, decreasing CPU usage.\nDon't turn this on if you have a shitty Graphics Card.",
			'gpuFunctions',
			BOOL);
		addOption(option);

		var option:Option = new Option('Framerate',
		"Set your desired FPS cap. Default matches your monitor refresh rate.",
		'framerateSetting',
		STRING,
		['Default', 'FPS60', 'FPS120', 'FPS144', 'FPS165', 'FPS240', 'UNLIMITED']);
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		addOption(option);

		// var option:Option = new Option('Light Cycle:',
		// "What Light Cycle should Camellia songs use?",
		// 'lightcycle',
		// STRING,
		// ['Auto Lights', 'Slow Lights', 'Player Lights', 'Disabled']);
		// addOption(option);

		super();
		insert(1, boyfriend);
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeColorFilter()
	{
		ColorBlindness.setFilter();
	}

	function onChangeFramerate() {
		var setting:String = Std.string(ClientPrefs.data.framerateSetting);
		trace("Selected FPS setting: " + setting);

		var fps:Int = switch (setting)
		{
			case "FPS60": 60;
			case "FPS120": 120;
			case "FPS144": 144;
			case "FPS165": 165;
			case "FPS240": 240;
			case "UNLIMITED": 999;
			case "DEFAULT": FlxG.stage.application.window.displayMode.refreshRate;
			default:
				trace("Invalid setting! Using default refresh rate.");
				FlxG.stage.application.window.displayMode.refreshRate;
		};

		FlxG.updateFramerate = fps;
		FlxG.drawFramerate = fps;
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}