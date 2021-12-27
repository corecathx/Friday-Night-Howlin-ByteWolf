package;

import flixel.group.FlxSpriteGroup;
import ShadersHandler.ChromaticAberration;
import io.newgrounds.components.AppComponent;
import openfl.display.GraphicsBitmapFill;
import flixel.system.frontEnds.WatchFrontEnd;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	public static var strumXPOS:Float = 35;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	var doGlitch:Bool = false;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	var blackOverlay:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.BLACK);
	var coolOverlay:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.WHITE);

	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;

	public static var onScreenInputs:FlxTypedGroup<FlxSprite> = null;

	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	var bfCamX:Int = 0;
	var bfCamY:Int = 0;

	var dadCamX:Int = 0;
	var dadCamY:Int = 0;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var healthPercent:Float = 0;
	private var combo:Int = 0;
	private var maxCombo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	var bg:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var ayehAye:String = "inputOne";
	private var keyInputs:FlxSprite;
	private var notewiggler:WiggleEffect = new WiggleEffect();

	public var camHUD:FlxCamera;

	private var camDialog:FlxCamera;
	private var camHUDX:Float = 0;
	private var camHUDZOOM:Float = 1;
	private var defNOTESZOOM:Float = 1;
	var isDropped:Bool = false;
	private var camNOTES:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var enddialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var isChangingTheAngle:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var whiteeh:FlxSprite;
	var cyanneh:FlxSprite;
	var flashy:FlxSprite;
	var cloudBop:FlxSprite;
	var bgMom:FlxSprite;
	var bgDad:FlxSprite;
	var bge:FlxSprite;
	var bopshit:FlxSprite;
	var devBops:FlxSprite;

	var gfP3:Bool = false;

	var missedPaws:Int = 0;

	var fc:Bool = true;
	var songPercent:Float = 0;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var wheegel:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var zoomWhileSinging:Float = 0;
	var fakeCamZoom:Float;
	var defaultCamAngle:Float;

	public static var daPixelZoom:Float = 6;

	var outsideCityLights:FlxTypedGroup<FlxSprite>;

	var notPlayingCsAnim:Bool = true;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	var zoomAtSinging:Bool = false;

	public var woofAlreadyDone:Bool = false;

	private var heartsThings:FlxSpriteGroup = new FlxSpriteGroup();

	var inDropSong:Bool = false;

	var floatshit:Float = 0;

	var floatbruh:Float = 0;

	var floathuh:Float = 0;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;

	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;

	// Per song additive offset
	public static var songOffset:Float = 0;

	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff

	public function addObject(object:FlxBasic)
	{
		add(object);
	}

	public function removeObject(object:FlxBasic)
	{
		remove(object);
	}

	override public function create()
	{
		instance = this;

		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}
		var originalXPos:Float = 35;

		if (FlxG.save.data.middlescroll)
			originalXPos = -278;

		strumXPOS = originalXPos;

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialog = new FlxCamera();
		camDialog.bgColor.alpha = 0;
		FlxG.camera.bgColor.alpha = 0;
		camNOTES = new FlxCamera();
		camNOTES.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialog);
		FlxG.cameras.add(camNOTES);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: '
			+ Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);

		// dialogue shit
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dad battle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'byte':
				dialogue = CoolUtil.coolTextFile(Paths.txt('byte/dialog'));
			case 'woof':
				dialogue = CoolUtil.coolTextFile(Paths.txt('woof/moredialog'));
			case 'howl':
				dialogue = CoolUtil.coolTextFile(Paths.txt('howl/omgmoredialog'));
				enddialogue = CoolUtil.coolTextFile(Paths.txt('howl/lastdialogue'));
			case 'hello uwu':
				dialogue = CoolUtil.coolTextFile(Paths.txt('hello uwu/dialog'));
		}

		switch (SONG.stage)
		{
			case 'halloween':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					isHalloween = true;
				}
			case 'philly':
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if (FlxG.save.data.distractions)
					{
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
					if (FlxG.save.data.distractions)
					{
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
					add(street);
				}
			case 'limo':
				{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if (FlxG.save.data.distractions)
					{
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
					// add(limo);
				}
			case 'mall':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						add(upperBoppers);
					}

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						add(bottomBoppers);
					}

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if (FlxG.save.data.distractions)
					{
						add(santa);
					}
				}
			case 'mallEvil':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
					evilSnow.antialiasing = true;
					add(evilSnow);
				}
			case 'school':
				{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
					{
						if (FlxG.save.data.distractions)
						{
							bgGirls.getScared();
						}
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						add(bgGirls);
					}
				}
			case 'schoolEvil':
				{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
						var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
						bg.scale.set(6, 6);
						// bg.setGraphicSize(Std.int(bg.width * 6));
						// bg.updateHitbox();
						add(bg);
						var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
						fg.scale.set(6, 6);
						// fg.setGraphicSize(Std.int(fg.width * 6));
						// fg.updateHitbox();
						add(fg);
						wiggleShit.effectType = WiggleEffectType.DREAMY;
						wiggleShit.waveAmplitude = 0.01;
						wiggleShit.waveFrequency = 60;
						wiggleShit.waveSpeed = 0.8;
					 */

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
						var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
						var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
						// Using scale since setGraphicSize() doesnt work???
						waveSprite.scale.set(6, 6);
						waveSpriteFG.scale.set(6, 6);
						waveSprite.setPosition(posX, posY);
						waveSpriteFG.setPosition(posX, posY);
						waveSprite.scrollFactor.set(0.7, 0.8);
						waveSpriteFG.scrollFactor.set(0.9, 0.8);
						// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
						// waveSprite.updateHitbox();
						// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
						// waveSpriteFG.updateHitbox();
						add(waveSprite);
						add(waveSpriteFG);
					 */
				}
			case 'stage':
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
			case 'outside':
				{
					fakeCamZoom = 1.11;
					defaultCamZoom = 0.8;
					zoomWhileSinging = 0.9;
					curStage = 'outside';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backSky'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;

					cloudBop = new FlxSprite(bg.x + 60, bg.y + 90);
					cloudBop.frames = Paths.getSparrowAtlas('cloudAnim');
					cloudBop.animation.addByPrefix('bopbop', 'cloudAnim', 24, false);
					cloudBop.antialiasing = true;
					cloudBop.scrollFactor.set(0.9, 0.9);

					add(bg);
					add(cloudBop);

					switch (SONG.song.toLowerCase())
					{
						case 'milf':
							bgMom = new FlxSprite(bg.x + 200, bg.y + 200);
							bgMom.frames = Paths.getSparrowAtlas('characters/Mom_Assets');
							bgMom.animation.addByPrefix('momDance', 'Mom Idle', 24, false);
							bgMom.animation.play('momDance');
							bgMom.antialiasing = true;
							bgMom.scrollFactor.set(0.9, 0.9);

							bgDad = new FlxSprite(bg.x + 1880, bg.y + 210);
							bgDad.frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
							bgDad.animation.addByPrefix('dadDance', 'Dad idle dance', 24, false);
							bgDad.animation.play('dadDance');
							bgDad.antialiasing = true;
							bgDad.scrollFactor.set(0.9, 0.9);
							bgDad.flipX = true;

							add(bgMom);
							add(bgDad);
						case 'howl':
							bopshit = new FlxSprite(bg.x + 220, bg.y + 860);
							bopshit.frames = Paths.getSparrowAtlas('bopanims');
							bopshit.animation.addByPrefix('bopbop', 'fewPeopleBop', 24, false);
							bopshit.antialiasing = true;
							bopshit.setGraphicSize(Std.int(bopshit.width * 1.1));
							bopshit.scrollFactor.set(0.9, 0.9);

							devBops = new FlxSprite(bg.x + 250,bg.y + 250);
							devBops.frames = Paths.getSparrowAtlas('coreDevBGBop');
							devBops.animation.addByPrefix('meow', 'coreDevBop', 25, false);
							devBops.antialiasing = true;
							devBops.setGraphicSize(Std.int(devBops.width * 0.9));
							devBops.scrollFactor.set(0.9, 0.9);

							cyanneh = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.BLACK);
							cyanneh.alpha = 0;
		
							flashy = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.WHITE);
							flashy.alpha = 0;

							add(cyanneh);
							add(flashy);

							add(devBops);

						case 'split ex':
							bge = new FlxSprite(-600, -200);
							bge.frames = Paths.getSparrowAtlas('stage-split');
							bge.animation.addByPrefix('anm', 'stageAnima', 24, false);
							bge.animation.play('anm', true);
							bge.antialiasing = true;
							bge.scrollFactor.set(1, 1);
							bge.active = true;
							add(bge);
						case 'heartbass':
							add(heartsThings);
					}
				}
			case 'bytestage':
				{
					defaultCamZoom = 0.8;
					defaultCamAngle = 0;
					curStage = 'bytestage';
					whiteeh = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.WHITE);
					add(whiteeh);

					cyanneh = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.CYAN);
					cyanneh.alpha = 0;
					add(cyanneh);
				}
			default:
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
		}
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-heart':
				gfVersion = 'gf-heart';
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'bf' | 'bf-cool':
				dad.y += 350;
			case 'gf':
				if (SONG.player1 == "gf")
					dad.setPosition(100, gf.y);
				else
					dad.setPosition(gf.x, gf.y);

				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if (FlxG.save.data.distractions)
				{
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if (FlxG.save.data.distractions)
				{
					// trailArea.scrollFactor.set();
					var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
					// evilTrail.changeValuesEnabled(false, false, false, false);
					// evilTrail.changeGraphic()
					add(evilTrail);
					// evilTrail.scrollFactor.set(1.1, 1.1);
				}

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'outside':
				if (SONG.song.toLowerCase() == 'split ex')
				{
					boyfriend.x += 50;
					gf.x += 400;
					dad.x -= 100;
					gf.visible = false;
				} else{
					dad.x -= 150;
					boyfriend.x += 100;
				}
		}

		add(gf);

		switch (SONG.player1)
		{
			case "gf":
				boyfriend.setPosition(gf.x, gf.y);
				gf.visible = false;
				boyfriend.flipX = false;
		}

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		if (SONG.player1 != "gf")
		{
			add(dad);
			add(boyfriend);
		}
		else
		{
			add(boyfriend);
			add(dad);
		}

		if (SONG.song.toLowerCase() == 'split')
		{
			gf.scrollFactor.set(1, 1);
			dad.scrollFactor.set(1, 1);
			boyfriend.scrollFactor.set(1, 1);
		}
		if (curStage == 'outside' && SONG.song.toLowerCase() == 'howl')
		{
			add(bopshit);
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);

			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(strumXPOS, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		onScreenInputs = new FlxTypedGroup<FlxSprite>();
		add(onScreenInputs);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		var songPosBGWIDTH:Float = 0;
		var songPosBGHEIGHT:Float = 0;

		if (FlxG.save.data.songPosition)
		{
			songPosBG = new FlxSprite(0, 20).loadGraphic(Paths.image('healthBar'));
			songPosBGWIDTH = songPosBG.width * 0.6;
			songPosBGHEIGHT = songPosBG.height;
			songPosBG.setGraphicSize(Std.int(songPosBG.width * 0.6), Std.int(songPosBG.height));
			songPosBG.screenCenter(X);
			songPosBG.antialiasing = true;
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 35;

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBGWIDTH - 8), Std.int(songPosBGHEIGHT - 8), this,
				'songPercent', 0, 1);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.screenCenter(X);
			songPosBar.antialiasing = true;
			songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
			add(songPosBar);

			songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, "", 26);

			songName.y -= 5;
			songName.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			songName.borderSize = 2;
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.88).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 80;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (!offsetTesting)
			add(healthBarBG);

		var colorp1:FlxColor = 0xFF66FF33;
		var colorp2:FlxColor = 0xFFFF0000;

		switch (SONG.player1)
		{
			case 'bf' | 'bf-cool':
				colorp1 = FlxColor.fromRGB(81, 166, 235);
			case 'gf':
				colorp1 = FlxColor.fromRGB(108, 14, 10);
			case 'byte' | 'byte-cool':
				colorp1 = FlxColor.fromRGB(0, 85, 255);
			case 'pico':
				colorp1 = FlxColor.fromRGB(253, 105, 34);
		}

		switch (SONG.player2)
		{
			case 'bf' | 'bf-cool':
				colorp2 = FlxColor.fromRGB(81, 166, 235);
			case 'gf':
				colorp2 = FlxColor.fromRGB(108, 14, 10);
			case 'byte' | 'byte-cool':
				colorp2 = FlxColor.fromRGB(0, 85, 255);
			case 'pico':
				colorp2 = FlxColor.fromRGB(253, 105, 34);
		}

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(colorp2, colorp1);
		// healthBar
		if (!offsetTesting)
			add(healthBar);

		//score here

		//uhh;


		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}

		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 2;

		if (FlxG.save.data.botplay && !loadRep)
			add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.setGraphicSize(Std.int(iconP1.width * 1.3));
		if (!offsetTesting)
			add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP1.setGraphicSize(Std.int(iconP1.width * 1.3));
		if (!offsetTesting)
			add(iconP2);

		switch (FlxG.save.data.scoreStyle)
		{
			case 'ByteWolf':
				// scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
				scoreTxt = new FlxText(20, 300, 999, "", 24);
				// if (!FlxG.save.data.accuracyDisplay)
				//	scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				scoreTxt.antialiasing = true;
				if (offsetTesting)
					scoreTxt.screenCenter(X);
				if (!FlxG.save.data.botplay)
					add(scoreTxt);
			case 'Kade Engine':
				scoreTxt = new FlxText(FlxG.width / 2 - 225, healthBarBG.y + 50, FlxG.width, "", 20);
				if (!FlxG.save.data.accuracyDisplay)
					scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				scoreTxt.antialiasing = true;
				if (offsetTesting)
					scoreTxt.x += 300;
				if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
				add(scoreTxt);
		}

		scoreTxt.borderSize = 1.5;

		notewiggler.effectType = WiggleEffectType.DREAMY;
		notewiggler.waveAmplitude = 0.01;
		notewiggler.waveFrequency = 60;
		notewiggler.waveSpeed = 0.8;

		if (SONG.song.toLowerCase() == 'milf' || SONG.song.toLowerCase() == 'run')
		{
			strumLineNotes.cameras = [camNOTES];
			grpNoteSplashes.cameras = [camNOTES];
			notes.cameras = [camNOTES];
		}
		else
		{
			strumLineNotes.cameras = [camHUD];
			grpNoteSplashes.cameras = [camHUD];
			notes.cameras = [camHUD];
		}
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		// botPlayState.cameras = [camHUD];

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.radialBlur]);
		// ShadersHandler.setChrome(0);

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
				case "byte":
					schoolIntro(doof);
				/*var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
									add(blackScreen);
									blackScreen.scrollFactor.set();
									camHUD.visible = false;

									new FlxTimer().start(0.1, function(tmr:FlxTimer)
									{
										remove(blackScreen);
										camFollow.y = 300;
										camFollow.x += 100;
										dad.playAnim('blep', true);
										gf.playAnim('cheer', true);
										boyfriend.playAnim('hey', true);
										FlxG.camera.focusOn(camFollow.getPosition());
										FlxG.camera.zoom = 1.5;

										new FlxTimer().start(0.8, function(tmr:FlxTimer)
										{
											camHUD.visible = true;
											remove(blackScreen);
											FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
												ease: FlxEase.quadInOut,
												onComplete: function(twn:FlxTween)
												{
													dad.playAnim('idle');
													gf.playAnim('danceRight', true);
													boyfriend.playAnim('idle', true); 
												}
											});
										});
				});*/

				case "woof":
					schoolIntro(doof);
				case "howl":
					schoolIntro(doof);
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		var byteIntro:FlxSprite = new FlxSprite();
		byteIntro.frames = Paths.getSparrowAtlas('bytecutescene', 'shared');
		byteIntro.animation.addByPrefix('idle', 'Byte Cutscene', 24, false);
		// byteIntro.setGraphicSize(Std.int(byteIntro.width * 6));
		byteIntro.antialiasing = true;
		byteIntro.scrollFactor.set();
		byteIntro.updateHitbox();
		// byteIntro.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}
		if (SONG.song.toLowerCase() == 'byte')
		{
			camHUD.visible = false;
			// FlxG.camera.follow(dad);
			FlxG.camera.zoom = fakeCamZoom;
			FlxG.camera.focusOn(gf.getGraphicMidpoint());
			camFollow.x = dad.x + 300;
			camFollow.y = dad.getGraphicMidpoint().y - 100;
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
			remove(black);
			dad.playAnim('cutscene', true);
			boyfriend.playAnim('cutscene', true);
			gf.playAnim('cutscene', true);
			gf.alpha = 0;
			dad.animation.pause();
			boyfriend.animation.pause();
			gf.animation.pause();
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					if (SONG.song.toLowerCase() == 'byte')
					{
						new FlxTimer().start(0.9, function(w3:FlxTimer)
						{
							dad.playAnim('cutscene', true);
							boyfriend.playAnim('cutscene', true);
							gf.playAnim('cutscene', true);
						});

						new FlxTimer().start(1.84, function(w1:FlxTimer)
						{
							camFollow.x = boyfriend.getGraphicMidpoint().x;
							camFollow.y = boyfriend.getGraphicMidpoint().y;
							FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
						});

						new FlxTimer().start(5.53, function(w2:FlxTimer)
						{
							camFollow.x = dad.x + 300;
							camFollow.y = dad.getGraphicMidpoint().y - 100;
							FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
						});

						new FlxTimer().start(7.15, function(w3:FlxTimer)
						{
							camFollow.x = boyfriend.getGraphicMidpoint().x;
							camFollow.y = boyfriend.getGraphicMidpoint().y;
							FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
						});

						new FlxTimer().start(8.20, function(w4:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 1, {ease: FlxEase.circOut});
							FlxTween.tween(gf, {alpha: 1}, 3, {ease: FlxEase.linear});
						});

						new FlxTimer().start(9.46, function(w3:FlxTimer)
						{
							camFollow.x = gf.getGraphicMidpoint().x - 100;
							camFollow.y = gf.getGraphicMidpoint().y;
							FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
						});

						FlxG.sound.play(Paths.sound('bytesoundanim'), 1, false, null, true, function()
						{
							dad.animation.pause();
							boyfriend.animation.pause();
							gf.animation.pause();
							add(dialogueBox);
							camHUD.visible = true;
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;
		camHUD.visible = true;
		generateStaticArrows(0);
		generateStaticArrows(1);

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start', [PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.playAnim('idle');
			// dad.dance();
			gf.dance();

			if (SONG.song.toLowerCase() != 'byte')
				boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		if (SONG.song.toLowerCase() == 'byte')
		{
			notPlayingCsAnim = false;
			boyfriend.playAnim('prepareSing', true);
		}

		camHUD.visible = true;
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;

		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Song check real quick
		switch (curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog':
				allowedToHeadbang = true;
			default:
				allowedToHeadbang = false;
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
		var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
		for (file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if (!sys.FileSystem.isDirectory(path))
			{
				if (path.endsWith('.offset'))
				{
					trace('Found offset file: ' + path);
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					break;
				}
				else
				{
					trace('Offset file not found. Creating one @: ' + songPath);
					sys.io.File.saveContent(songPath + songOffset + '.offset', '');
				}
			}
		}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];

				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(strumXPOS, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'reversedarrow':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_reversedcolor');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}
			babyArrow.ID = i;

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (FlxG.save.data.botplay)
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.centerOffsets();
				});

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); // CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.circOut});
	}

	function tweenCamOut():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.circOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"Acc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					songLength
					- Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;
	var fadeNext:Bool = false;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.FIVE)
			camHUD.visible = !camHUD.visible;

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.F8)
			botPlayState.visible = !botPlayState.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos', Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom', FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}


			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle', 'float');

			if (luaModchart.getVar("showOnlyStrums", 'bool'))
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible", 'bool');
			var p2 = luaModchart.getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}
		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length - 1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		// if (FlxG.keys.justPressed.NINE)
		// {
		//	if (iconP1.animation.curAnim.name == 'bf-old')
		//		iconP1.animation.play(SONG.player1);
		//	else
		//		iconP1.animation.play('bf-old');
		// }

		if (doGlitch)
		{
			// ShadersHandler.setChrome(FlxG.random.int(2,6)/1000);
			// ShadersHandler.setRadialBlur(640, 360,  FlxG.random.float(0.001, 0.01));
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);



		coolOverlay.alpha = FlxMath.lerp(0, coolOverlay.alpha, 0.97);

		floatshit += 0.05;
		floatbruh += 0.05;
		floathuh += 0.03;

		if (combo > maxCombo)
			maxCombo = combo;

		if (!offsetTesting)
			switch (FlxG.save.data.scoreStyle)
			{
				case 'ByteWolf':
					scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy)
						+ "\nHealth: "
						+ healthPercent
						+ "%"
						+ "\nCombo: "
						+ combo
						+ "x"
						+ " ("
						+ "Max "
						+ maxCombo
						+ "x"
						+ ")"
						+ "\n"
						+ "Song: "
						+ SONG.song.toUpperCase()
						+ " - "
						+ storyDifficultyText.toUpperCase();		
				case 'Kade Engine':
					scoreTxt.text = Ratings.CalculateRankingE(songScore, songScoreDef, nps, maxNPS, accuracy)
					+ " | Health: "
					+ healthPercent
					+ "%";			

					scoreTxt.screenCenter(X);
			}

		else
			scoreTxt.text = "New offset: " + offsetTest;
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else if (offsetTesting)
			{
				PauseSubState.isOffsetTesting = true;
			}

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		if (FlxG.sound.music.playing)
		{
			if (boyfriend.animation.curAnim.name == 'prepareSing' && boyfriend.animation.curAnim.finished)
				notPlayingCsAnim = true;
		}

		if (SONG.song.toLowerCase() == 'milf')
		{
			if (!inDropSong)
				camNOTES.x += Math.sin(floatbruh);

			if (curBeat >= 72)
			{
				healthBarBG.x += Math.sin(floatbruh);
				healthBar.x += Math.sin(floatbruh);
				scoreTxt.x += Math.sin(floatbruh);
			}
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.89)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.89)));

		// hardcoded cuz i'm dumb lol
		if (SONG.song.toLowerCase() == 'howl')
		{
			if (!isChangingTheAngle)
				camHUD.angle = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * -1.0) * 2.0;

			for (i in 0...strumLineNotes.length)
			{
				if (FlxG.save.data.downscroll)
				{
					strumLineNotes.members[i].y = (FlxMath.lerp(FlxG.height - 165, strumLineNotes.members[i].y, 0.95));
				}
				else
				{
					strumLineNotes.members[i].y = (FlxMath.lerp(50, strumLineNotes.members[i].y, 0.95));
				}
				strumLineNotes.members[i].x = (FlxMath.lerp(50 + strumXPOS + (i * strumLineNotes.members[i].width), strumLineNotes.members[i].x, 0.95));
			}

			for (i in 0...playerStrums.length)
			{
				if (FlxG.save.data.downscroll)
				{
					playerStrums.members[i].y = (FlxMath.lerp(FlxG.height - 165, playerStrums.members[i].y, 0.95));
				}
				else
				{
					playerStrums.members[i].y = (FlxMath.lerp(50, playerStrums.members[i].y, 0.95));
				}
				playerStrums.members[i].x = (FlxMath.lerp(870 + strumXPOS + (i * playerStrums.members[i].width), playerStrums.members[i].x, 0.95));
			}
		}
		if (SONG.song.toLowerCase() == 'milf')
		{
			for (i in 0...strumLineNotes.length)
			{
				if (FlxG.save.data.downscroll)
				{
					strumLineNotes.members[i].y = (FlxMath.lerp(FlxG.height - 165, strumLineNotes.members[i].y, 0.95));
				}
				else
				{
					strumLineNotes.members[i].y = (FlxMath.lerp(50, strumLineNotes.members[i].y, 0.95));
				}
				strumLineNotes.members[i].x = (FlxMath.lerp(50 + strumXPOS + (i * strumLineNotes.members[i].width), strumLineNotes.members[i].x, 0.95));
			}

			for (i in 0...playerStrums.length)
			{
				if (FlxG.save.data.downscroll)
				{
					playerStrums.members[i].y = (FlxMath.lerp(FlxG.height - 165, playerStrums.members[i].y, 0.95));
				}
				else
				{
					playerStrums.members[i].y = (FlxMath.lerp(50, playerStrums.members[i].y, 0.95));
				}
				playerStrums.members[i].x = (FlxMath.lerp(870 + strumXPOS + (i * playerStrums.members[i].width), playerStrums.members[i].x, 0.95));
			}
		}

		if (FlxG.save.data.middlescroll)
			{
				for (i in 0...cpuStrums.length)
					{
						cpuStrums.members[i].alpha = 0;
					}
			}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (flashy != null)
			flashy.alpha = (FlxMath.lerp(0, flashy.alpha, 0.95));

		if (health > 2)
			health = 2;

		healthPercent = healthBar.percent;

		if (healthBar.percent < 20)
		{
			if (SONG.player2.toLowerCase() == "byte" || SONG.player2.toLowerCase() == "byte-cool")
			{
				iconP2.animation.curAnim.curFrame = 2;
			}
			iconP1.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		if (healthBar.percent > 80)
		{
			if (SONG.player1.toLowerCase() == "byte" || SONG.player1.toLowerCase() == "bf" || SONG.player1.toLowerCase() == "gf")
			{
				iconP1.animation.curAnim.curFrame = 2;
			}
			iconP2.animation.curAnim.curFrame = 1;
		}
		else
		{
			// iconP1.animation.curAnim.curFrame = 0;
			// iconP2.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		// #if debug

		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		FlxG.camera.height = FlxG.height;
		FlxG.camera.width = FlxG.width;

		// #end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
				{
					startSong();
					Conductor.songPosition = FlxG.sound.music.time;
					vocals.time = Conductor.songPosition;
				}
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
				{
					FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if (FlxG.save.data.songPosition)
				{
					var curTime:Float = FlxG.sound.music.time - songOffset;
					if (curTime < 0)
						curTime = 0;
					songPercent = (curTime / songLength);

					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if (secondsTotal < 0)
						secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if (secondsRemaining.length < 2)
						secondsRemaining = '0' + secondsRemaining; // Dunno how to make it display a zero first in Haxe lol
					songName.text = minutesRemaining + ':' + secondsRemaining;

					songName.screenCenter(X);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if (allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if (gf.animation.curAnim.name == 'danceLeft'
					|| gf.animation.curAnim.name == 'danceRight'
					|| gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch (curSong)
					{
						case 'Philly':
							{
								// General duration of the song
								if (curBeat < 250)
								{
									// Beats to skip or to stop GF from cheering
									if (curBeat != 184 && curBeat != 216)
									{
										if (curBeat % 16 == 8)
										{
											// Just a garantee that it'll trigger just once
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Bopeebo':
							{
								// Where it starts || where it ends
								if (curBeat > 5 && curBeat < 130)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
						case 'Blammed':
							{
								if (curBeat > 30 && curBeat < 190)
								{
									if (curBeat < 90 || curBeat > 128)
									{
										if (curBeat % 4 == 2)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Cocoa':
							{
								if (curBeat < 170)
								{
									if (curBeat < 65 || curBeat > 130 && curBeat < 145)
									{
										if (curBeat % 16 == 15)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'Eggnog':
							{
								if (curBeat > 10 && curBeat != 111 && curBeat < 220)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
					}
				}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit", PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection
				&& SONG.player2.toLowerCase() == 'byte-cool'
				&& SONG.notes[Std.int(curStep / 16)].altAnim)
			{
				gfP3 = true;
			}
			else
			{
				gfP3 = false;
			}
			if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && SONG.player2.toLowerCase() == 'byte-cool')
			{
				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !gfP3)
				{
					var offsetX = 0;
					var offsetY = 0;
					#if windows
					if (luaModchart != null)
					{
						offsetX = luaModchart.getVar("followXOffset", "float");
						offsetY = luaModchart.getVar("followYOffset", "float");
					}
					#end
					camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
					// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

					switch (dad.curCharacter)
					{
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'senpai':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'senpai-angry':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
					}

					if (dad.curCharacter == 'mom')
						vocals.volume = 1;
				}
				else if (camFollow.x != gf.getMidpoint().x && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && gfP3)
				{
					var offsetX = 0;
					var offsetY = 0;
					#if windows
					if (luaModchart != null)
					{
						offsetX = luaModchart.getVar("followXOffset", "float");
						offsetY = luaModchart.getVar("followYOffset", "float");
					}
					#end
					camFollow.setPosition(gf.getMidpoint().x - 150 + offsetX, gf.getMidpoint().y - 100 + offsetY);
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
					// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

					switch (dad.curCharacter)
					{
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'senpai':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'senpai-angry':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
					}

					if (dad.curCharacter == 'mom')
						vocals.volume = 1;
				}
			}
			else
			{
				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					var offsetX = 0;
					var offsetY = 0;
					#if windows
					if (luaModchart != null)
					{
						offsetX = luaModchart.getVar("followXOffset", "float");
						offsetY = luaModchart.getVar("followYOffset", "float");
					}
					#end
					camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
					// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

					switch (dad.curCharacter)
					{
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'senpai':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'senpai-angry':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
					}

					if (dad.curCharacter == 'mom')
						vocals.volume = 1;
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100 + bfCamX)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'outside':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						// camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(camHUDZOOM, camHUD.zoom, 0.95);
			FlxG.camera.angle = FlxMath.lerp(0, FlxG.camera.angle, 0.95);
			if (isChangingTheAngle)
				camHUD.angle = FlxMath.lerp(0, camHUD.angle, 0.95);

			camHUD.x = FlxMath.lerp(camHUDX, camHUD.x, 0.95);
			FlxG.camera.x = FlxMath.lerp(0, FlxG.camera.x, 0.95);
		}
		if (inDropSong)
		{
			camNOTES.x = FlxMath.lerp(0, camNOTES.x, 0.95);
		}

		camNOTES.zoom = FlxMath.lerp(defNOTESZOOM, camNOTES.zoom, 0.80);
		camNOTES.angle = FlxMath.lerp(0, camNOTES.angle, 0.95);

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			if (missedPaws >= 0)
			{
			}

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, gf.getScreenPosition().x,
				gf.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"\nAcc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		if (FlxG.save.data.resetButton)
		{
			if (FlxG.keys.justPressed.R)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, gf.getScreenPosition().x,
					gf.getScreenPosition().y));

				#if windows
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("GAME OVER -- "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: "
					+ HelperFunctions.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC);
				#end

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.modifiedByLua)
				{
					if (FlxG.save.data.downscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2));
						if (daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (!FlxG.save.data.botplay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2));
						if (daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							if (!FlxG.save.data.botplay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
									&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 2:
							if (!gfP3)
								dad.playAnim('singUP' + altAnim, true);
							else
								gf.playAnim('singUP', true);
							dadCamY = -25;
							dadCamX = 0;
							strumLineNotes.members[2].animation.play('confirm', true);
							strumLineNotes.members[2].centerOffsets();
							strumLineNotes.members[2].offset.x -= 13;
							strumLineNotes.members[2].offset.y -= 13;
							if (SONG.song.toLowerCase() == 'milf')
								health -= 0.020;

							if (SONG.song.toLowerCase() == 'split ex')
							{
								if (healthBar.percent > 10)
									health -= 0.05;
							}

							if (isDropped)
							{
								FlxG.camera.shake(0.015, 0.1);
								camHUD.shake(0.015, 0.1);
							}
						case 3:
							dadCamY = 0;
							dadCamX = 50;
							if (!gfP3)
								dad.playAnim('singRIGHT' + altAnim, true);
							else
								gf.playAnim('singRIGHT', true);
							strumLineNotes.members[3].animation.play('confirm', true);
							strumLineNotes.members[3].centerOffsets();
							strumLineNotes.members[3].offset.x -= 13;
							strumLineNotes.members[3].offset.y -= 13;
							if (SONG.song.toLowerCase() == 'milf')
								health -= 0.020;

							if (SONG.song.toLowerCase() == 'split ex')
							{
								if (healthBar.percent > 10)
									health -= 0.05;
							}
							if (isDropped)
							{
								FlxG.camera.shake(0.015, 0.1);
								camHUD.shake(0.015, 0.1);
							}
						case 1:
							dadCamX = 0;
							dadCamY = 25;
							if (!gfP3)
								dad.playAnim('singDOWN' + altAnim, true);
							else
								gf.playAnim('singDOWN', true);
							strumLineNotes.members[1].animation.play('confirm', true);
							strumLineNotes.members[1].centerOffsets();
							strumLineNotes.members[1].offset.x -= 13;
							strumLineNotes.members[1].offset.y -= 13;
							if (SONG.song.toLowerCase() == 'milf')
								health -= 0.020;

							if (SONG.song.toLowerCase() == 'split ex')
							{
								if (healthBar.percent > 10)
									health -= 0.05;
							}
							if (isDropped)
							{
								FlxG.camera.shake(0.015, 0.1);
								camHUD.shake(0.015, 0.1);
							}
						case 0:
							dadCamX = -25;
							dadCamY = 0;
							if (!gfP3)
								dad.playAnim('singLEFT' + altAnim, true);
							else
								gf.playAnim('singLEFT', true);
							strumLineNotes.members[0].animation.play('confirm', true);
							strumLineNotes.members[0].centerOffsets();
							strumLineNotes.members[0].offset.x -= 13;
							strumLineNotes.members[0].offset.y -= 13;
							if (SONG.song.toLowerCase() == 'milf')
								health -= 0.020;

							if (SONG.song.toLowerCase() == 'split ex')
							{
								if (healthBar.percent > 10)
									health -= 0.05;
							}
							if (isDropped)
							{
								FlxG.camera.shake(0.015, 0.1);
								camHUD.shake(0.015, 0.1);
							}
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
					#end

					if (!gfP3)
						dad.holdTimer = 0;
						else
						gf.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;

					var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
					var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress && !daNote.modifiedByLua)
				{
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}
				else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
				{
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}

				if (daNote.isSustainNote)
					daNote.x += daNote.width / 2 + 17;

				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll)
					&& daNote.mustPress)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if (daNote.noteType == 2)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							health -= 10;
							missedPaws += 1;
							GameOverSubstate.diedCuzPaws = true;
						}
						if (daNote.noteType == 1 || daNote.noteType == 0)
						{
							if (!offsetTesting)
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			});
		}

		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished)
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});

		if (!inCutscene)
			keyShit();

		if (FlxG.save.data.animdebugsave)
			if (FlxG.keys.justPressed.ONE)
				endSong();
	}

	function endSong():Void
	{
		var doNotNot:Bool = false;
		var oof:DialogueBox = new DialogueBox(false, enddialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		oof.scrollFactor.set();
		oof.finishThing = endanims;
		oof.cameras = [camDialog];

		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			// FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (SONG.song.toLowerCase() == 'howl')
					{
						persistentUpdate = false;
						persistentDraw = false;
						paused = true;
						doNotNot = true;

						dad.animation.pause();
						gf.animation.pause();
						boyfriend.animation.pause();

						cloudBop.animation.pause();
						bopshit.animation.pause();

						Conductor.changeBPM(1);

						vocals.pause();
						FlxG.sound.music.pause();
						schoolOutro(oof);
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));

						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;

						FlxG.switchState(new StoryMenuState());

						#if windows
						if (luaModchart != null)
						{
							luaModchart.die();
							luaModchart = null;
						}
						#end

						// if ()
						StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

						if (SONG.validScore)
						{
							NGio.unlockMedal(60961);
							Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
						FlxG.save.flush();
					}
				}
				else
				{
					if (!doNotNot)
					{
						var difficulty:String = "";

						if (storyDifficulty == 0)
							difficulty = '-easy';

						if (storyDifficulty == 2)
							difficulty = '-hard';

						trace('LOADING NEXT SONG');
						trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

						if (SONG.song.toLowerCase() == 'eggnog')
						{
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;

							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
						}

						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						prevCamFollow = camFollow;

						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();

						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	function schoolOutro(?dialogueBox:DialogueBox):Void
	{
		// camHUD.visible = false;
		var blackc:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.BLACK);
		blackc.scrollFactor.set();
		add(blackc);
		blackc.cameras = [camDialog];

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			blackc.alpha -= 0.15;

			if (blackc.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				camFollow.x = gf.x + 300;
				camFollow.y = gf.getGraphicMidpoint().y - 100;
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
				inCutscene = true;
				add(dialogueBox);

				dialogueBox.finishThing = endanims;
			}
		});
	}

	function endanims():Void
	{
		dad.playAnim('idle', true);
		FlxTween.tween(boyfriend, {alpha: 0}, 0.5, {ease: FlxEase.linear});
		FlxTween.tween(gf, {alpha: 0}, 0.5, {ease: FlxEase.linear});
		new FlxTimer().start(1, function(wawaw:FlxTimer)
		{
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
			dad.playAnim('idle', true);
			camFollow.x = dad.x + 300;
			camFollow.y = dad.getGraphicMidpoint().y - 100;
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
			new FlxTimer().start(1, function(wwwww:FlxTimer)
			{
				var fadeFade:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3000, 3000, FlxColor.BLACK);
				fadeFade.alpha = 0;
				FlxTween.tween(fadeFade, {alpha: 1}, 1, {ease: FlxEase.linear});
				new FlxTimer().start(2, function(wwwww:FlxTimer)
				{
					FlxG.switchState(new ThankYouState());
				});
			});
		});
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note, isSustain:Bool):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.85;
		coolText.y -= 350;
		coolText.cameras = [camHUD];
		//

		var daRating = daNote.rating;

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;
		var sickWidth:Float = 0;

		if (FlxG.save.data.accuracyMod == 1)
			totalNotesHit += wife;

		if (isSustain)
			daRating = "sick";

		//      it will check if the note type is 2
		// and the rating is 'sick', it will automatically
		//   changes the 'sick' rating to 'yeah' rating
		if (daNote.noteType == 2 && daNote.rating == 'sick' && !FlxG.save.data.botplay)
			daRating = 'yeah';

		if (FlxG.save.data.botplay)
			{
				daRating = 'sick';

				if (daNote.noteType == 2)
					daRating = 'yeah';
			}

		switch (daRating)
		{
			case 'shit':
				if (daNote.noteType == 2)
				{
					health = 1;
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (!isSustain)
					{
						score = -300;
						// combo = 0;
						// misses++;
						health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					}
				}
			case 'bad':
				if (daNote.noteType == 2)
				{
					health += 0.1;
					FlxG.camera.shake(0.020, 0.1);
					FlxG.sound.play(Paths.sound('paw_hit'));
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (!isSustain)
					{
						daRating = 'bad';
						score = 0;
						health -= 0.06;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
				}
			case 'good':
				if (daNote.noteType == 2)
				{
					health += 0.2;
					FlxG.camera.shake(0.020, 0.1);
					FlxG.sound.play(Paths.sound('paw_hit'));
				}
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (!isSustain)
					{
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
				}
			case 'sick':
				if (daNote.noteType == 1 || daNote.noteType == 0)
				{
					if (!isSustain)
					{
						if (health < 2)
							health += 0.1;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
						if (FlxG.save.data.notesplash)
							spawnNoteSplashOnNote(daNote);

						if (FlxG.save.data.botplay)
							spawnNoteSplashOnNote(daNote);
					}
				}
			case 'yeah':
				// 'yeah' rating is only used for paw notes if
				// the player hits the note in 'sick' rating.
				// so like... 'yeah' is actually 'sick', but
				// used for paw notes.

				health += 0.3;
				FlxG.camera.shake(0.020, 0.1);
				FlxG.sound.play(Paths.sound('paw_hit'));
				spawnNoteSplashOnNote(daNote);
		}

		// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			sickWidth = rating.width;

			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if (FlxG.save.data.botplay)
				msTiming = 0;

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0, 0, 0, "0ms");
			timeShown = 0;
			switch (daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 2;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				// Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for (i in hits)
					total += i;

				offsetTest = HelperFunctions.truncateFloat(total / hits.length, 2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if (!FlxG.save.data.botplay)
				add(currentTimingShown);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			//if (!FlxG.save.data.botplay)
				add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(sickWidth * FlxG.save.data.ratingsize));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();

			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		// Prevent player input if botplay is on
		if (FlxG.save.data.botplay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
					{ // if a direction is hit that shouldn't be
						if (pressArray[shit] && !directionList.contains(shit))
							noteMiss(shit, null);
					}
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!FlxG.save.data.ghost)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit, null);
			}

			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
			{
				if (mashViolations > 4)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0, null);
					mashedKeys();
				}
				else
					mashViolations++;
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if (FlxG.save.data.downscroll && daNote.y > strumLine.y || !FlxG.save.data.downscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if (FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress || FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
				{
					if (loadRep)
					{
						// trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
						if (rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
						{
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
					}
					else
					{
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		if (!FlxG.save.data.botplay)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					spr.animation.play('pressed');
				if (!holdArray[spr.ID])
					spr.animation.play('static');

				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
		}
		else
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
		}
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			// var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			// var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	/*function badNoteCheck()
			{
				// just double pasting this shit cuz fuk u
				// REDO THIS SYSTEM!
				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				if (leftP)
					noteMiss(0);
				if (upP)
					noteMiss(2);
				if (rightP)
					noteMiss(3);
				if (downP)
					noteMiss(1);
				updateAccuracy();
			}
	 */
	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
		}*/

		if (controlArray[note.noteData])
		{
			goodNoteHit(note, (mashing > getKeyPresses(note)));

			/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false); */
		}
	}

	function cpuStrumHit(note:Note)
	{
		strumLineNotes.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(note.noteData) == spr.ID)
			{
				spr.animation.play('confirm', true);
			}
		});
	}

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (isDropped)
		{
			FlxG.camera.shake(0.015, 0.1);
			camHUD.shake(0.015, 0.1);
		}

		if (mashing != 0)
			mashing = 0;

		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		// add newest note to front of notesHitArray
		// the oldest notes are at the end and are removed first
		if (!note.isSustainNote)
			notesHitArray.unshift(Date.now());

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note, false);
				combo += 1;
			}
			else
			{
				songScore += 20;
				popUpScore(note, true);
				combo += 1;
				totalNotesHit += 1;
			}

			if (note.isSustainNote)
				health += 0.030;

			/*				if (note.noteType == 2)
				{
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('pawHit', true);
						case 3:
							boyfriend.playAnim('pawHit', true);
						case 1:
							boyfriend.playAnim('pawHit', true);
						case 0:
							boyfriend.playAnim('pawHit', true);
					}
			}*/

			switch (note.noteData)
			{
				case 2:
					bfCamY = -25;
					if (note.noteType == 2)
					{
						boyfriend.playAnim('pawHit', true);
					}
					if (note.noteType == 1 || note.noteType == 0)
					{
						boyfriend.playAnim('singUP', true);
					}
				case 3:
					bfCamX = 25;
					if (note.noteType == 2)
					{
						boyfriend.playAnim('pawHit', true);
					}
					if (note.noteType == 1 || note.noteType == 0)
					{
						boyfriend.playAnim('singRIGHT', true);
					}
				case 1:
					bfCamY = 25;
					if (note.noteType == 2)
					{
						boyfriend.playAnim('pawHit', true);
					}
					if (note.noteType == 1 || note.noteType == 0)
					{
						boyfriend.playAnim('singDOWN', true);
					}
				case 0:
					bfCamX = -25;
					if (note.noteType == 2)
					{
						boyfriend.playAnim('pawHit', true);
					}
					if (note.noteType == 1 || note.noteType == 0)
					{
						boyfriend.playAnim('singLEFT', true);
					}
			}

			boyfriend.holdTimer = 0;

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
			#end

			if (!loadRep && note.mustPress)
				saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));

			if (FlxG.save.data.botplay)
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true); // smart
					}
				});
				if (!note.isSustainNote)
					spawnNoteSplashOnNote(note);
			}
			else
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
					}
				});
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (FlxG.save.data.distractions)
		{
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.distractions)
		{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if (FlxG.save.data.distractions)
		{
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;
				gf.playAnim('hairBlow');
			}

			if (startedMoving)
			{
				phillyTrain.x -= 400;

				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;

					if (trainCars <= 0)
						trainFinishing = true;
				}

				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note)
	{
		spawnNoteSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData, note.noteType);
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, type:Int)
	{
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, type);
		grpNoteSplashes.add(splash);
	}

	function trainReset():Void
	{
		if (FlxG.save.data.distractions)
		{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var stepZoom:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep', curStep);
			luaModchart.executeState('stepHit', [curStep]);
		}
		#end

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		switch (SONG.song.toLowerCase())
		{
			case 'split ex':
				switch (curStep)
				{
					case 531, 534, 547, 550, 563, 566, 579, 582, 624, 626, 628, 630:
						FlxG.camera.zoom += 0.035;
						camHUD.zoom += 0.04;
				}
		}

		if (stepZoom)
		{
			FlxG.camera.zoom += 0.035;
			camHUD.zoom += 0.04;
			doDisco();
		}

		switch (SONG.song.toLowerCase())
		{
			case 'heartbass':
				if (curBeat > 200 && curBeat < 205 || curBeat > 232 && curBeat < 235 || curBeat > 360 && curBeat < 420)
				{ // yea

					if (curBeat < 360)
						coolHeartShit();
				}
		}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"Acc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			songLength
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var strumMove2nd:Bool = false;
	var rotate2nd:Bool = false;
	var goesRightDone:Bool = false;
	var byteHasFinishedHisSong:Bool = false;
	var bfanimdone:Bool = false;
	var byteDropBeat:Bool = false;
	var camMove1:Bool = true;
	var blackShiet:FlxSprite;
	var doCoolDiscoSwag:Bool = false;

	var isBanger:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat', curBeat);
			luaModchart.executeState('beatHit', [curBeat]);
		}
		#end

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.030;
			camHUD.zoom += 0.06;
			camNOTES.zoom += 0.06;
			doDisco();
		}

		camNOTES.zoom += 0.04;

		if (curSong.toLowerCase() == 'byte' && curBeat >= 48 && curBeat < 52 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
			camNOTES.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'byte' && curBeat >= 52 && curBeat < 56 && camZooming && FlxG.camera.zoom < 2.35)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
			camNOTES.zoom += 0.04;
		}
		if (curSong.toLowerCase() == 'howl' && curBeat >= 96 && curBeat < 128 && camZooming && FlxG.camera.zoom < 1.35)
		{
			isChangingTheAngle = true;
			if (rotate2nd)
			{
				rotate2nd = !rotate2nd;
				FlxG.camera.angle += 5;
				camHUD.angle += 10;
				camNOTES.angle += 10;
			}
			else
			{
				rotate2nd = !rotate2nd;
				FlxG.camera.angle -= 5;
				camHUD.angle -= 10;
				camNOTES.angle -= 10;
			}

			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.06;
			camNOTES.zoom += 0.06;
			// camHUD.shake(0.01,0.1,null,true, X);\
		}
		else
		{
			isChangingTheAngle = false;
		}

		if (curSong.toLowerCase() == 'howl' && curBeat >= 32 && curBeat < 320 && camZooming && FlxG.camera.zoom < 1.35)
		{
			if (curBeat % 2 == 0)
			{
				FlxG.camera.zoom += 0.025;
				camHUD.zoom += 0.06;
				camNOTES.zoom += 0.06;
			}
		}

		if (curSong.toLowerCase() == 'woof' && curBeat >= 80 && curBeat < 111 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.06;
			camNOTES.zoom += 0.06;
		}

		if (!inCutscene)
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				if (!isBanger)
				{
					FlxG.camera.zoom += 0.040;
					camHUD.zoom += 0.04;
					camNOTES.zoom += 0.04;
				}
			}
		}

		if (SONG.song.toLowerCase() == 'split ex')
		{
			if (isBanger)
			{
				FlxG.camera.zoom += 0.06;
				camHUD.zoom += 0.06;
			}
			switch (curBeat)
			{
				case 1:
					add(coolOverlay);
					coolOverlay.alpha = 0;
				case 36:
					isBanger = true;
				case 64:
					isBanger = false;
				case 68:
					isBanger = true;
				case 84:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 100:
					camHUD.flash(FlxColor.WHITE, 0.5);
					doCoolDiscoSwag = true;
				case 116:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 128:
					isBanger = false;
					doCoolDiscoSwag = false;
					FlxG.camera.zoom += 0.035;
					camHUD.zoom += 0.04;
				case 130:
					FlxG.camera.zoom += 0.035;
					camHUD.zoom += 0.04;
				case 148:
					isBanger = true;
				case 158:
					isBanger = false;
					stepZoom = true;
				case 160:
					stepZoom = false;
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 164:
					isBanger = true;
				case 196:
					doCoolDiscoSwag = true;
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 260:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 292:
					isBanger = false;
					doCoolDiscoSwag = false;
				case 322:
					stepZoom = true;
				case 324:
					stepZoom = false;
					isBanger = true;
					doCoolDiscoSwag = true;
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 340:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 388:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 404:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 420:
					isBanger = false;
					doCoolDiscoSwag = false;
				case 436:
					isBanger = true;
				case 446:
					stepZoom = true;
					isBanger = false;
				case 448:
					stepZoom = false;
				case 452:
					isBanger = true;
					doCoolDiscoSwag = true;
				case 468:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 500:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 516:
					vocals.volume = 0;
					camHUD.flash(FlxColor.WHITE, 0.5);
					blackShiet = new FlxSprite(-1000, -1000).makeGraphic(3000, 3000, FlxColor.BLACK);
					add(blackShiet);
					blackShiet.alpha = 0;
					FlxTween.tween(blackShiet, {alpha: 1}, 1, {ease: FlxEase.circOut});

					var ttx:Alphabet = new Alphabet(0, 0, "split ex by ardolf", true, false);
					add(ttx);

					var bruhbb:Alphabet = new Alphabet(0, 0, "from vs bob and bosip fnf mod", true, false);
					add(bruhbb);

					ttx.alpha = 0;
					ttx.scrollFactor.set(0, 0);

					bruhbb.alpha = 0;
					bruhbb.scrollFactor.set(0, 0);
					// ttx.setGraphicSize(Std.int(ttx.width * 0.7));

					FlxTween.tween(ttx, {alpha: 1}, 1, {ease: FlxEase.circOut});
					FlxTween.tween(bruhbb, {alpha: 1}, 1, {ease: FlxEase.circOut});

					// ttx.cameras = [camHUD];
					ttx.screenCenter();
					bruhbb.setPosition(0, ttx.getGraphicMidpoint().y + 100);
					bruhbb.screenCenter(X);
			}

			if (doCoolDiscoSwag)
				doDisco();
		}

		if (SONG.song.toLowerCase() == 'run')
		{
			// FlxG.camera.shake(0.010, 0.1);
			// camHUD.shake(0.030, 0.1);
			FlxG.camera.zoom += 0.030;
			camHUD.zoom += 0.06;

			switch (curBeat)
			{
				case 96:
					isDropped = true;
				case 112:
					isDropped = false;
			}
		}

		// iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		// iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		if (camZooming && curSong.toLowerCase() == 'byte remix')
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.04;
			camNOTES.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'ok')
		{
			gfSpeed = 2;
			if (camZooming)
			{
				/*if (curBeat % 2 == 0)
					{
						FlxG.camera.zoom += 0.015;
						camHUD.zoom += 0.04;
						camNOTES.zoom += 0.04;						
				}*/
			}
		}

		if (curSong.toLowerCase() == 'howl')
		{
			switch (curBeat)
			{
				case 1:
					gfSpeed = 2;
				case 32:
					gfSpeed = 1;
				case 128:
					gfSpeed = 2;
				case 256:
					healthBarMove();
					gfSpeed = 1;
					Application.current.window.title = "Friday Night Howlin': V.S ByteWolf (Not Responding)";
				case 320:
					inDropSong = false;
					gfSpeed = 2;
					healthBarBack();
					byteHasFinishedHisSong = !byteHasFinishedHisSong;
					Application.current.window.title = "Friday Night Howlin': V.S ByteWolf";
			}
		}
		if (curSong.toLowerCase() == 'howl')
		{
			if (!strumMove2nd)
			{
				strumMove2nd = !strumMove2nd;
				strumLineNotes.members[0].y -= 30;
				strumLineNotes.members[1].y -= 30;
				strumLineNotes.members[2].y += 30;
				strumLineNotes.members[3].y += 30;

				playerStrums.members[0].y -= 30;
				playerStrums.members[1].y -= 30;
				playerStrums.members[2].y += 30;
				playerStrums.members[3].y += 30;
			}
			else
			{
				strumMove2nd = !strumMove2nd;
				strumLineNotes.members[0].y += 30;
				strumLineNotes.members[1].y += 30;
				strumLineNotes.members[2].y -= 30;
				strumLineNotes.members[3].y -= 30;

				playerStrums.members[0].y += 30;
				playerStrums.members[1].y += 30;
				playerStrums.members[2].y -= 30;
				playerStrums.members[3].y -= 30;
			}
		}

		if (curSong.toLowerCase() == 'milf')
		{
			if (!strumMove2nd)
			{
				strumMove2nd = !strumMove2nd;
				strumLineNotes.members[0].y += 30;
				strumLineNotes.members[1].y += 30;
				strumLineNotes.members[2].y += 30;
				strumLineNotes.members[3].y += 30;

				playerStrums.members[0].y -= 30;
				playerStrums.members[1].y -= 30;
				playerStrums.members[2].y -= 30;
				playerStrums.members[3].y -= 30;
			}
			else
			{
				strumMove2nd = !strumMove2nd;
				strumLineNotes.members[0].y -= 30;
				strumLineNotes.members[1].y -= 30;
				strumLineNotes.members[2].y -= 30;
				strumLineNotes.members[3].y -= 30;

				playerStrums.members[0].y += 30;
				playerStrums.members[1].y += 30;
				playerStrums.members[2].y += 30;
				playerStrums.members[3].y += 30;
			}
		}

		if (curSong.toLowerCase() == 'howl' && curBeat >= 256 && curBeat < 320)
		{
			cyanneh.alpha = 1;
			flashy.alpha = 0.8;
			if (goesRightDone)
			{
				goesRightDone = !goesRightDone;
				camHUD.x += 50;
				FlxG.camera.x += 50;
				strumLineNotes.members[0].x += 50;
				strumLineNotes.members[1].x += 50;
				strumLineNotes.members[2].x += 50;
				strumLineNotes.members[3].x += 50;

				playerStrums.members[0].x += 50;
				playerStrums.members[1].x += 50;
				playerStrums.members[2].x += 50;
				playerStrums.members[3].x += 50;
			}
			else
			{
				goesRightDone = !goesRightDone;
				camHUD.x -= 50;
				FlxG.camera.x -= 50;
				strumLineNotes.members[0].x -= 50;
				strumLineNotes.members[1].x -= 50;
				strumLineNotes.members[2].x -= 50;
				strumLineNotes.members[3].x -= 50;

				playerStrums.members[0].x -= 50;
				playerStrums.members[1].x -= 50;
				playerStrums.members[2].x -= 50;
				playerStrums.members[3].x -= 50;
			}
		}
		if (curSong.toLowerCase() == 'expurgation' && camZooming)
		{
			FlxG.camera.zoom += 0.010;
			camHUD.zoom += 0.020;
		}

		if (curSong.toLowerCase() == 'howl')
		{
			switch (curBeat)
			{
				case 320:
					FlxG.camera.flash(FlxColor.WHITE, 4, true);
					remove(cyanneh);
					remove(flashy);
			}
		}
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (SONG.song.toLowerCase() == 'wolf')
		{
			if (isBanger)
			{
				FlxG.camera.zoom += 0.020;
				camHUD.zoom += 0.030;
			}
			switch (curBeat)
			{
				case 1:
					add(coolOverlay);
				case 36:
					isBanger = true;
					FlxG.camera.flash();
				case 132:
					isBanger = false;
				case 148:
					isBanger = true;
				case 160:
					isBanger = false;
				case 164:
					isBanger = true;
				case 197:
					FlxG.camera.flash();
				case 420:
					isBanger = false;
				case 548:
					FlxG.camera.flash();
					camHUD.visible = false;
			}

			if (curBeat >= 197 && curBeat < 228)
				doDisco();
		}

		if (!byteHasFinishedHisSong)
		{
			if (SONG.song.toLowerCase() == 'byte')
			{
				if (curBeat % gfSpeed == 0)
				{
					if (!gf.animation.curAnim.name.startsWith("sing"))
						gf.dance();
				}

				if (boyfriend.curCharacter.toLowerCase() != "gf")
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						if (notPlayingCsAnim)
							boyfriend.playAnim('idle');
					}
				}
				else
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.dance();
					}
				}

				if (!dad.animation.curAnim.name.startsWith("sing"))
				{
					dad.playAnim('idle');
				}
			}
			else
			{
				if (SONG.song.toLowerCase() == 'run')
				{
					gf.playAnim('scared', true);
				}
				else
				{
					if (curBeat % gfSpeed == 0)
					{
						if (!gf.animation.curAnim.name.startsWith("sing"))
							gf.dance();
					}
				}

				if (boyfriend.curCharacter.toLowerCase() != "gf")
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.playAnim('idle');
					}
				}
				else
				{
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.dance();
					}
				}

				if (!dad.animation.curAnim.name.startsWith("sing"))
				{
					dad.playAnim('idle');
				}
			}
		}
		else
		{
			if (bfanimdone)
			{
				boyfriend.playAnim('ksLoop');
			}
			else
			{
				boyfriend.playAnim('firstKs');
				bfanimdone = !bfanimdone;
			}
			dad.playAnim('idle');
			dad.animation.pause();
			gf.playAnim('gfShy');
		}

		if (SONG.song.toLowerCase() == 'milf' && curBeat % 2 == 0)
		{
			bgMom.animation.play('momDance');
			bgDad.animation.play('dadDance');
		}

		if (SONG.song.toLowerCase() == 'milf')
		{
			switch (curBeat)
			{
				case 1:
					add(coolOverlay);
					coolOverlay.alpha = 0;
				case 200:
					remove(coolOverlay);
			}
		}

		if (SONG.song.toLowerCase() == "byte")
		{
			if (curBeat > 56 && curBeat <= 88)
				{
					FlxG.camera.zoom += 0.02;
					camHUD.zoom += 0.04;
					camNOTES.zoom += 0.04;
				}
			switch (curBeat)
			{
				case 8:
					defaultCamZoom = 0.9;
				case 16:
					defaultCamZoom = 0.8;
				case 40:
					defaultCamZoom = 0.9;
				case 48:
					defaultCamZoom = 0.8;
				case 120, 126:
					defaultCamZoom = 0.9;
				case 122, 127:
					defaultCamZoom = 1;
				case 124:
					defaultCamZoom = 1.1;
				case 128:
					defaultCamZoom = 0.8;
				case 152:
					FlxG.camera.zoom += 0.050;
					camHUD.zoom += 0.050;
					FlxG.camera.flash();
			}
		}

		if (SONG.song.toLowerCase() == "heartbass")
		{
			if (camZooming)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.04;
				camNOTES.zoom += 0.04;
			}

			switch (curBeat)
			{
				case 72:
					gf.isHappy = true;
					coolHeartShit();
				case 136:
					gf.isHappy = false;
				case 197:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});

				case 198:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set'));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});

				case 199:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
				case 200:
					FlxG.camera.flash(FlxColor.WHITE, 2, true);
					coolHeartShit();
					gf.isHappy = true;
				case 328:
					blackShiet = new FlxSprite(-1000, -1000).makeGraphic(3000, 3000, FlxColor.BLACK);
					add(blackShiet);
					blackShiet.alpha = 0;
					//FlxTween.tween(blackShiet, {alpha: 1}, 1, {ease: FlxEase.circOut});
				case 360:
					FlxG.camera.flash();
					remove(blackShiet);
				case 391:
					blackShiet = new FlxSprite(-1000, -1000).makeGraphic(3000, 3000, FlxColor.BLACK);
					add(blackShiet);
					blackShiet.alpha = 0;
					//FlxTween.tween(blackShiet, {alpha: 1}, 1, {ease: FlxEase.circOut});

					var ttx:Alphabet = new Alphabet(0, 0, "heartbass by bbpanzu", true, false);
					//add(ttx);

					ttx.alpha = 0;
					ttx.scrollFactor.set(0, 0);
					// ttx.setGraphicSize(Std.int(ttx.width * 0.7));

					//FlxTween.tween(ttx, {alpha: 1}, 1, {ease: FlxEase.circOut});

					// ttx.cameras = [camHUD];
					ttx.screenCenter();

				case 356:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});

				case 357:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set'));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});

				case 358:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
			}
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		if (curBeat % 41 == 40 && curSong == 'Byte')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
			dad.playAnim('byteHey', true);
		}

		if (SONG.song.toLowerCase() == 'howl')
		{
			switch (curBeat)
			{
				case 28:
					camHUDZOOM = 0.8;
					defNOTESZOOM = 0.8;
					defaultCamZoom -= 0.05;
				case 29:
					camHUDZOOM = 0.6;
					defNOTESZOOM = 0.6;
					defaultCamZoom -= 0.05;
				case 30:
					camHUDZOOM = 0.4;
					defNOTESZOOM = 0.4;
					defaultCamZoom -= 0.05;
				case 31:
					camHUDZOOM = 0.8;
					defNOTESZOOM = 0.8;
					defaultCamZoom += 0.15;
				case 32:
					doGlitch = true;
				case 255:
					tweenCamIn();
				case 256:
					inDropSong = true;
					tweenCamOut();
			}
		}

		if (curBeat % 89 == 88 && curSong == 'Byte')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
			dad.playAnim('byteHey', true);
		}

		if (!inCutscene)
		{
			if (curBeat % 16 == 15 && curSong == 'Woof')
			{
				boyfriend.playAnim('hey', true);
				gf.playAnim('cheer', true);
				dad.playAnim('byteHey', true);
			}

			if (curBeat % 47 == 46 && curSong == 'Woof')
			{
				boyfriend.playAnim('hey', true);
				gf.playAnim('cheer', true);
				dad.playAnim('byteHey', true);
			}
		}

		if (curSong == 'Howl' && curBeat >= 96 && curBeat < 128)
		{
			boyfriend.playAnim('scared', true);
			gf.playAnim('scared', true);
		}

		if (curSong == 'Hello UwU' && curBeat % 16 == 15)
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
			dad.playAnim('byteHey', true);
		}

		switch (curStage)
		{
			case 'outside':
				if (curSong.toLowerCase() == 'howl')
				{
					if (curBeat % 2 == 0)
					{
						cloudBop.animation.play('bopbop', true);
					}
					if (curBeat % gfSpeed == 0)
						{
							bopshit.animation.play('bopbop', true);
							devBops.animation.play('meow', true);
						}
						
				}
				else
				{
					cloudBop.animation.play('bopbop', true);
				}
				if (SONG.song.toLowerCase() == 'split ex')
					bge.animation.play('anm', true);
			case 'school':
				if (FlxG.save.data.distractions)
				{
					bgGirls.dance();
				}

			case 'mall':
				if (FlxG.save.data.distractions)
				{
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if (FlxG.save.data.distractions)
				{
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});

					if (FlxG.random.bool(10) && fastCarCanDrive)
						fastCarDrive();
				}
			case "philly":
				if (FlxG.save.data.distractions)
				{
					if (!trainMoving)
						trainCooldown += 1;

					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});

						curLight = FlxG.random.int(0, phillyCityLights.length - 1);

						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
					}
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if (FlxG.save.data.distractions)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if (FlxG.save.data.distractions)
			{
				lightningStrikeShit();
			}
		}
	}

	function coolHeartShit()
	{
		heartsThings.add(new HeartThingy(FlxG.random.int(Std.int(gf.x), Std.int(gf.width)), gf.getMidpoint().y, FlxG.random.float(1.8, 2.4)));
	}

	var curLight:Int = 0;

	function healthBarMove()
	{
		iconP1.visible = false;
		iconP2.visible = false;
		healthBar.visible = false;
		healthBarBG.visible = false;
		scoreTxt.visible = false;
	}

	function healthBarBack()
	{
		iconP1.visible = true;
		iconP2.visible = true;
		healthBar.visible = true;
		healthBarBG.visible = true;
		scoreTxt.visible = true;
	}

	function doDisco()
	{
		coolOverlay.alpha = 0.4;

		coolOverlay.color = FlxColor.fromRGB(FlxG.random.int(100,255), FlxG.random.int(100,255), FlxG.random.int(100,255));
	}

	function mashedKeys()
	{
		var redOverlay:FlxSprite = new FlxSprite(-700, -700).makeGraphic(3200, 3200, FlxColor.RED);
		add(redOverlay);
		redOverlay.alpha = 0.4;
		FlxTween.tween(redOverlay, {alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.linear,
			onComplete: function(aw:FlxTween)
			{
				remove(redOverlay);
			}
		});
	}
}
