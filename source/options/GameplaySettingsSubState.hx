package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//Shmuzo judgements:
		//Goated
		//Great
		//Good
		//Garbage

		//Kenju judgements:
		//God
		//Gold
		//Glory
		//Garbage (ideas for special sdpj builds)

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, the notes playfield will go Down of the screen instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes playfield will be centered.',
			'middleScroll',
			'bool');
		addOption(option);

		var option:Option = new Option('Show Opponent Notes',
			'If unchecked, opponent side notes get hidden.',
			'opponentStrums',
			'bool');
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit. (Recommended to leave on)",
			'ghostTapping',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically freezes if the screen isn't focused.\nWhich the mouse isn't on the game window",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset keybind won't do anything. (Is Recommended to turn on)",
			'noReset',
			'bool');
		addOption(option); // Reset key shouldn't really exist for this mod, should i just disable it?

		var option:Option = new Option('Results Screen',
		'If checked, Results Screen will show after passing a song',
		'resultsScreen',
		'bool');
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them.',
			'hitsoundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume; // Your keyboard should be your hitsounds are you joking?

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		//addOption(option); We don't need this lmao

		var option:Option = new Option('Marvelous!! Hit Window',
			'(This is LOCKED for SDPJ) -\nChanges the amount of time you have for hitting a "MARVELOUS!!" in milliseconds',
			'marvelousWindow',
			'int');
			option.displayFormat = '%vms';
			option.scrollSpeed = 5;
			option.minValue = 16;
			option.maxValue = 16; // 16 is the max value for a Marvelous (or rainbow 300) in Osu Mania no matter the OD.
			addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'(This is LOCKED for SDPJ) -\nChanges the amount of time you have for hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 40;
		option.maxValue = 40;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'(This is LOCKED for SDPJ) -\nChanges the amount of time you have for hitting a "Good" in milliseconds.',
			'goodWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 73;
		option.maxValue = 73;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'(This is LOCKED for SDPJ) -\nChanges the amount of time you have for hitting a "Bad" in milliseconds.',
			'badWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 127;
		option.maxValue = 127; //Should be harder to get a BAD now after TestPhasev1.
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'(This is LOCKED for SDPJ) -\nChanges how many frames you have for hitting a note earlier or late.',
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 10;
		option.maxValue = 10; // Safe frames should just be disabled cause why is this neccessary when inputs are how you hit a note early or late?
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Sustains as One Note',
			"If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.",
			'guitarHeroSustains',
			'bool');
		//addOption(option); 

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}