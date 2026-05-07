package objects;

//class by NickMGC!!
import flixel.graphics.tile.FlxDrawQuadsItem;
import flixel.graphics.frames.FlxFrame;

import flixel.util.FlxDestroyUtil;
import flixel.math.FlxRect;

import flixel.FlxSprite;
import flixel.FlxCamera;

using flixel.util.FlxColorTransformUtil;

/**
 * A specialized sprite that extends `FlxSprite` with additional functionality for tiled rendering alongside having a tail sprite at the end.
 *
 * ### Limitations
 * - Tail animations must be in the same texture.
 * - The tail's animation playback depends on the body's amount of frames.
 *
 * ## Basic Usage
 * ```haxe
 * var tailSprite:FlxTailedSprite = new FlxTailedSprite(100, 100).loadGraphic("assets/spritesheet.png", true, 50, 50);
 * tailSprite.animation.add("body", [0], 25);
 * tailSprite.animation.add("tail", [1], 25);
 * tailSprite.animation.play("body");
 * tailSprite.setTailAnim("tail");
 * tailSprite.height = 150;
 * add(tailSprite);
 * ```
 *
 * @author NickNGC
 */
class TiledRenderer extends FlxSprite {
	var tailAnim:String;
	var tailFrame:FlxFrame;

	var tiles:Float;
	var tileCount:Int;

	/**
	 * Creates a `FlxTailedSprite` at a specified position.
	 * @param X  The initial X position of the sprite.
	 * @param Y  The initial Y position of the sprite.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0):Void {
		super(X, Y);
	}

	/**
	 * Sets an animation to use for the tail.
	 * @param name  Animation name.
	 * @return      This `FlxTailedSprite` instance.
	 */
	public function setTailAnim(name:String):TiledRenderer {
		tailAnim = name;
		return this;
	}

	@:noCompletion inline function adjustFrame(frame:FlxFrame):Void { //Frame gap fix made by RapperGF.
		if (frame == null) return;

		frame.sourceSize.y -= 2;
		frame.frame.height -= 2;
		frame.frame.y += 1;
	}

	@:noCompletion function updateTailFrame():Void {
        if (frames == null || animation == null || tailAnim == null || animation.getByName(tailAnim) == null) return;

        tailFrame = frames.frames[animation.getByName(tailAnim).frames[animation.curAnim.curFrame]].copyTo(tailFrame);
        adjustFrame(tailFrame);
    }

	@:noCompletion override function drawComplex(camera:FlxCamera):Void {
		if (frames == null || tiles <= 0 || !dirty) return;

		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		_matrix.translate(-origin.x, -origin.y);
		_matrix.scale(scale.x, scale.y);

		if (bakedRotationAngle <= 0) {
			updateTrig();
			
			if (angle != 0) {
				_matrix.rotateWithTrig(_cosAngle, _sinAngle);
			}
		}

		getScreenPosition(_point, camera).subtract(offset.x, offset.y).add(origin.x, origin.y);
		_matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera)) {
			_matrix.tx = Math.floor(_matrix.tx);
			_matrix.ty = Math.floor(_matrix.ty);
		}

		final batch:FlxDrawQuadsItem = camera.startQuadBatch(_frame.parent, colorTransform?.hasRGBMultipliers(), colorTransform?.hasRGBAOffsets(), blend, antialiasing, shader);

		final bodyIndex:Int = flipY ? tileCount - 1 : 0;
        final tailIndex:Int = flipY ? 0 : tileCount - 1;
		final absScaleY:Float = Math.abs(scale.y);

		if (flipY) {
			final tailOffset:Float = (_frame.frame.height - (tailFrame ?? _frame).frame.height) * absScaleY;
			_matrix.translate(tailOffset * _sinAngle, -tailOffset * _cosAngle);
		}

		for (i in 0...tileCount) {
			final frameToDraw:FlxFrame = i == tailIndex ? tailFrame ?? _frame : _frame;
			var offsetAmount:Float = (flipY ? _frame.frame.height : frameToDraw.frame.height) * absScaleY;

			if (i == bodyIndex && tiles < tileCount) {
				final clipReduction:Float = frameToDraw.frame.height * (tileCount - tiles);

				frameToDraw.frame.height -= clipReduction;
				frameToDraw.frame.y += clipReduction;

				if (flipY) {
					final clipOffset:Float = clipReduction * absScaleY;
					_matrix.translate(clipOffset * _sinAngle, -clipOffset * _cosAngle);
				}

				batch.addQuad(frameToDraw, _matrix, colorTransform);

				offsetAmount = frameToDraw.frame.height * absScaleY;

				frameToDraw.frame.height += clipReduction;
				frameToDraw.frame.y -= clipReduction;
			} else {
				batch.addQuad(frameToDraw, _matrix, colorTransform);
			}

			_matrix.translate(-offsetAmount * _sinAngle, offsetAmount * _cosAngle);
		}
	}

	override public function getScreenBounds(?newRect:FlxRect, ?camera:FlxCamera):FlxRect {
		if (newRect == null)
			newRect = FlxRect.get();
		
		if (camera == null)
			camera = FlxG.camera;
		
		newRect.setPosition(x, y);
		if (pixelPerfectPosition)
			newRect.floor();
		_scaledOrigin.set(origin.x * scale.x, origin.y * scale.y);
		newRect.x += -Std.int(camera.scroll.x * scrollFactor.x) - offset.x + origin.x - _scaledOrigin.x;
		newRect.y += -Std.int(camera.scroll.y * scrollFactor.y) - offset.y + origin.y - _scaledOrigin.y;
		if (isPixelPerfectRender(camera))
			newRect.floor();
		newRect.setSize(frameWidth * Math.abs(scale.x), height); //Use the height instead of frameHeight to avoid rendering problems
		return newRect.getRotatedBounds(angle, _scaledOrigin, newRect);
	}

	@:noCompletion override function set_frame(value:FlxFrame):FlxFrame {
		super.set_frame(value);
		adjustFrame(_frame);
		updateTailFrame();
		return value;
	}

	@:noCompletion override function set_height(value:Float):Float {
		if (height == value || frames == null) return value;

		final absScaleY:Float = Math.abs(scale.y);
		final tailHeight:Float = (tailFrame?.frame.height ?? _frame.frame.height) * absScaleY;

		tileCount = Math.ceil(tiles = value <= tailHeight ? value / tailHeight : (value - tailHeight) / (_frame.frame.height * absScaleY) + 1);

		return super.set_height(value);
	}

	override function destroy():Void {
		tailFrame = FlxDestroyUtil.destroy(tailFrame);
		super.destroy();
	}
}