package flixel.util;

/**
 * A simple interface for objects that can be destroyed and pooled.
 * This replaces the internal FlxDestroyable class for external use from earlier flixel versions.
 */
interface IDestroyable {
    public function destroy():Void;
}