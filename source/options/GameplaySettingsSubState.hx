package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('gameplay_menu', 'Gameplay Settings');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			BOOL);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			BOOL);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			BOOL);
		addOption(option);

		var option:Option = new Option('Results Screen',
		'If checked, Results Screen will show after passing a song',
		'resultsScreen',
		BOOL);
		addOption(option);

		var option:Option = new Option('Groovin Results',
		'If checked, Results Screen from Graffiti Groovin will show after passing a song',
		'resultsGroovin',
		BOOL);
		addOption(option);

		var option:Option = new Option('Opponent Lane Underlay Visibility',
		'Sets visibility of opponent\'s lane underlay.',
		'opponentUnderlaneVisibility',
		PERCENT);	
		option.scrollSpeed = 1;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Lane Underlay Visibility',
			'Sets visibility of lane underlay.',
			'underlaneVisibility',
			PERCENT);	
		option.scrollSpeed = 1;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Base Game Activation',
		'If checked, Base Game elements will take effect.',
		'BaseGame',
		BOOL);
		// addOption(option);

		var option:Option = new Option('Combo Burst GF Edition',
		'If checked, every 100 combo you hit, GF will cheer \nlike in Etterna or Osu',
		'comboBurst',
		BOOL);
		addOption(option);
		
		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			BOOL);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			BOOL);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them.',
			'hitsoundVolume',
			PERCENT);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		// addOption(option);

		var option:Option = new Option('PERFECT Hit Window',
			'(This is LOCKED for SDPJ) -\nPERFECT',
			'perfectWindow',
			FLOAT);
			option.displayFormat = '%vms';
			option.scrollSpeed = 5;
			option.minValue = 16;
			option.maxValue = 16; // 16 is the max value for a Marvelous (or rainbow 300) in Osu Mania no matter the OD.
			option.changeValue = 0.1;
			option.decimals = 2;
			addOption(option);

		var option:Option = new Option('Great Hit Window',
			'(This is LOCKED for SDPJ) -\nGREAT',
			'greatWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 43;
		option.maxValue = 43;
		option.changeValue = 0.1;
		option.decimals = 2;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'(This is LOCKED for SDPJ) -\nGood',
			'goodWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 76;
		option.maxValue = 76;
		option.changeValue = 0.1;
		option.decimals = 2;
		addOption(option);

		var option:Option = new Option('Ok Hit Window',
			'(This is LOCKED for SDPJ) -\nOk',
			'okWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 106;
		option.maxValue = 106; //Should be harder to get a BAD now after TestPhasev1.
		option.changeValue = 0.1;
		option.decimals = 2;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'(This is LOCKED for SDPJ) -\nSafe Frames (Input Window)',
			'safeFrames',
			FLOAT);
		option.scrollSpeed = 5;
		option.minValue = 10;
		option.maxValue = 10;
		option.changeValue = 0.1;
		// addOption(option); // why exactly?

		var option:Option = new Option('Sustains as One Note',
			"If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.",
			'guitarHeroSustains',
			BOOL);
		// addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}