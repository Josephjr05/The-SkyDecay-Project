package uh;

import states.PlayState;
import objects.Note;
import openfl._v2.geom.*;
import flixel.FlxG;

/**
 * NoteCache subsystem - automatic caching + respawn utilities.
 * Option C implementation: integrated into engine and called at load time.
 */
class NoteCache {
    public var play:PlayState;

    // settings
    public var enabled:Bool = true;
    public var debugEnabled:Bool = true;

    // core storage
    public var cachedNotes:Array<Dynamic> = [];
    public var cachedPlayerNotes:Array<Dynamic> = [];
    public var cachedOpponentNotes:Array<Dynamic> = [];
    public var noteDataCache:Array<Dynamic> = [];
    public var replacementLookup:Array<Dynamic> = [];

    public function new(playState:PlayState) {
        this.play = playState;
    }

    // ------------------------------
    // Debug helper
    // ------------------------------
    public function dbg(msg:String):Void {
        if (!debugEnabled) return;
        trace("[NoteCache] " + msg);
    }

    // ------------------------------
    // Public entry: build cache (call after notes are generated)
    // ------------------------------
    public function buildCache():Void {
        if (!enabled) return;
        cacheNotes();
        dbg('Cached ' + cachedNotes.length + ' notes (player=' + cachedPlayerNotes.length + ', opp=' + cachedOpponentNotes.length + ')');
         trace('[NoteCache] buildCache: cachedNotes=' + cachedNotes.length + ', noteDataCache=' + noteDataCache.length);
    }

    // ------------------------------
    // Cache functions
    // ------------------------------
    public function cacheNotes():Void {
        cachedNotes = [];
        cachedPlayerNotes = [];
        cachedOpponentNotes = [];
        noteDataCache = [];

        var unspawn = play.unspawnNotes;
        if (unspawn == null || unspawn.length == 0) return;

        for (note in unspawn) {
            cachedNotes.push(note);

            var data = {
                strumTime: note.strumTime,
                noteData: note.noteData,
                mustPress: note.mustPress,
                noteType: note.noteType,
                isSustainNote: note.isSustainNote,
                sustainLength: note.sustainLength,
                prevNote: note.prevNote,
                parent: note.parent,
                hitByOpponent: note.hitByOpponent,
                ignoreNote: note.ignoreNote,
                hitHealth: note.hitHealth,
                missHealth: note.missHealth,
                rating: note.rating,
                ratingMod: note.ratingMod,
                texture: note.texture,
                noAnimation: note.noAnimation,
                noMissAnimation: note.noMissAnimation,
                hitCausesMiss: note.hitCausesMiss,
                distance: note.distance,
                hitsoundDisabled: note.hitsoundDisabled,
                gfNote: note.gfNote,
                earlyHitMult: note.earlyHitMult,
                lateHitMult: note.lateHitMult,
                lowPriority: note.lowPriority
            };
            noteDataCache.push(data);

            if (note.mustPress) cachedPlayerNotes.push(note); else cachedOpponentNotes.push(note);
        }
    }

    // ------------------------------
    // Query helpers
    // ------------------------------
    public function getTotalNoteCount():Int return cachedNotes.length;
    public function getNoteAtTime(time:Float, ?mustPress:Bool = null):Dynamic {
        var toleranceMs:Float = 50;
        for (n in cachedNotes) {
            if (Math.abs(n.strumTime - time) <= toleranceMs && (mustPress == null || n.mustPress == mustPress)) return n;
        }
        return null;
    }
    public function getNotesInRange(startTime:Float, endTime:Float, ?mustPress:Bool = null):Array<Dynamic> {
        var out:Array<Dynamic> = [];
        for (n in cachedNotes) if (n.strumTime >= startTime && n.strumTime <= endTime && (mustPress == null || n.mustPress == mustPress)) out.push(n);
        return out;
    }
    public function getNotesByColumn(column:Int, ?mustPress:Bool = null):Array<Dynamic> {
        var out:Array<Dynamic> = [];
        for (n in cachedNotes) if (n.noteData == column && (mustPress == null || n.mustPress == mustPress)) out.push(n);
        return out;
    }
    public function getNotesByType(noteType:String):Array<Dynamic> {
        var out:Array<Dynamic> = [];
        for (n in cachedNotes) if (n.noteType == noteType) out.push(n);
        return out;
    }
    public function getCachedNoteData(index:Int):Dynamic {
        return (index >= 0 && index < noteDataCache.length) ? noteDataCache[index] : null;
    }
    public function findNoteDataByTime(time:Float, ?mustPress:Bool = null):Array<Dynamic> {
        var out:Array<Dynamic> = [];
        for (d in noteDataCache) if (d.strumTime == time && (mustPress == null || d.mustPress == mustPress)) out.push(d);
        return out;
    }

