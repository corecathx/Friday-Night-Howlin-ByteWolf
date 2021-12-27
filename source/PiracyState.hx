package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class PiracyScreen extends MusicBeatState
{

	public function new() 
	{
		super();
	}
	
	override function create() 
	{
		super.create();
		if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('piracyScreen'));
				//Conductor.changeBPM(120);
			}
		
		var bruh:FlxSprite = new FlxSprite().loadGraphic(Paths.image("piracy"));
		add(bruh);
		
		
	}
	
	
	override function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.Z)
		{
			FlxG.openURL('https://gamebanana.com/mods/314617');
		}
		if (FlxG.keys.justPressed.C)
		{
			FlxG.openURL('https://gamejolt.com/games/fnf-bytewolf/654156');
		}
	}
	
}