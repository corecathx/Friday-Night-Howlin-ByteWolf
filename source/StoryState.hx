package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

//THIS CODE IS COPIED FROM MenuCharacter.hx!!!
//CUZ' I'M DUMB!!!
class ByteSetting
{
	
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class StoryState extends FlxSprite
{
	private static var settings:Map<String, ByteSetting> = [
		'byte' => new ByteSetting(0, -20, 0, false),
		'byteHey' => new ByteSetting(100, -15, 0, false)
	];

	private var flipped:Bool = false;

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = true;

		frames = Paths.getSparrowAtlas('byte_story_modeicon');
		
        animation.addByPrefix('byte', "Byte head anim", 24);
		animation.addByPrefix('byteHey', "Byte head arrow", 24, false);

		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setSprite(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		animation.play(character);

		var setting:ByteSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}