    // ------------------------------
    // Clear notes in game (removes live/unspawn notes)
    // ------------------------------
    public function clearNotesInRange(startTime:Float, endTime:Float):Void {
        var removed:Int = 0;
        // remove from active notes
        var toRemove = new Array<Dynamic>();
        for (n in play.notes) if (n.strumTime >= startTime && n.strumTime <= endTime) toRemove.push(n);
        for (n in toRemove) {
            n.active = false;
            n.visible = false;
            n.ignoreNote = true;
            play.notes.remove(n, true);
            removed++;
        }

        // remove from unspawn queue
        var uremove = new Array<Dynamic>();
        for (n in play.unspawnNotes) if (n.strumTime >= startTime && n.strumTime <= endTime) uremove.push(n);
        for (n in uremove) {
            play.unspawnNotes.remove(n);
            removed++;
        }

        if (removed > 0) dbg('Cleared ' + removed + ' notes in range ' + startTime + '-' + endTime + 'ms');
    }

    // ------------------------------
    // Replacement helpers (pseudo-map)
    // ------------------------------
    function findReplacement(original:Dynamic, source:Array<Dynamic>):Dynamic {
        if (source == null || original == null) return null;
        for (entry in source) if (entry != null && entry.original == original) return entry.replacement;
        return null;
    }
    function setReplacement(source:Array<Dynamic>, original:Dynamic, replacement:Dynamic):Void {
        if (source == null || original == null || replacement == null) return;
        var updated = false;
        for (entry in source) if (entry != null && entry.original == original) { entry.replacement = replacement; updated = true; }
        if (!updated) source.push({ original: original, replacement: replacement });
        for (entry in source) if (entry != null && entry.replacement == original) entry.replacement = replacement;
    }
    function resolveNoteReference(original:Dynamic, replacements:Array<Dynamic>):Dynamic {
        if (original == null) return null;
        var localFound = findReplacement(original, replacements);
        if (localFound != null) return localFound;
        var globalFound = findReplacement(original, replacementLookup);
        if (globalFound != null) return globalFound;
        return original;
    }
    function registerReplacement(original:Dynamic, replacement:Dynamic, replacements:Array<Dynamic>):Void {
        if (original == null || replacement == null) return;
        if (replacements != null) setReplacement(replacements, original, replacement);
        setReplacement(replacementLookup, original, replacement);
    }

    // ------------------------------
    // Rebuilder / respawn logic
    // ------------------------------
    public function rebuildNote(index:Int, startTime:Float, endTime:Float, replacements:Array<Dynamic>, ?lastNotePerColumn:Array<Dynamic> = null, ?headPerColumn:Array<Dynamic> = null):Dynamic {
        var data = noteDataCache[index];
        var originalNote = cachedNotes[index];
        if (data == null || originalNote == null) return null;

        var columnKey:Int = data.noteData + (data.mustPress ? 0 : 4);

        if (lastNotePerColumn != null) while (lastNotePerColumn.length <= columnKey) lastNotePerColumn.push(null);
        if (headPerColumn != null) while (headPerColumn.length <= columnKey) headPerColumn.push(null);

        var prevNote:Dynamic = resolveNoteReference(data.prevNote, replacements);
        if (prevNote == null && lastNotePerColumn != null && lastNotePerColumn[columnKey] != null) prevNote = lastNotePerColumn[columnKey];

        var parentNote:Dynamic = null;
        if (data.isSustainNote) {
            parentNote = resolveNoteReference(data.parent, replacements);
            if (parentNote == null && headPerColumn != null && headPerColumn[columnKey] != null) parentNote = headPerColumn[columnKey];
            if (parentNote == null && data.parent != null) parentNote = data.parent;
        }

        var needsGoodHitMark:Bool = false;
        if (data.isSustainNote) needsGoodHitMark = (prevNote == null && parentNote == null);

        var newNote = createNoteFromData(data, prevNote, needsGoodHitMark, parentNote);
        if (newNote == null) return null;

        insertNoteIntoGame(newNote);
        registerReplacement(originalNote, newNote, replacements);
        cachedNotes[index] = newNote;
        data.prevNote = newNote.prevNote;
        data.parent = newNote.parent;

        if (lastNotePerColumn != null) lastNotePerColumn[columnKey] = newNote;
        if (headPerColumn != null) {
            if (!data.isSustainNote) headPerColumn[columnKey] = newNote;
            else if (parentNote != null && headPerColumn[columnKey] == null) headPerColumn[columnKey] = parentNote;
        }

        // if (newNote.parent != null) updateParentChain(newNote, newNote.parent, startTime, endTime);

        return newNote;
    }

