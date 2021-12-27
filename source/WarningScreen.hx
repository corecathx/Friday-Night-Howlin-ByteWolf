package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flash.system.System;

class WarningScreen extends MusicBeatState
{
	var warning:FlxSprite;

	override function create()
	{
		warning = new FlxSprite(0,0).loadGraphic(Paths.image('someImage'));
		add(warning);

		var funkyText:FlxText = new FlxText(5, FlxG.height - 18, 0, "ByteWolf Mod - Kade Engine", 12);
		funkyText.scrollFactor.set();
		funkyText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(funkyText);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
			{
				FlxG.switchState(new MainMenuState());
			}
		
		if (FlxG.keys.justPressed.D)
			{
				FlxG.save.data.dontshow = !FlxG.save.data.dontshow;
				FlxG.switchState(new MainMenuState());
			}
		if (FlxG.keys.justPressed.Q)
			{
				System.exit(0);
			}

		super.update(elapsed);
	}
}
