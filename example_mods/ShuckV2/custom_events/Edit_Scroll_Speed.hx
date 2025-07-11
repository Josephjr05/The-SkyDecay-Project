import psychlua.LuaUtils;
import Std;

function textSplit(str:String, delimiter:String) {
	var splitTxt:Array<String> = str.split(delimiter);
	for (i in 0...splitTxt.length) splitTxt[i] = StringTools.trim(splitTxt[i]);
	return splitTxt;
}

function checkVarData(variable:Dynamic, ifNull:Dynamic, shouldBe:Dynamic) {
	switch (variable) {
		case Int:
			var nullTest:Int = Std.parseInt(variable);
			return Std.isOfType(nullTest, Int) ? nullTest : ifNull;
		case Float:
			var nullTest:Float = Std.parseFloat(variable);
			return Std.isOfType(nullTest, Float) ? nullTest : ifNull;
		case String: return '' + variable;
		case Bool:
			if (Std.isOfType(variable, Bool)) return variable;
			else if (Std.isOfType(variable, String)) {
				var nullTest:String = StringTools.trim(variable.toLowerCase());
				if (nullTest == 'true') return true; // screw coding
				else if (nullTest == 'false') return false;
				return ifNull;
			} else if (Std.isOfType(variable, Int) || Std.isOfType(variable, Float)) {
				if (variable >= 1) return true; // screw coding
				else if (variable <= 0) return false;
				return ifNull; // jic
			} else return ifNull;
	}
	var nullTest:Dynamic = variable;
	if (variable == null || variable.length < 1) nullTest = ifNull;
	return nullTest;
}

setVar('baseSongSpeed', PlayState.SONG.speed);
setVar('multSongSpeed', 1);

function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
	if (songSpeedType == 'constant') return;
	switch (name) {
		case 'Edit Scroll Speed':
			var splitContents = {v1: textSplit(value1, ','), v2: textSplit(value2, ',')}

			var newSpeed:Float = Std.parseFloat(checkVarData(splitContents.v1[0], 1, Float));
			var isMult:Bool = checkVarData(splitContents.v1[1], true, Bool);
			var stepTime:Float = Std.parseFloat(checkVarData(splitContents.v2[0], 4, Float));
			var easeType:String = checkVarData(splitContents.v2[1], 'linear', String);

			if (isMult) setVar('multSongSpeed', newSpeed);
			else {
				setVar('baseSongSpeed', newSpeed);
				setVar('multSongSpeed', 1);
			}

			game.songSpeedTween = FlxTween.tween(game, {
				songSpeed: isMult ? getVar('baseSongSpeed') * ClientPrefs.getGameplaySetting('scrollspeed') * newSpeed : newSpeed
			}, (Conductor.stepCrochet / 1000) * stepTime / playbackRate, {
				ease: LuaUtils.getTweenEaseByString(easeType),
				onComplete: function () {
					game.songSpeedTween = null;
				}
			});
		case 'Change Scroll Speed':
			setVar('baseSongSpeed', PlayState.SONG.speed);
			setVar('multSongSpeed', checkVarData(value1, 1, Float));
	}
}