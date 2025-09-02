import psychlua.LuaUtils;

var options = {
	alphaToSubtract: 0.3,
	blendMode: 'add',
	fadeTime: 0.2,
	easeType: 'expoIn'
}

var getCharFromString = function(name:String) {
	switch (name) {
		case 'dad': return game.dad;
		case 'gf': return game.gf != null ? game.gf : (daNote.mustPress ? game.boyfriend : game.dad);
		case 'boyfriend': return game.boyfriend;
		case '': return null;
		default: return getVar(name);
	}
	return null;
}
function jumpCheck(daNote:Note, setChar:String, ?useFakeNoAnim:Bool = false) {
	if (!daNote.isSustainNote) {
		final char:Character = getCharFromString(setChar); if (char == null) return;
		final prevNote:Note = char.extraData.exists('prevNote') ? char.extraData.get('prevNote') : null;
		final noAnim:Bool = useFakeNoAnim ? (daNote.extraData.exists('noAnimation') ? daNote.extraData.get('noAnimation') : false) : daNote.noAnimation;
		final prevNoAnim:Bool = prevNote == null ? !useFakeNoAnim : (useFakeNoAnim ? (prevNote.extraData.exists('noAnimation') ? prevNote.extraData.get('noAnimation') : false) : prevNote.noAnimation);
		if (prevNote != null && ((!noAnim && prevNoAnim) || (noAnim && !prevNoAnim) || (!noAnim && !prevNoAnim))) {
			if (prevNote.strumTime == daNote.strumTime && prevNote.noteData != daNote.noteData) {
				final setNote:Note = prevNote.sustainLength > daNote.sustainLength ? daNote : prevNote;
				setNote.extraData.set('noAnimation', true);
				setNote.noAnimation = true;
				for (susNote in setNote.tail) {
					susNote.extraData.set('noAnimation', true);
					susNote.noAnimation = true;
				}
				// if (setNote == prevNote) char.playAnim(game.singAnimations[setNote.noteData] + setNote.animSuffix, true);
				createAfterImage(setChar, setNote);
			}
		}
		char.extraData.set('prevNote', daNote);
	}
	if (daNote.extraData.exists('afterImage') && daNote.extraData.get('afterImage') != null) {
		final afterImage:Character = daNote.extraData.get('afterImage');
		if (!afterImage.stunned) {
			afterImage.playAnim(game.singAnimations[daNote.noteData] + daNote.animSuffix, true);
			afterImage.holdTimer = 0;
		}
	}
}
// Normal note hits.
function opponentNoteHitPre(daNote:Note) jumpCheck(daNote, daNote.gfNote ? 'gf' : 'dad');
function goodNoteHitPre(daNote:Note) jumpCheck(daNote, daNote.gfNote ? 'gf' : 'boyfriend');
// Extra for vs impostor stuff I'm working on.
function gfNoteHitPre(daNote:Note) jumpCheck(daNote, 'gf');
function momNoteHitPre(daNote:Note) jumpCheck(daNote, 'mom');
// For extra character script.
function extraNoteHitPre(daNote:Note, setChar:Dynamic, isPlayerNote:Bool) jumpCheck(daNote, setChar.name, true);
function otherStrumHitPre(daNote:Note, strumLane) jumpCheck(daNote, strumLane.attachmentVar == 'gfNote' ? 'gf' : '');

// decided to make it not kill it because the game would yell at you after hitting a note with the dead after image... even tho there are NULL CHECKS
function killAfterImage(daNote:Note) {
	if (daNote.extraData.exists('afterImage') && daNote.extraData.get('afterImage') != null) {
		final afterImage:Character = daNote.extraData.get('afterImage');
		FlxTween.tween(afterImage.colorTransform, {alphaMultiplier: 0}, (options.fadeTime / 2) / game.playbackRate, {ease: LuaUtils.getTweenEaseByString(options.easeType)});
		afterImage.playAnim(game.singAnimations[daNote.noteData] + (afterImage.hasMissAnimations ? 'miss' : '') + daNote.animSuffix, true);
		afterImage.stunned = true;
	}
}
function noteMiss(daNote:Note) killAfterImage(daNote);
function opponentNoteMiss(daNote:Note) killAfterImage(daNote); // jic
function extraNoteMiss(daNote:Note, setChar:Dynamic, isPlayerNote:Bool) killAfterImage(daNote);

function createAfterImage(char:String, daNote:Note) {
	final mainChar:Character = getCharFromString(char);
	if (mainChar == null || !mainChar.visible || mainChar.alpha < 1 || daNote.extraData.exists('afterImage')) return;

	var groupCheck = function(char:Character) {
		switch (char) {
			case game.dad: return game.dadGroup;
			case game.gf: return game.gfGroup;
			case game.boyfriend: return game.boyfriendGroup;
			default: return char;
		}
		return;
	}
	var afterImage:Character = new Character(mainChar.x, mainChar.y, mainChar.curCharacter, mainChar.isPlayer);
	afterImage.camera = mainChar.camera;
	insert(game.members.indexOf(groupCheck(mainChar)), afterImage);

	// Tell me if there's anything else I should add!
	afterImage.flipX = mainChar.flipX;
	afterImage.flipY = mainChar.flipY;
	afterImage.scale.x = mainChar.scale.x; // would've done copyFrom if it wouldn't fucking crash
	afterImage.scale.y = mainChar.scale.y;
	afterImage.alpha = mainChar.alpha - options.alphaToSubtract;
	afterImage.shader = mainChar.shader;
	afterImage.blend = LuaUtils.blendModeFromString(options.blendMode);

	afterImage.skipDance = true; // prevent after image from going idle
	afterImage.color = FlxColor.fromRGB(mainChar.healthColorArray[0] + 50, mainChar.healthColorArray[1] + 50, mainChar.healthColorArray[2] + 50);
	if (!afterImage.stunned) { // jic
		afterImage.playAnim(game.singAnimations[daNote.noteData] + daNote.animSuffix, true);
		afterImage.holdTimer = 0;
	}
	
	daNote.extraData.set('afterImage', afterImage); // funny sustain shit
	for (susNote in daNote.tail) susNote.extraData.set('afterImage', afterImage);
	FlxTween.tween(afterImage, {alpha: 0}, options.fadeTime / game.playbackRate, {
		ease: LuaUtils.getTweenEaseByString(options.easeType),
		startDelay: ((daNote.sustainLength / 1000) - (options.fadeTime / 2)) / game.playbackRate,
		onComplete: function(_) {
			daNote.extraData.remove('afterImage'); // jic
			for (susNote in daNote.tail) susNote.extraData.remove('afterImage');
			afterImage.kill();
			afterImage.destroy();
		}
	});
}