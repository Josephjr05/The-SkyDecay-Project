package cutscenes;

import haxe.Json;
import lime.utils.Assets;

typedef DialogueAnimArray = {
	var anim:String;
	var loop_name:String;
	var loop_offsets:Array<Int>;
	var idle_name:String;
	var idle_offsets:Array<Int>;
}

typedef DialogueCharacterFile = {
	var image:String;
	var dialogue_pos:String;
	var no_antialiasing:Bool;

	var animations:Array<DialogueAnimArray>;
	var position:Array<Float>;
	var scale:Float;
}

// A basically now reworked version of Character.hx, just for dialogue characters. 
// Since psych doesn't support multi-atlas for dialogue characters, i gotta do it manually. Lmfao.
// By Josephjr05 :D
class DialogueCharacter extends FlxSprite
{
	private static var IDLE_POSTFIX:String = '-IDLE';
	public static var DEFAULT_CHARACTER:String = 'bf';
	public static var DEFAULT_SCALE:Float = 0.7;

	public var jsonFile:DialogueCharacterFile = null;
	public var dialogueAnimations:Map<String, DialogueAnimArray> = new Map<String, DialogueAnimArray>();
	public var imageFile:String = '';

	public var startingPos:Float = 0; //For center characters, it works as the starting Y, for everything else it works as starting X
	public var isGhost:Bool = false; //For the editor
	public var curCharacter:String = 'bf';
	public var skiptimer = 0;
	public var skipping = 0;
	public function new(x:Float = 0, y:Float = 0, character:String = null)
	{
		super(x, y);

		if(character == null) character = DEFAULT_CHARACTER;
		changeCharacter(character);
	}

	public function changeCharacter(character:String)
	{
		curCharacter = character;
		reloadCharacterJson(character);
		loadDialogueFrames();
		reloadAnimations();

		antialiasing = ClientPrefs.data.antialiasing;
		if(jsonFile.no_antialiasing == true) antialiasing = false;
	}

	public static function getDialogueCharacterFile(character:String):DialogueCharacterFile
	{
		var characterPath:String = 'images/dialogue/' + character + '.json';

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(characterPath);
		if (!FileSystem.exists(path))
			path = Paths.getSharedPath(characterPath);

		if(!FileSystem.exists(path))
			path = Paths.getSharedPath('images/dialogue/' + DEFAULT_CHARACTER + '.json');
		return cast Json.parse(File.getContent(path));
		#else
		var path:String = Paths.getSharedPath(characterPath);
		if (!Assets.exists(path))
			path = Paths.getSharedPath('images/dialogue/' + DEFAULT_CHARACTER + '.json');
		return cast Json.parse(Assets.getText(path));
		#end
	}

	public function reloadCharacterJson(character:String)
	{
		curCharacter = character;
		jsonFile = getDialogueCharacterFile(character);
	}

	public function loadDialogueFrames(?json:DialogueCharacterFile = null)
	{
		if(json != null) jsonFile = json;

		imageFile = getDialogueImagePath(jsonFile.image);
		frames = Paths.getMultiAtlas(imageFile.split(','));
	}

	inline function getDialogueImagePath(image:String):String
	{
		var images:Array<String> = [];
		for (img in image.split(','))
		{
			var trimmed:String = img.trim();
			if(trimmed.length < 1) continue;
			if(trimmed.indexOf('dialogue/') == 0)
				images.push(trimmed);
			else
				images.push('dialogue/' + trimmed);
		}
		return images.length > 0 ? images.join(',') : 'dialogue/' + DEFAULT_CHARACTER;
	}

	public static function getDialogueCharacterList():Array<String>
	{
		var characterList:Array<String> = [];
		#if MODS_ALLOWED
		var foldersToCheck:Array<String> = Mods.directoriesWithFile(Paths.getSharedPath(), 'images/dialogue/');
		for (folder in foldersToCheck)
			scanDialogueFolder(folder, '', characterList);
		#else
		#if sys
		var folder:String = Paths.getSharedPath('images/dialogue/');
		if(FileSystem.exists(folder))
			scanDialogueFolder(folder, '', characterList);
		#end
		#end

		if(characterList.length < 1) characterList.push(DEFAULT_CHARACTER);
		return characterList;
	}

	// Actual scan folders function for dialogue characters, referenced from Character.hx.
	#if (MODS_ALLOWED || sys)
	static function scanDialogueFolder(directory:String, prefix:String, list:Array<String>)
	{
		if(!FileSystem.exists(directory)) return;

		for (file in FileSystem.readDirectory(directory))
		{
			var path:String = haxe.io.Path.join([directory, file]);
			if(FileSystem.isDirectory(path))
			{
				var newPrefix:String = prefix.length > 0 ? '$prefix/$file' : file;
				scanDialogueFolder(path, newPrefix, list);
			}
			else if(file.toLowerCase().endsWith('.json'))
			{
				var charName:String = file.substr(0, file.length - 5);
				if(prefix.length > 0) charName = '$prefix/$charName';
				if(!list.contains(charName))
					list.push(charName);
			}
		}
	}
	#end

	public static function characterJsonExists(character:String):Bool
	{
		var characterPath:String = 'images/dialogue/' + character + '.json';
		#if MODS_ALLOWED
		return FileSystem.exists(Paths.getPath(characterPath, TEXT, null, true));
		#else
		return Assets.exists(Paths.getSharedPath(characterPath));
		#end
	}

	public function reloadAnimations()
	{
		dialogueAnimations.clear();
		if(jsonFile.animations != null && jsonFile.animations.length > 0)
		{
			for (anim in jsonFile.animations)
			{
				animation.addByPrefix(anim.anim, anim.loop_name, 24, isGhost);
				animation.addByPrefix(anim.anim + IDLE_POSTFIX, anim.idle_name, 24, true);
				dialogueAnimations.set(anim.anim, anim);
			}
		}
	}

	public function playAnim(animName:String = null, playIdle:Bool = false)
	{
		var leAnim:String = animName;
		if(animName == null || !dialogueAnimations.exists(animName))
		{ //Anim is null, get a random animation
			var arrayAnims:Array<String> = [];
			for (anim in dialogueAnimations)
				arrayAnims.push(anim.anim);

			if(arrayAnims.length > 0)
				leAnim = arrayAnims[FlxG.random.int(0, arrayAnims.length - 1)];
		}

		if(dialogueAnimations.exists(leAnim) &&
		(dialogueAnimations.get(leAnim).loop_name == null ||
		dialogueAnimations.get(leAnim).loop_name.length < 1 ||
		dialogueAnimations.get(leAnim).loop_name == dialogueAnimations.get(leAnim).idle_name))
			playIdle = true;

		animation.play(playIdle ? leAnim + IDLE_POSTFIX : leAnim, false);

		if(dialogueAnimations.exists(leAnim))
		{
			var anim:DialogueAnimArray = dialogueAnimations.get(leAnim);
			if(playIdle)
				offset.set(anim.idle_offsets[0], anim.idle_offsets[1]);
			else
				offset.set(anim.loop_offsets[0], anim.loop_offsets[1]);
		}
		else
		{
			offset.set(0, 0);
			trace('Offsets not found! Dialogue character is badly formatted, anim: ' + leAnim + ', ' + (playIdle ? 'idle anim' : 'loop anim'));
		}
	}

	public function animationIsLoop():Bool
	{
		if(animation.curAnim == null) return false;
		return !animation.curAnim.name.endsWith(IDLE_POSTFIX);
	}
}
