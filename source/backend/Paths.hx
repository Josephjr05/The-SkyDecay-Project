package backend;

import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;

import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.System;
import openfl.geom.Rectangle;

import lime.utils.Assets;
import flash.media.Sound;

import haxe.Json;
import haxe.xml.Access;


#if MODS_ALLOWED
import backend.Mods;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	public static var savedTempMap:Map<String, {asset_type:AssetType, asset:Dynamic}> = new Map<String, {asset_type:AssetType, asset:Dynamic}>();
	public static var savedGraphicMap:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	public static var savedSoundMap:Map<String, Sound> = new Map<String, Sound>();
	public static var usedAssets:Array<String> = [];

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = ['assets/shared/music/freakyMenu.$SOUND_EXT'];
	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() {
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					// remove the key from all cache maps
					FlxG.bitmap._cache.remove(key);
					openfl.Assets.cache.removeBitmapData(key);
					currentTrackedAssets.remove(key);

					// and get rid of the object
					obj.persist = false; // make sure the garbage collector actually clears it up
					obj.destroyOnNoUse = true;
					obj.destroy();
				}
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory() {
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		for (key => asset in currentTrackedSounds)
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	static public var currentLevel:String;
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:Null<String> = null, ?modsAllowed:Bool = false):String
	{
		#if MODS_ALLOWED
		if(modsAllowed)
		{
			var customFile:String = file;
			if (library != null)
				customFile = '$library/$file';

			var modded:String = modFolders(customFile);
			if(FileSystem.exists(modded)) return modded;
		}
		#end

		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, 'week_assets', currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}
		}

		return getSharedPath(file);
	}

	static public function getLibraryPath(file:String, library = "shared")
	{
		return if (library == "shared") getSharedPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String, ?level:String)
	{
		if(level == null) level = library;
		var returnPath = '$library:assets/$level/$file';
		return returnPath;
	}

	inline public static function getSharedPath(file:String = '')
	{
		return 'assets/shared/$file';
	}

	inline static public function file(key:String, location:String, extension:String):String{

        var data:String = 'assets/$location/$key.$extension';
        return data;

    }

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function shaderFragment(key:String, ?library:String)
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}
	inline static public function shaderVertex(key:String, ?library:String)
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}
	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	static public function video(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsVideo(key);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/videos/$key.$VIDEO_EXT';
	}

	static public function sound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key, library);
		return sound;
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):Sound
	{
		var file:Sound = returnSound('music', key, library);
		return file;
	}

	inline static public function voices(song:String, postfix:String = null):Any
	{
		var songKey:String = '${formatToSongPath(song)}/Voices';
		if(postfix != null) songKey += '-' + postfix;
		//trace('songKey test: $songKey');
		var voices = returnSound(null, songKey, 'songs');
		return voices;
	}

	inline static public function inst(song:String):Any
	{
		var songKey:String = '${formatToSongPath(song)}/Inst';
		var inst = returnSound(null, songKey, 'songs');
		return inst;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	static public function image(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxGraphic
	{
		var bitmap:BitmapData = null;
		var file:String = null;

		#if MODS_ALLOWED
		file = modsImages(key);
		if (currentTrackedAssets.exists(file))
		{
			localTrackedAssets.push(file);
			return currentTrackedAssets.get(file);
		}
		else if (FileSystem.exists(file))
			bitmap = BitmapData.fromFile(file);
		else
		#end
		{
			file = getPath('images/$key.png', IMAGE, library);
			if (currentTrackedAssets.exists(file))
			{
				localTrackedAssets.push(file);
				return currentTrackedAssets.get(file);
			}
			else if (OpenFlAssets.exists(file, IMAGE))
				bitmap = OpenFlAssets.getBitmapData(file);
		}

		if (bitmap != null)
		{
			var retVal = cacheBitmap(file, bitmap, allowGPU);
			if(retVal != null) return retVal;
		}

		trace('oh no its returning null NOOOO ($file)');
		return null;
	}

	static public function cacheBitmap(file:String, ?bitmap:BitmapData = null, ?allowGPU:Bool = true)
	{
		if(bitmap == null)
		{
			#if MODS_ALLOWED
			if (FileSystem.exists(file))
				bitmap = BitmapData.fromFile(file);
			else
			#end
			{
				if (OpenFlAssets.exists(file, IMAGE))
					bitmap = OpenFlAssets.getBitmapData(file);
			}

			if(bitmap == null) return null;
		}

		localTrackedAssets.push(file);
		if (allowGPU && ClientPrefs.data.cacheOnGPU)
		{
			var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
			texture.uploadFromBitmapData(bitmap);
			bitmap.image.data = null;
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = BitmapData.fromTexture(texture);
		}
		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file);
		newGraphic.persist = true;
		newGraphic.destroyOnNoUse = false;
		currentTrackedAssets.set(file, newGraphic);
		return newGraphic;
	}

	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

		if (FileSystem.exists(getSharedPath(key)))
			return File.getContent(getSharedPath(key));

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(key, 'week_assets', currentLevel);
				if (FileSystem.exists(levelPath))
					return File.getContent(levelPath);
			}
		}
		#end
		var path:String = getPath(key, TEXT);
		if(OpenFlAssets.exists(path, TEXT)) return Assets.getText(path);
		return null;
	}

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/fonts/$key';
	}

	public static function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String = null)
	{
		#if MODS_ALLOWED
		if(!ignoreMods)
		{
			for(mod in Mods.getGlobalMods())
				if (FileSystem.exists(mods('$mod/$key')))
					return true;

			if (FileSystem.exists(mods(Mods.currentModDirectory + '/' + key)) || FileSystem.exists(mods(key)))
				return true;
			
			if (FileSystem.exists(mods('$key')))
				return true;
		}
		#end

		if(OpenFlAssets.exists(getPath(key, type, library, false))) {
			return true;
		}
		return false;
	}

	static public function getAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var useMod = false;
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);

		var myXml:Dynamic = getPath('images/$key.xml', TEXT, library, true);
		if(OpenFlAssets.exists(myXml) #if MODS_ALLOWED || (FileSystem.exists(myXml) && (useMod = true)) #end )
		{
			#if MODS_ALLOWED
			return FlxAtlasFrames.fromSparrow(imageLoaded, (useMod ? File.getContent(myXml) : myXml));
			#else
			return FlxAtlasFrames.fromSparrow(imageLoaded, myXml);
			#end
		}
		else
		{
			var myJson:Dynamic = getPath('images/$key.json', TEXT, library, true);
			if(OpenFlAssets.exists(myJson) #if MODS_ALLOWED || (FileSystem.exists(myJson) && (useMod = true)) #end )
			{
				#if MODS_ALLOWED
				return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, (useMod ? File.getContent(myJson) : myJson));
				#else
				return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, myJson);
				#end
			}
		}
		return getPackerAtlas(key, library);
	}

	inline static public function getSparrowAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var xmlExists:Bool = false;

		var xml:String = modsXml(key);
		if(FileSystem.exists(xml)) xmlExists = true;

		return FlxAtlasFrames.fromSparrow(imageLoaded, (xmlExists ? File.getContent(xml) : getPath('images/$key.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(imageLoaded, getPath('images/$key.xml', library));
		#end
	}

	inline static public function getPackerAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var txtExists:Bool = false;
		
		var txt:String = modsTxt(key);
		if(FileSystem.exists(txt)) txtExists = true;

		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, (txtExists ? File.getContent(txt) : getPath('images/$key.txt', library)));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(imageLoaded, getPath('images/$key.txt', library));
		#end
	}

	inline static public function getAsepriteAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		var imageLoaded:FlxGraphic = image(key, library, allowGPU);
		#if MODS_ALLOWED
		var jsonExists:Bool = false;

		var json:String = modsImagesJson(key);
		if(FileSystem.exists(json)) jsonExists = true;

		return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, (jsonExists ? File.getContent(json) : getPath('images/$key.json', library)));
		#else
		return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, getPath('images/$key.json', library));
		#end
	}

	inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static function returnSound(path:Null<String>, key:String, ?library:String) {
		#if MODS_ALLOWED
		var modLibPath:String = '';
		if (library != null) modLibPath = '$library/';
		if (path != null) modLibPath += '$path';

		var file:String = modsSounds(modLibPath, key);
		if(FileSystem.exists(file)) {
			if(!currentTrackedSounds.exists(file))
			{
				currentTrackedSounds.set(file, Sound.fromFile(file));
				//trace('precached mod sound: $file');
			}
			localTrackedAssets.push(file);
			return currentTrackedSounds.get(file);
		}
		#end

		// I hate this so god damn much
		var gottenPath:String = '$key.$SOUND_EXT';
		if(path != null) gottenPath = '$path/$gottenPath';
		gottenPath = getPath(gottenPath, SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		// trace(gottenPath);
		if(!currentTrackedSounds.exists(gottenPath))
		{
			var retKey:String = (path != null) ? '$path/$key' : key;
			retKey = ((path == 'songs') ? 'songs:' : '') + getPath('$retKey.$SOUND_EXT', SOUND, library);
			if(OpenFlAssets.exists(retKey, SOUND))
			{
				currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(retKey));
				//trace('precached vanilla sound: $retKey');
			}
		}
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}

	#if MODS_ALLOWED
	inline static public function mods(key:String = '') {
		return 'mods/' + key;
	}

	inline static public function modsFont(key:String) {
		return modFolders('fonts/' + key);
	}

	inline static public function modsJson(key:String) {
		return modFolders('data/' + key + '.json');
	}

	inline static public function modsVideo(key:String) {
		return modFolders('videos/' + key + '.' + VIDEO_EXT);
	}

	inline static public function modsSounds(path:String, key:String) {
		return modFolders(path + '/' + key + '.' + SOUND_EXT);
	}

	inline static public function modsImages(key:String) {
		return modFolders('images/' + key + '.png');
	}

	inline static public function modsXml(key:String) {
		return modFolders('images/' + key + '.xml');
	}

	inline static public function modsTxt(key:String) {
		return modFolders('images/' + key + '.txt');
	}

	inline static public function modsImagesJson(key:String) {
		return modFolders('images/' + key + '.json');
	}

	/* Goes unused for now

	inline static public function modsShaderFragment(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.frag');
	}
	inline static public function modsShaderVertex(key:String, ?library:String)
	{
		return modFolders('shaders/'+key+'.vert');
	}
	inline static public function modsAchievements(key:String) {
		return modFolders('achievements/' + key + '.json');
	}*/

	static public function modFolders(key:String) {
		if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0) {
			var fileToCheck:String = mods(Mods.currentModDirectory + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}

		for(mod in Mods.getGlobalMods()){
			var fileToCheck:String = mods(mod + '/' + key);
			if(FileSystem.exists(fileToCheck))
				return fileToCheck;
		}
		return 'mods/' + key;
	}
	#end

	#if flxanimate
	public static function loadAnimateAtlas(spr:FlxAnimate, folderOrImg:Dynamic, spriteJson:Dynamic = null, animationJson:Dynamic = null)
	{
		var changedAnimJson = false;
		var changedAtlasJson = false;
		var changedImage = false;
		
		if(spriteJson != null)
		{
			changedAtlasJson = true;
			spriteJson = File.getContent(spriteJson);
		}

		if(animationJson != null) 
		{
			changedAnimJson = true;
			animationJson = File.getContent(animationJson);
		}

		// is folder or image path
		if(Std.isOfType(folderOrImg, String))
		{
			var originalPath:String = folderOrImg;
			for (i in 0...10)
			{
				var st:String = '$i';
				if(i == 0) st = '';

				if(!changedAtlasJson)
				{
					spriteJson = getTextFromFile('images/$originalPath/spritemap$st.json');
					if(spriteJson != null)
					{
						//trace('found Sprite Json');
						changedImage = true;
						changedAtlasJson = true;
						folderOrImg = Paths.image('$originalPath/spritemap$st');
						break;
					}
				}
				else if(Paths.fileExists('images/$originalPath/spritemap$st.png', IMAGE))
				{
					//trace('found Sprite PNG');
					changedImage = true;
					folderOrImg = Paths.image('$originalPath/spritemap$st');
					break;
				}
			}

			if(!changedImage)
			{
				//trace('Changing folderOrImg to FlxGraphic');
				changedImage = true;
				folderOrImg = Paths.image(originalPath);
			}

			if(!changedAnimJson)
			{
				//trace('found Animation Json');
				changedAnimJson = true;
				animationJson = getTextFromFile('images/$originalPath/Animation.json');
			}
		}

		//trace(folderOrImg);
		//trace(spriteJson);
		//trace(animationJson);
		spr.loadAtlasEx(folderOrImg, spriteJson, animationJson);
	}

	private static function getContentFromFile(path:String):String // This should save text file then
	{
		var onAssets:Bool = false;
		var path:String = Paths.getPath(path, TEXT, true);
		if(FileSystem.exists(path) || (onAssets = true && Assets.exists(path, TEXT)))
		{
			trace('Found text: $path');
			return !onAssets ? File.getContent(path) : Assets.getText(path);
		}
		return null;
	}
	#end

	public static function clearUnusedAssets() {
		for(key in savedGraphicMap.keys()){
			if(usedAssets.contains(key)){continue;}

			var cur_asset = savedGraphicMap.get(key);
			if(cur_asset == null){continue;}

			@:privateAccess openfl.Assets.cache.removeBitmapData(key);
			@:privateAccess FlxG.bitmap._cache.remove(key);
			
			if(Reflect.hasField(cur_asset, 'destroy')){cur_asset.destroy();}
			savedGraphicMap.remove(key);
		}

		for(key in savedSoundMap.keys()){
			if(usedAssets.contains(key)){continue;}

			var cur_asset = savedSoundMap.get(key);
			if(cur_asset == null){continue;}

			@:privateAccess
				openfl.Assets.cache.removeSound(key);
			
			savedSoundMap.remove(key);
		}

		for(key in savedTempMap.keys()){
			if(usedAssets.contains(key)){continue;}

			var cur_asset = savedTempMap.get(key);
			if(cur_asset == null){continue;}

			@:privateAccess
				switch(cur_asset.asset_type){
					default:{}
					case FONT:{openfl.Assets.cache.removeFont(key);}
				}
			
			if(Reflect.hasField(cur_asset.asset, 'destroy')){cur_asset.asset.destroy();}
			savedTempMap.remove(key);
		}

		System.gc();
	}
	public static function clearMemoryAssets():Void {
		@:privateAccess
			for(key in FlxG.bitmap._cache.keys()){
				var cur_asset = FlxG.bitmap._cache.get(key);
				if(cur_asset == null || savedGraphicMap.exists(key)) {continue;}

				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				cur_asset.destroy();
			}

			for (key in savedSoundMap.keys()) {
				var cur_saved = savedSoundMap.get(key);
				if(cur_saved == null || usedAssets.contains(key)){continue;}

				openfl.Assets.cache.clear(key);
				savedSoundMap.remove(key);
			}

			for (key in savedTempMap.keys()) {
				var cur_saved = savedTempMap.get(key);
				if(cur_saved == null || usedAssets.contains(key)){continue;}

				savedTempMap.remove(key);
				if(Reflect.hasField(cur_saved.asset, 'destroy')){cur_saved.asset.destroy();}
			}

		usedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	public static function isSaved(file:String, ?asset_type:AssetType):Bool {
		switch(asset_type){
			default:{return savedTempMap.exists(file);}
			case IMAGE:{return savedGraphicMap.exists(file);}
			case SOUND, MUSIC:{return savedSoundMap.exists(file);}
		}
		return false;
	}
	public static function getSavedFile(file:String, ?asset_type:AssetType):Any {
		switch(asset_type){
			default:{if(savedTempMap.exists(file)){return savedTempMap.get(file).asset;}}
			case IMAGE:{if(savedGraphicMap.exists(file)){return savedGraphicMap.get(file);}}
			case SOUND, MUSIC:{if(savedSoundMap.exists(file)){return savedSoundMap.get(file);}}
		}
		return null;
	}
	inline static public function saveFile(file:String, instance:Any, ?asset_type:AssetType):Void {
		usedAssets.push(file);
		switch(asset_type){
			default:{savedTempMap.set(file, {asset_type: asset_type, asset: instance});}
			case IMAGE:{savedGraphicMap.set(file, instance);}
			case SOUND, MUSIC:{savedSoundMap.set(file, instance);}
		}
	}
	inline static public function unsaveFile(file:String, ?asset_type:AssetType):Void {
		switch(asset_type){
			default:{
				var asset = savedTempMap.get(file);
				if(asset == null){return;}
				savedTempMap.remove(file);
				if(Reflect.hasField(asset.asset, 'destroy')){asset.asset.destroy();}
			}
			case IMAGE:{
				var asset = savedGraphicMap.get(file);
				if(asset == null){return;}
				savedGraphicMap.remove(file);
				asset.destroy();
			}
			case SOUND, MUSIC:{
				var asset = savedSoundMap.get(file);
				if(asset == null){return;}
				savedSoundMap.remove(file);
			}
		}
	}

	inline public static function getSound(file:String):Sound {
		if(isSaved(file, SOUND)){return getSavedFile(file, SOUND);}
		// if(!Paths.exists(file)){return null;}
		saveFile(file, OpenFlAssets.exists(file) ? OpenFlAssets.getSound(file) : Sound.fromFile(file), SOUND);
		return getSavedFile(file, SOUND);
	}

	inline public static function getBytes(file:String):Any {
		if(isSaved(file, BINARY)){return getSavedFile(file, BINARY);}
		// if(!Paths.exists(file)){return null;}
		#if sys
		saveFile(file, OpenFlAssets.exists(file) ? OpenFlAssets.getBytes(file) : File.getBytes(file), BINARY);
		#else
		saveFile(file, OpenFlAssets.getBytes(file), BINARY);
		#end
		return getSavedFile(file, BINARY);
	}
	public static function getGraphic(file:String):Any {
		if(isSaved(file, IMAGE)){return getSavedFile(file, IMAGE);}
		// if(!Paths.exists(file)){return null;}
		var graphic:FlxGraphic = null;
		if(OpenFlAssets.exists(file)){
			graphic = FlxG.bitmap.add(file, false, file);
		}else{
			var bit:BitmapData = BitmapData.fromFile(file);
			if(bit == null){return file;}
			graphic = FlxGraphic.fromBitmapData(bit, false, file);
		}
		graphic.persist = true;
		saveFile(file, graphic, IMAGE);
		return getSavedFile(file, IMAGE);
	}
	inline public static function getText(file:String):String {
		if(isSaved(file, TEXT)){return getSavedFile(file, TEXT);}
		// if(!Paths.exists(file)){return null;}

		#if sys
		saveFile(file, OpenFlAssets.exists(file) ? OpenFlAssets.getText(file) : File.getContent(file), TEXT);
		#else
		saveFile(file, OpenFlAssets.getText(file), TEXT);
		#end
		return getSavedFile(file, TEXT);
	}
	
	inline static public function getJson(path:String):Dynamic {
		var text = getText(path);
		if(text == null){return null;}
		return Json.parse(text.trim());
	}
	
	public static function fromUncachedSparrow(Source:FlxGraphic, Description:String):FlxAtlasFrames {
        var graphic:FlxGraphic = FlxG.bitmap.add(Source);
        if(graphic == null || Description == null){return null;}
    
        var frames:FlxAtlasFrames = new FlxAtlasFrames(graphic);
        
        var data:Access = new Access(Xml.parse(Description).firstElement());
    
        for(texture in data.nodes.SubTexture){
            var name = texture.att.name;
            var trimmed = texture.has.frameX;
            var rotated = (texture.has.rotated && texture.att.rotated == "true");
            var flipX = (texture.has.flipX && texture.att.flipX == "true");
            var flipY = (texture.has.flipY && texture.att.flipY == "true");
    
            var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width), Std.parseFloat(texture.att.height));

            var size = if(trimmed){new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth), Std.parseInt(texture.att.frameHeight));}else{new Rectangle(0, 0, rect.width, rect.height);}
    
            var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;
    
            var offset = FlxPoint.get(-size.left, -size.top);
            var sourceSize = FlxPoint.get(size.width, size.height);
    
            if(rotated && !trimmed){sourceSize.set(size.height, size.width);}
    
            frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
        }
    
        return frames;
    }	
	public static function fromUncachedSpriteSheetPacker(Source:FlxGraphic, Description:String):FlxAtlasFrames {
		var graphic:FlxGraphic = FlxG.bitmap.add(Source);
        if(graphic == null || Description == null){return null;}
	
		var frames:FlxAtlasFrames = new FlxAtlasFrames(graphic);
	
		// if(Paths.exists(Description)){Description = getText(Description);}
	
		var pack = StringTools.trim(Description);
		var lines:Array<String> = pack.split("\n");
	
		for (i in 0...lines.length){
			var _frame_data = lines[i].split(":");

			var _name = StringTools.trim(_frame_data[0]);

			var _frame_region = StringTools.trim(_frame_data[1]).split(",");
			var _frame_size = StringTools.trim(_frame_data[2]).split(",");

			var _rect = FlxRect.get(Std.parseInt(_frame_region[0]), Std.parseInt(_frame_region[1]), Std.parseInt(_frame_region[2]), Std.parseInt(_frame_region[3]));

			var _size = new Rectangle(0, 0, _rect.width, _rect.height);
			if(_frame_size != null && _frame_size.length >= 4){_size = new Rectangle(Std.parseInt(_frame_size[0]), Std.parseInt(_frame_size[1]), Std.parseInt(_frame_size[2]), Std.parseInt(_frame_size[3]));}
			
			var _offset = FlxPoint.get(-_size.left, -_size.top);
			var _source_size = FlxPoint.get(_size.width, _size.height);

			frames.addAtlasFrame(_rect, _source_size, _offset, _name, FlxFrameAngle.ANGLE_0);
		}
	
		return frames;
	}
}
