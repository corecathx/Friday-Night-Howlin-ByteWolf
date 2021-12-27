package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
#if windows
import Discord.DiscordClient;
#end
#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleScreen extends MusicBeatState
{
	var doneTxt:Bool = false;

	var logoBl:FlxSprite;
	var bg11:FlxSprite;
	var gfDance:FlxSprite;
	var bytetitle:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	override public function create():Void
	{

			//persistentUpdate = true;

			var bg:FlxSprite = new FlxSprite(-3300, -3300).makeGraphic(7000, 7000, FlxColor.fromRGB(0, 66, 107));
			add(bg);

			bg11 = new FlxSprite(-3300, -3300).makeGraphic(7000, 7000, FlxColor.WHITE);
			bg11.alpha = 0;
			add(bg11);

			logoBl = new FlxSprite(160, 90); //-150, 100
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
			logoBl.updateHitbox();

			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
			gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			gfDance.antialiasing = true;
			// add(gfDance);
			// add(logoBl);

			bytetitle = new FlxSprite(FlxG.width * 0.8, FlxG.height * 0.02);
			bytetitle.frames = Paths.getSparrowAtlas('byteDanceTitle');
			bytetitle.animation.addByIndices('danceLeft', 'Byte Dancin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			bytetitle.animation.addByIndices('danceRight', 'Byte Dancin', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			bytetitle.antialiasing = true;
			add(bytetitle);
			add(logoBl);

			FlxG.camera.zoom = 0.8;

			titleText = new FlxSprite(100, FlxG.height * 0.8);
			titleText.frames = Paths.getSparrowAtlas('titleEnter');
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
			titleText.alpha = 0;
			titleText.antialiasing = true;
			titleText.animation.play('idle');
			titleText.updateHitbox();
			// titleText.screenCenter(X);
			add(titleText);

			logoBl.y += 700;
			bytetitle.x = FlxG.camera.width + 222;

			FlxG.mouse.visible = false;

			startTitleAnims();
			FlxG.camera.flash(FlxColor.WHITE, 1);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
			FlxG.camera.zoom = FlxMath.lerp(0.8, FlxG.camera.zoom, 0.95);
			bg11.alpha = FlxMath.lerp(0, bg11.alpha, 0.95);
			if (FlxG.sound.music != null)
				Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

			#if mobile
			for (touch in FlxG.touches.list)
			{
				if (touch.justPressed)
				{
					pressedEnter = true;
				}
			}
			#end

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.START)
					pressedEnter = true;

				#if switch
				if (gamepad.justPressed.B)
					pressedEnter = true;
				#end
			}

			if (pressedEnter && !transitioning)
			{
				if (FlxG.save.data.flashing)
					titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					endTitleAnims();
				});

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}

		super.update(elapsed);
	}

	override function beatHit()
	{
		bg11.alpha += 0.1;
		FlxG.camera.zoom += 0.025;

		super.beatHit();
		logoBl.animation.play('bump', true);

		danceLeft = !danceLeft;

		if (danceLeft)
			bytetitle.animation.play('danceRight');
		else
			bytetitle.animation.play('danceLeft');

		FlxG.log.add(curBeat);
	}

	function startTitleAnims():Void // this code is trash
	{
		// for logo
		FlxTween.tween(logoBl, {y: 45}, 2.0, {
			ease: FlxEase.smoothStepOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(bytetitle, {x: FlxG.width * 0.59, y: FlxG.height * 0.07}, 1.0, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
				}});
				FlxTween.tween(logoBl, {x: -150, y: -100}, 1.0, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
				}});
				titleText.y += 300;
				FlxTween.tween(titleText, {y: titleText.y - 300, alpha: 1}, 1.0, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
				}});
			}
		});
		// });
	}

	function endTitleAnims()
	{
		FlxTween.tween(bytetitle, {y: bytetitle.y + 600, alpha: 0}, 2, {
			ease: FlxEase.circIn,
			onComplete: function(twn:FlxTween)
			{
			}
		});

		FlxTween.tween(logoBl, {y: logoBl.y + 600, alpha: 0}, 2, {
			ease: FlxEase.circIn,
			onComplete: function(twn:FlxTween)
			{
			}
		});

		FlxTween.tween(titleText, {y: titleText.y + 600, alpha: 0}, 2, {
			ease: FlxEase.circIn,
			onComplete: function(twn:FlxTween)
			{
			}
		});
	}
}
