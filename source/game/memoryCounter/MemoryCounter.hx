package game.memoryCounter;

import flixel.math.FlxMath;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Memory;
import flixel.system.FlxAssets;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class MemoryCounter extends TextField
{
	private var times:Array<Float>;
	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000)
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 13, inCol);
		// defaultTextFormat = new TextFormat("_sans", 14, inCol);

		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 1280;
		height = 720;
	}

	private function onEnter(_)
	{
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "\nMemory: " + mem + " MB\nMemory Peak: " + memPeak + " MB";
		}
	}
}