    function createNoteFromData(data:Dynamic, ?prevNote:Dynamic = null, ?needsGoodHitMark:Bool = false, ?parentNote:Dynamic = null):Dynamic {
        if (data == null) { dbg('ERROR: createNoteFromData data==null'); return null; }
        if (data.strumTime == null || data.noteData == null) { dbg('ERROR: missing strumTime/noteData'); return null; }

        try {
            var newNote:Note = new Note(data.strumTime, data.noteData, prevNote, data.isSustainNote, false, null);
            if (newNote == null) { dbg('ERROR: Note constructor returned null'); return null; }

            newNote.mustPress = data.mustPress;

            if (data.noteType != null && data.noteType != '') {
                newNote.noteType = data.noteType;
            }

            newNote.sustainLength = data.sustainLength;

            // reset gameplay flags
            newNote.canBeHit = false;
            newNote.tooLate = false;
            newNote.hitByOpponent = false;
            newNote.wasGoodHit = (needsGoodHitMark && data.isSustainNote);

            // copy cosmetic fields
            newNote.rating = data.rating;
            newNote.ratingMod = data.ratingMod;
            newNote.noAnimation = data.noAnimation;
            newNote.noMissAnimation = data.noMissAnimation;
            newNote.distance = data.distance;
            newNote.hitsoundDisabled = data.hitsoundDisabled;
            newNote.gfNote = data.gfNote;
            newNote.earlyHitMult = data.earlyHitMult;
            newNote.lateHitMult = data.lateHitMult;

            if (parentNote != null) newNote.parent = parentNote;
            if (data.texture != null && data.texture != '') newNote.texture = data.texture;

            return newNote;
        } catch (e:Dynamic) {
            dbg('ERROR creating note: ' + e);
            return null;
        }
    }

    // ------------------------------
    // Respawn wrappers
    // ------------------------------
    public function respawnNote(index:Int):Dynamic {
        if (index < 0 || index >= noteDataCache.length) { dbg('respawnNote invalid index ' + index); return null; }
        var data = noteDataCache[index];
        var replacements:Array<Dynamic> = [];
        var newNote = rebuildNote(index, data.strumTime, data.strumTime, replacements);
        if (newNote != null) dbg('Respawned note at ' + data.strumTime);
        return newNote;
    }

    public function respawnNoteAtTime(time:Float, ?mustPress:Bool = null):Array<Dynamic> {
        var respawned:Array<Dynamic> = [];
        var replacements:Array<Dynamic> = [];
        var lastNotePerColumn:Array<Dynamic> = [];
        var headPerColumn:Array<Dynamic> = [];

        // tolerance in ms for float rounding differences
        var toleranceMs:Float = 50; // 50 ms tolerance; increase if necessary

        for (i in 0...noteDataCache.length) {
            var d = noteDataCache[i];
            if (Math.abs(d.strumTime - time) <= toleranceMs) {
                if (mustPress == null || d.mustPress == mustPress) {
                    var n = rebuildNote(i, time - toleranceMs, time + toleranceMs, replacements, lastNotePerColumn, headPerColumn);
                    if (n != null) respawned.push(n);
                }
            }
        }
        if (respawned.length > 0) dbg('Respawned ' + respawned.length + ' notes at ' + time);
        else dbg('Respawn: none found at ' + time + ' (tol ' + toleranceMs + 'ms)');

        return respawned;
    }

    public function respawnNotesInRange(startTime:Float, endTime:Float, ?mustPress:Bool = null):Array<Dynamic> {
        var respawned:Array<Dynamic> = [];
        var replacements:Array<Dynamic> = [];
        var lastNotePerColumn:Array<Dynamic> = [];
        var headPerColumn:Array<Dynamic> = [];
        for (i in 0...noteDataCache.length) {
            var d = noteDataCache[i];
            if (d.strumTime >= startTime && d.strumTime <= endTime && (mustPress == null || d.mustPress == mustPress)) {
                var n = rebuildNote(i, startTime, endTime, replacements, lastNotePerColumn, headPerColumn);
                if (n != null) respawned.push(n);
            }
        }
        if (respawned.length > 0) dbg('Respawned ' + respawned.length + ' notes between ' + startTime + '-' + endTime);
        return respawned;
    }

    // ------------------------------
    // Insert note into unspawn queue
    // ------------------------------
    public function insertNoteIntoGame(note:Dynamic):Void {
        var inserted:Bool = false;
        for (i in 0...play.unspawnNotes.length) {
            if (note.strumTime < play.unspawnNotes[i].strumTime) {
                play.unspawnNotes.insert(i, note);
                inserted = true;
                break;
            }
        }
        if (!inserted) play.unspawnNotes.push(note);
    }
}