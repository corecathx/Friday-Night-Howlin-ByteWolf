package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var gf:Character;
	var camFollow:FlxObject;

	public static var diedCuzPaws:Bool = false;
	public static var missedPawz:Int = 0;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float, gfX:Float, gfY:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		var daGf:String = 'gf';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);

		gf = new Character(gfX, gfY, daGf);
		add(gf);
		add(bf);

		camFollow = new FlxObject(bf.getMidpoint().x - 100, bf.getMidpoint().y - 100, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		gf.playAnim('scared');

		if (diedCuzPaws)
			{
				var ress:FlxText = new FlxText(0, 650, 0, "(Try to not miss the Paw Notes)" + "\n"+"-You missed " + missedPawz + " Paw Notes-", 20);
				ress.scrollFactor.set();
				ress.screenCenter(X);
				ress.alpha = 0;
				ress.setFormat("Pixel Arial 11 Bold", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				add(ress);
				FlxTween.tween(ress, {y: ress.y - 100, alpha: 1}, 3, {ease: FlxEase.circOut});
			}


		var press:FlxText = new FlxText(0, 700, 0, "-Press ENTER / SPACE to Restart-", 20);
		press.scrollFactor.set();
		press.screenCenter(X);
		press.alpha = 0;
		press.setFormat("Pixel Arial 11 Bold", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(press);


		FlxTween.tween(press, {y: press.y - 100, alpha: 1}, 3, {ease: FlxEase.circOut});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.zoom = FlxMath.lerp(0.8, FlxG.camera.zoom, 0.95);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			gf.playAnim('sad', true);
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();
		gf.playAnim('sad', true);
		FlxG.camera.zoom += 0.030;
		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			gf.playAnim('cheer', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.save.flush();
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
