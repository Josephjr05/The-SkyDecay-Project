import objects.Note;
import objects.StrumNote;

// Script by subpurr [subpurrowo in discord], do not use without credit
// Can be used without explicit permission. suffer :3

// CONFIG & PRESETS:

// Default
final COYOTE_TIME:Float = 0.5; // (60 FPS) forgiveness frames [ 0 + ]
final STEP_TIME:Float = 0.5; // stepCrochet forgiveness multiplier [ 0 to 1 ]
final STRETCH:Float = 0.5; // distance multiplier, more value = more forgiving [ 0 to 1 ]

// Release at hit, no forgiveness
// final COYOTE_TIME:Float = 0;
// final STEP_TIME:Float = 0;
// final STRETCH:Float = 0;

// A step later, maybe
// final COYOTE_TIME:Float = 0;
// final STEP_TIME:Float = 1;
// final STRETCH:Float = 0;

// A little more fair
// final COYOTE_TIME:Float = 1;
// final STEP_TIME:Float = 0;
// final STRETCH:Float = 0.25;

function getSustainHit(note) {
    for (i in note.tail) {
        if (!i.wasGoodHit)
            return false;
    }
    return true;
}

function lerp(from, to, i) {
    return from + (to - from) * i;
}

var sustains:Array<Null<Float>> = [null, null, null, null];
function goodNoteHit(note) {
    if (note.isSustainNote) {
        debugPrint(getSustainHit(note.parent));
        sustains[note.parent.noteData] = null; // don't worry about this, not needed technically but i have upcoming stuff with possible conflicts
        sustains[note.noteData] = getSustainHit(note.parent) ? (note.strumTime + (COYOTE_TIME / 60 * 1000) + Conductor.stepCrochet * STEP_TIME) : null;
    }
}

final DIRECTIONS:Array<String> = ['left', 'down', 'up', 'right'];
var songPos:Float = 0;
function onUpdatePost(elapsed) {
    debugPrint(sustains);
    for (i in 0...sustains.length) {
        if (sustains[i] != null) {
            if (songPos < Conductor.songPosition || Conductor.songPosition > 1000) // stupid check just because when the song ends it resets time i think
                songPos = Conductor.songPosition;
            var compareStrum:Float = lerp(songPos, sustains[i], STRETCH);
            var imagineDiff:Float = Math.max(0, compareStrum - sustains[i]); // you can release early, all good
            debugPrint('diff = ' + imagineDiff);

            if (keyReleased(DIRECTIONS[i]) || game.endingSong) {
                var myStrum:StrumNote = game.playerStrums.members[i];
                var strumAnim:String = myStrum.animation.curAnim.name;

                var uwu:Note = new Note(Conductor.songPosition + imagineDiff, i);
                uwu.noAnimation = true;
                game.goodNoteHit(uwu);
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
//     var myStrum:StrumNote = game.playerStrums.members[i];
//     var strumAnim:String = myStrum.animation.curAnim.name;

//     var uwu:Note = new Note(Conductor.songPosition + imagineDiff, i);
//     uwu.noAnimation = true;
//     game.goodNoteHit(uwu);

//     if (!forceSet)
//         myStrum.playAnim(strumAnim);
//     sustains[i] = null;
// }