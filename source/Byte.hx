package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Byte extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'byte')
	{
		super(x, y, char, false);
		flipX = false;
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			} else {
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}
}
