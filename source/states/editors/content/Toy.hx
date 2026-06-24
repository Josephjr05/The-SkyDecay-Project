// a native psych version of the class from Psych Engine Mint. I loved my memory leaking but stuff has to change now.

package states.editors.content;

import objects.Character;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;

enum abstract ToySide(String) to String {
	var GF = 'gf';
	var PLAYER = 'player';
	var OPPONENT = 'opponent';
}

class Toy extends Character {
	public var side:ToySide;
	public var holdSingTimer:Float = 0;
	
	public function new(x:Float, y:Float, ?character:String, side:ToySide = PLAYER) {
		this.side = side;
		super(x, y, character, side == PLAYER);
		scaleTo(.4); // Default editor scale
	}
	
	public override function changeCharacter(newCharacter:String):Void {
		// CRITICAL: If the character is already this one, do nothing. 
		// This prevents the memory leak from repeated spawning.
		if (curCharacter == newCharacter && frames != null) return;
		
		super.changeCharacter(newCharacter);
		
		// Maintain side-specific flipping
		if(side == PLAYER) flipX = !flipX; 
		
		scaleTo(.4);
		dance();
	}
	
	public function scaleTo(targetScale:Float = 1):Void {
		scale.set(jsonScale * targetScale, jsonScale * targetScale);
		updateHitbox();
		
		// Recalculate offsets based on the new scale
		for (key in animOffsets.keys()) {
			animOffsets[key][0] *= (scale.x / jsonScale);
			animOffsets[key][1] *= (scale.y / jsonScale);
		}
	}

	public function applyJsonPosition(baseX:Float, baseY:Float) {
		var pos = (chartArray != null) ? chartArray : positionArray;
		setPosition(baseX + pos[0], baseY + pos[1]);
	}
	
	public override function update(elapsed:Float):Void {
		if (holdSingTimer > 0) {
			holdSingTimer -= elapsed;
			if (holdSingTimer <= 0) holdSingTimer = 0;
			holdTimer = 0;
		}
		super.update(elapsed);
	}
	
	public function holdSing(anim:String, time:Float = 0):Void {
		holdSingTimer = Math.max(holdSingTimer, time);
		holdTimer = 0;
		playAnim(anim, true);
	}
}