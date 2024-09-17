package states;

import objects.Note;
import objects.StrumNote;

import psychlua.HScript;

import backend.Conductor;

import states.PlayState;


var strumAnim:String = null;
var forceSet:Bool = false;

// Default
final COYOTE_TIME:Float = 1; // (60 FPS) forgiveness frames [ 0 + ]
final STEP_TIME:Float = 1; // stepCrochet forgiveness multiplier [ 0 to 1 ]
final STRETCH:Float = 1; // distance multiplier, more value = more forgiving [ 0 to 1 ]

// Release at hit, no forgiveness
// final COYOTE_TIME:Float = 0;
// final STEP_TIME:Float = 0;
// final STRETCH:Float = 0;


function getSustainHit(note:Note):Bool {
    for (i in note.tail) {
        if (!i.wasGoodHit)
            return false;
    }
    return true;
}

function lerp(from:Float, to:Float, i:Float):Float {
    return from + (to - from) * i;
}

var sustains:Array<Null<Float>> = [null, null, null, null];
function goodNoteHit(note:Note):Void {
    if (!note.isSustainNote) return;
    {   // debugPrint(getSustainHit(note.parent));
    	sustains[note.parent.noteData] = null; // don't worry about this, not needed technically but i have upcoming stuff with possible conflicts
    	sustains[note.noteData] = getSustainHit(note.parent) ? (note.strumTime + (COYOTE_TIME / 60 * 1000) + Conductor.stepCrochet * STEP_TIME) : null;
    }
}

final DIRECTIONS:Array<String> = ['left', 'down', 'up', 'right'];
var songPos:Float = 0;
function keyReleased(key:Int):Void {
    // debugPrint(sustains);
    for (i in 0...sustains.length) {
        if (sustains[i] != null) {
            if (songPos < Conductor.songPosition || Conductor.songPosition > 1000) // stupid check just because when the song ends it resets time i think
                songPos = Conductor.songPosition;

            var compareStrum:Float = lerp(songPos, sustains[i], STRETCH);
            var imagineDiff:Float = Math.max(0, compareStrum - sustains[i]); // you can release early, all good
            forceSet = ((imagineDiff > PlayState.instance.ratingsData[PlayState.instance.ratingsData.length - 2].hitWindow) || PlayState.instance.endingSong);
            // debugPrint('diff = ' + imagineDiff);

            if (forceSet) {
                var myStrum:StrumNote = PlayState.instance.playerStrums.members[i];
                strumAnim = myStrum.animation.curAnim.name;
            
                var uwu:Note = new Note(Conductor.songPosition + imagineDiff, i);
                uwu.noAnimation = true;
                goodNoteHit(uwu);
            
                if (!forceSet)
                    myStrum.playAnim(strumAnim);
                sustains[i] = null;   
            }
        }
    }
}

// function getNoteSustains(note) {
//     var arr:Array<Bool> = [];
//     for (i in note.tail) {
//         arr.push(i.wasGoodHit);
//     }
//     return arr;
// }

// var compareStrum:Float = lerp(Conductor.songPosition, sustains[i], STRETCH);
// var imagineDiff:Float = Math.max(0, compareStrum - sustains[i]); // you can release early, all good
// var forceSet:Bool = ((imagineDiff > game.ratingsData[game.ratingsData.length - 2].hitWindow) || game.endingSong);
// // debugPrint('diff = ' + imagineDiff);

// if (keyReleased(DIRECTIONS[i]) || forceSet) {
//    var myStrum:StrumNote = game.playerStrums.members[i];
//   var strumAnim:String = myStrum.animation.curAnim.name;

//  var uwu:Note = new Note(Conductor.songPosition + imagineDiff, i);
//  uwu.noAnimation = true;
//  game.goodNoteHit(uwu);

// if (!forceSet)
//     myStrum.playAnim(strumAnim);
// sustains[i] = null;
//