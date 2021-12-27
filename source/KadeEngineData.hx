import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = true;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = true;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 0;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;
		
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		//NO PLS
		if (FlxG.save.data.screenshake == null)
			FlxG.save.data.screenshake = false;

		if (FlxG.save.data.language == null)
			FlxG.save.data.language = false;

		if (FlxG.save.data.fullmodescreen == null)
			FlxG.save.data.fullmodescreen = false;
		
		if (FlxG.save.data.animdebugsave == null)
			FlxG.save.data.animdebugsave = false;

		if (FlxG.save.data.menucharacter == null)
			FlxG.save.data.menucharacter = true;

		if (FlxG.save.data.notesplash == null)
			FlxG.save.data.notesplash = true;

		if (FlxG.save.data.ratingsize == null)
			FlxG.save.data.ratingsize = 0.7;

		if (FlxG.save.data.dontshow == null)
			FlxG.save.data.dontshow = false;

		if (FlxG.save.data.gamedone == null)
			FlxG.save.data.gamedone = false;

		if (FlxG.save.data.dpn == null)
			FlxG.save.data.dpn = false;

		if (FlxG.save.data.howlfull == null)
			FlxG.save.data.howlfull = false;

		if (FlxG.save.data.middlescroll == null)
			FlxG.save.data.middlescroll = false;

		if (FlxG.save.data.scoreStyle == null)
			FlxG.save.data.scoreStyle = "ByteWolf";

		Conductor.recalculateTimings();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}