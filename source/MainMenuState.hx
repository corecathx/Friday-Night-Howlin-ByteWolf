package;

// import js.html.svg.Number;
import openfl.Assets as OpenFLAssets;
import flixel.math.FlxMath;
import PiracyState.PiracyScreen;
import flixel.system.FlxBasePreloader;
import flixel.FlxCamera;
import haxe.Timer;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menaItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'youtube', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;
	var gfDance:Character;
	var bfIdleTitle:Character;
	var bytetitle:Character;
	var logoBl:FlxSprite;
	var menuItem:FlxSprite;
	// var danceLeft:Bool = true;
	var bg:FlxSprite;
	var bg1:FlxSprite;
	var magenta:FlxSprite;
	var menuItemDefaultX:Float;

	var canDance:Bool = false;

	public static var nightly:String = "";
	public static var isCoolMode:Bool = false;
	public static var gfLovelyMode:Bool = false;

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "V.S ByteWolf V.1.7.0";

	var dazoom:Float = 0;

	var camFollow:FlxObject;

	override function create()
	{
		//OpenFLAssets.cache.clear();
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		//persistentUpdate = true;
		if (FlxG.save.data.gamedone)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('howlChillLoop'));
				Conductor.changeBPM(120);
			}
		}
		else
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(130);
			}
		}

		if (FlxG.save.data.gamedone)
		{
			optionShit = ['story mode', 'freeplay', 'youtube', 'options'];
		}
		else
		{
			optionShit = ['story mode', 'freeplay', 'youtube', 'options'];
		}

		persistentUpdate = persistentDraw = true;

		/*bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0.10;
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			add(bg); */

		bg = new FlxSprite(-600, -100).loadGraphic(Paths.image('backSky'));
		bg.antialiasing = true;
		bg.screenCenter();
		bg.setGraphicSize(Std.int(bg.width * 0.85));
		bg.scrollFactor.set(0, 0.2);
		bg.active = false;

		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.15;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		// logoBl.animation.play('bump');
		logoBl.updateHitbox();

		if (!gfLovelyMode)
		{
			gfDance = new Character(FlxG.width * 0.4, FlxG.height * 0.07, "gf");
			gfDance.setGraphicSize(Std.int(gfDance.width * 0.7));
			gfDance.scrollFactor.x = 0;
			gfDance.scrollFactor.y = 0.2;
		}
		else
		{
			gfDance = new Character(FlxG.width * 0.4, FlxG.height * 0.07, "gf-heart");
			gfDance.setGraphicSize(Std.int(gfDance.width * 0.7));
			gfDance.scrollFactor.x = 0;
			gfDance.scrollFactor.y = 0.2;
			gfDance.isHappy = true;
		}

		if (!isCoolMode)
		{
			bfIdleTitle = new Character(FlxG.width * 0.65, FlxG.height * 0.4, "bf", true);
			bfIdleTitle.setGraphicSize(Std.int(bfIdleTitle.width * 0.48));
			bfIdleTitle.scrollFactor.x = 0;
			bfIdleTitle.scrollFactor.y = 0.2;

			bytetitle = new Character(FlxG.width * 0.3, FlxG.height * 0.02, "byte");
			bytetitle.setGraphicSize(Std.int(bytetitle.width * 0.7));
			bytetitle.scrollFactor.x = 0;
			bytetitle.scrollFactor.y = 0.2;
		}
		else
		{
			bfIdleTitle = new Character(FlxG.width * 0.65, FlxG.height * 0.4, "bf-cool", true);
			bfIdleTitle.setGraphicSize(Std.int(bfIdleTitle.width * 0.74));
			bfIdleTitle.scrollFactor.x = 0;
			bfIdleTitle.scrollFactor.y = 0.2;

			bytetitle = new Character(FlxG.width * 0.3, FlxG.height * 0.02, "byte-cool");
			bytetitle.setGraphicSize(Std.int(bytetitle.width * 0.7));
			bytetitle.scrollFactor.x = 0;
			bytetitle.scrollFactor.y = 0.2;
		}

		if (FlxG.save.data.menucharacter)
		{
			add(gfDance);
			add(bfIdleTitle);
			add(bytetitle);
			bytetitle.x += 50;
			bytetitle.alpha = 0;

			bfIdleTitle.x += 50;
			bfIdleTitle.alpha = 0;

			gfDance.x += 50;
			gfDance.alpha = 0;

			FlxTween.tween(bytetitle, {x: bytetitle.x - 50, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
			FlxTween.tween(gfDance, {x: gfDance.x - 50, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
			FlxTween.tween(bfIdleTitle, {x: bfIdleTitle.x - 50, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			if (FlxG.save.data.menucharacter)
			{
				menuItem = new FlxSprite(50, 200 + (i * 160));
				menuItemDefaultX = 50;
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.7));
				// menuItem.x = 0.6;
				menuItem.updateHitbox();
				menuItem.ID = i;
				menuItems.add(menuItem);
				menuItem.scrollFactor.set(0, 1);
				menuItem.antialiasing = true;

				menuItem.x -= 50;
				menuItem.alpha = 0;
				FlxTween.tween(menuItem, {x: menuItem.x + 50, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				menuItem.scrollFactor.set();
				menuItem.antialiasing = true;

				menuItem.alpha = 0;
				FlxTween.tween(menuItem, {alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
		}

		FlxG.camera.follow(camFollow, null, 0.15 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + (Main.watermarks ? " - " + kadeEngineVer + " Kade Engine (Modified)" : ""),
			12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();


		gfDance.dance();
		bfIdleTitle.playAnim('idle', true);
		bytetitle.playAnim('idle', true);					

		dazoom = FlxG.camera.zoom;

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.camera.zoom = FlxMath.lerp(dazoom, FlxG.camera.zoom, 0.95);

		if (FlxG.save.data.fullmodescreen)
			FlxG.fullscreen = true;
		else if (!FlxG.save.data.fullmodescreen)
			FlxG.fullscreen = false;

		if (FlxG.save.data.animdebugsave)
			if (FlxG.keys.justPressed.P)
				FlxG.switchState(new ThankYouState());

		if (FlxG.keys.justPressed.B)
			FlxG.switchState(new ByteBeep());

		/*
			switch (optionShit[curSelected])
				{
					case 'story mode':
						bg.loadGraphic(Paths.image('menuBG'));
					case 'freeplay':
						bg.loadGraphic(Paths.image('freeplayBlur'));
					case 'youtube':
						bg.loadGraphic(Paths.image('menuBGBlue'));
					case 'options':
						bg.loadGraphic(Paths.image('menuDesat'));
		}*/

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		// danceLeft = !danceLeft;

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleScreen());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'options')
				{
					FlxG.sound.pause();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				}

				if (optionShit[curSelected] == 'youtube')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.youtube.com/channel/UCQhxUlrUtrMZjeA05sbEMmA", "&"]);
					#else
					FlxG.openURL('https://www.youtube.com/channel/UCQhxUlrUtrMZjeA05sbEMmA');
					#end
				}
				else
				{
					FlxG.sound.pause();
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.camera.flash(FlxColor.WHITE, 0.5);

					// if (FlxG.save.data.flashing)
					// FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							if (FlxG.save.data.menucharacter)
							{
								new FlxTimer().start(0.5, function(tt:FlxTimer)
								{
									// dazoom = 0.7;
									FlxTween.tween(spr, {x: spr.x - 50}, 1.3, {
										ease: FlxEase.circOut,
										onComplete: function(twn:FlxTween)
										{
										}
									});
									FlxTween.tween(spr, {alpha: 0}, 1.3, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});

									// FlxTween.tween(bytetitle, {x: bytetitle.x + 50, alpha: 0}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
									// FlxTween.tween(gfDance, {x: gfDance.x + 50, alpha: 0}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
									// FlxTween.tween(bfIdleTitle, {x: bfIdleTitle.x + 50, alpha: 0}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										// goToState();
										goToState();
										// FlxTween.tween(bg, {y: bg.y + 720, alpha: 0}, 2, {ease: FlxEase.circIn, onComplete: function(twn:FlxTween){}});
									});
								});
							}
							else
							{
								FlxTween.tween(spr, {x: spr.x - 50}, 1.3, {
									ease: FlxEase.circOut,
									onComplete: function(twn:FlxTween)
									{
									}
								});
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									FlxTween.tween(spr, {alpha: 0}, 1, {
										ease: FlxEase.circOut,
										onComplete: function(twn:FlxTween)
										{
										}
									});
								});

								FlxFlicker.flicker(spr, 2, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(2, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (!FlxG.save.data.menucharacter)
				spr.screenCenter(X);
		});
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		#if desktop
		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("mmm freeplay");

			case 'options':
				FlxG.switchState(new OptionsMenu());
				trace('fuck off');
		}
		#else
		FlxG.switchState(new PiracyScreen());
		#end
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (FlxG.save.data.menucharacter)
			{
				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					// camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					camFollow.setPosition(0, spr.getGraphicMidpoint().y);
				}
			}
			else
			{
				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					// camFollow.setPosition(spr.getGraphicMidpoint().y, spr.getGraphicMidpoint().y);
				}
			}
			spr.updateHitbox();
		});
	}

	override function beatHit()
	{
		if (curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.05;
		}
			gfDance.dance();

			if (curBeat % 2 == 0)
				{
					bfIdleTitle.playAnim('idle', true);
					bytetitle.playAnim('idle', true);					
				}
	}
}
