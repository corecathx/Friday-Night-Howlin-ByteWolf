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

class TitleState extends MusicBeatState
{
	var doneTxt:Bool = false;
	static var initialized:Bool = false;
	static var loaded:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var coreDevicon:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		FlxG.game.focusLostFramerate = 60;

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var bg11:FlxSprite;
	var bytetitle:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!loaded)
			{
				if (!initialized)
					{
						var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
						diamond.persist = true;
						diamond.destroyOnNoUse = false;
			
						FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
							new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
						FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
							{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			
						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;
			
						// HAD TO MODIFY SOME BACKEND SHIT
						// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
						// https://github.com/HaxeFlixel/flixel-addons/pull/348
			
						// var music:FlxSound = new FlxSound();
						// music.loadStream(Paths.music('freakyMenu'));
						// FlxG.sound.list.add(music);
						// music.play();
					}
			
					if (!FlxG.save.data.gamedone)
						Conductor.changeBPM(130);
						else
						Conductor.changeBPM(120);
					persistentUpdate = true;
			
					var bg:FlxSprite = new FlxSprite(-3300,-3300).makeGraphic(7000, 7000, FlxColor.fromRGB(0, 66, 107));
					// bg.antialiasing = true;
					// bg.setGraphicSize(Std.int(bg.width * 0.6));
					// bg.updateHitbox();
			
					//bg.alpha = 0.3;
					add(bg);
			
					bg11 = new FlxSprite(-3300,-3300).makeGraphic(7000, 7000, FlxColor.WHITE);
					bg11.alpha = 0;
					add(bg11);
			
					logoBl = new FlxSprite(160, 90); //-150, 100
					logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
					logoBl.antialiasing = true;
					logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
					logoBl.updateHitbox();
					// logoBl.screenCenter();
					// logoBl.color = FlxColor.BLACK;
			
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
			
					credGroup = new FlxGroup();
					add(credGroup);
					textGroup = new FlxGroup();
			
					blackScreen = new FlxSprite(-3300,-3300).makeGraphic(7000, 7000, FlxColor.BLACK);
					credGroup.add(blackScreen);
			
					credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
					credTextShit.screenCenter();
			
					// credTextShit.alignment = CENTER;
			
					credTextShit.visible = false;
			
					coreDevicon = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('coredev-logo'));
					add(coreDevicon);
					coreDevicon.visible = false;
					coreDevicon.setGraphicSize(Std.int(coreDevicon.width * 0.8));
					coreDevicon.updateHitbox();
					coreDevicon.screenCenter(X);
					coreDevicon.antialiasing = true;
			
					FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});
			
					FlxG.mouse.visible = false;
			
					if (initialized)
						skipIntro();
					else
						initialized = true;
			}

		if(!loaded)
			{
				if (!FlxG.save.data.gamedone)
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					else
					FlxG.sound.playMusic(Paths.music('howlChillLoop'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);

				loaded = true;
			}
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
		if (loaded)
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
		
				if (pressedEnter && !transitioning && skippedIntro)
				{
					#if !switch
					NGio.unlockMedal(60960);
		
					// If it's Friday according to da clock
					if (Date.now().getDay() == 5)
						NGio.unlockMedal(61034);
					#end
		
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
		
				if (pressedEnter && !skippedIntro && initialized)
				{
					skipIntro();
				}
			}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 100;
			money.alpha = 0;
			credGroup.add(money);
			textGroup.add(money);
			FlxTween.tween(money, {y: money.y + 100, alpha: 1}, 0.3,
				{ease: FlxEase.circOut, onComplete: function(twn: FlxTween){
				}});
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 100;
		coolText.alpha = 0;
		credGroup.add(coolText);
		textGroup.add(coolText);
		FlxTween.tween(coolText, {y: coolText.y + 100, alpha: 1}, 0.3,
			{ease: FlxEase.circOut, onComplete: function(twn: FlxTween){
			}});
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
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

		switch (curBeat)
		{
			case 1:
				createCoolText(['CoreDev']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('presents');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (Main.watermarks)
					createCoolText(['Modified','Kade Engine By']);
				else
					createCoolText(['Mod By']);
			case 7:
				if (Main.watermarks)
					{
						addMoreText('CoreDev');
						coreDevicon.visible = true;
					}
					else
					{
						addMoreText('CoreDev');
						coreDevicon.visible = true;
					}
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				coreDevicon.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				FlxG.camera.zoom += 0.025;	
				addMoreText('Friday');
			// credTextShit.visible = true;
			case 14:
				FlxG.camera.zoom += 0.025;	
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 15:
				FlxG.camera.zoom += 0.025;	
				addMoreText('Howlin'); // credTextShit.text += '\nFunkin';

			case 16:
				doneTxt = true;
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(coreDevicon);

			FlxG.camera.flash(FlxColor.WHITE, 1);
			remove(credGroup);
			skippedIntro = true;
			startTitleAnims();
		}
	}

	function startTitleAnims():Void //this code is trash
		{
			//for logo
			FlxTween.tween(logoBl, {y: 45}, 2.0,
				{ease: FlxEase.smoothStepOut, onComplete: function(twn: FlxTween){		
					FlxTween.tween(bytetitle, {x: FlxG.width * 0.59, y: FlxG.height * 0.07}, 1.0,{ease: FlxEase.smoothStepOut, onComplete: function(twn: FlxTween){}});
					FlxTween.tween(logoBl, {x: -150, y: -100}, 1.0,{ease: FlxEase.smoothStepOut, onComplete: function(twn: FlxTween){}});
					titleText.y += 300;
					FlxTween.tween(titleText, {y: titleText.y - 300, alpha: 1}, 1.0,{ease: FlxEase.smoothStepOut, onComplete: function(twn: FlxTween){}});
				}});	
			//});
		}

	function endTitleAnims()
		{
			FlxTween.tween(bytetitle, {y: bytetitle.y + 600, alpha: 0}, 2,
				{ease: FlxEase.circIn, onComplete: function(twn: FlxTween){
				}});

			FlxTween.tween(logoBl, {y: logoBl.y + 600, alpha: 0}, 2,
				{ease: FlxEase.circIn, onComplete: function(twn: FlxTween){
				}});

			FlxTween.tween(titleText, {y: titleText.y + 600, alpha: 0}, 2,
				{ease: FlxEase.circIn, onComplete: function(twn: FlxTween){
				}});
		}
}
