package;

import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;
#if windows
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.ui.Keyboard;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class ChangeUIScore extends MusicBeatState
{
    var isByteWolf:Bool = false;
    var bf:Boyfriend = new Boyfriend(770, 450, 'bf');
    var dad:Character;
    var gf:Character;

    var strumLine:FlxSprite;
    var strumLineNotes:FlxTypedGroup<FlxSprite>;
    var playerStrums:FlxTypedGroup<FlxSprite>;

    private var camHUD:FlxCamera;
    private var camGame:FlxCamera;

    var camFollow:FlxObject;
    var scoreTxt:FlxText;

    var songScore:Int = 0;
	var songScoreDef:Int = 0;
    var nps:Int = 0;
	var maxNPS:Int = 0;
    var healthBarBG:FlxSprite;

    var versionShit:FlxText;
    
    public override function create() {
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Customizing Scoring", null);
		#end

        FlxG.sound.music.stop();
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

		persistentUpdate = true;

        super.create();

        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backSky'));
        bg.antialiasing = true;
        bg.scrollFactor.set(0.9, 0.9);
        bg.active = false;
        add(bg);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		var camFollow = new FlxObject(0, 0, 1, 1);

		dad = new Character(100, 100, 'byte');
        gf = new Character(400, 130, 'gf');
        add(gf);

		camFollow.setPosition(gf.getMidpoint().x - 100, gf.getMidpoint().y);

        add(bf);
        add(dad);
		add(camFollow);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);

		FlxG.camera.focusOn(camFollow.getPosition());

		FlxCamera.defaultCameras = [camGame];

		strumLine = new FlxSprite(0, 35).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

        FlxG.camera.zoom = 0.5;

		playerStrums = new FlxTypedGroup<FlxSprite>();

        dad.x -= 150;
        bf.x += 100;
        
        strumLine.cameras = [camHUD];
        playerStrums.cameras = [camHUD];

        if (FlxG.save.data.scoreStyle = "ByteWolf")
            isByteWolf = true;
            else
            isByteWolf = false;
        
		generateStaticArrows(0);
		generateStaticArrows(1);

        healthBarBG = new FlxSprite(0, FlxG.height * 0.88).loadGraphic(Paths.image('healthBar', 'shared'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 80;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

        healthBarBG.cameras = [camHUD];

        changeSelection();

        versionShit = new FlxText(5, FlxG.height - 18, 0, 'Press LEFT / RIGHT to change the style || Current Style: ' + FlxG.save.data.scoreStyle, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
        versionShit.cameras = [camHUD];



        FlxG.mouse.visible = true;

    }

    override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        versionShit.text = 'Press LEFT / RIGHT to change the style || Current Style: ' + FlxG.save.data.scoreStyle;

        super.update(elapsed);

        FlxG.camera.zoom = FlxMath.lerp(0.7, FlxG.camera.zoom, 0.95);
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);

        if (controls.LEFT_P)
            changeSelection();
        if (controls.RIGHT_P)
            changeSelection();
        if (controls.BACK)
        {
            FlxG.save.flush();
            FlxG.sound.music.stop();
            FlxG.mouse.visible = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new OptionsMenu());
        }

    }

    override function beatHit() 
    {
        super.beatHit();

        bf.playAnim('idle');
        dad.dance();

        gf.dance();


        if (curBeat % 4 == 0)
            {
                FlxG.camera.zoom += 0.025;
                camHUD.zoom += 0.03;                
            }

        trace('beat');

    }

    private function createDaTexts(type:String)
        {
            switch (type)
                {
                    case 'ByteWolf':
                        scoreTxt = new FlxText(20, 300, 999, "", 24);
                        scoreTxt.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                        scoreTxt.scrollFactor.set();
                        scoreTxt.antialiasing = true;
                        add(scoreTxt);

                        scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, 69)
                        + "\nHealth: 0%"
                        + "\nCombo: 0"
                        + "\n"
                        + "Song: Main Menu - NO-DIFFICULTY";

                        scoreTxt.cameras = [camHUD];
                    case 'Kade Engine':
                        scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 999, "", 20);
                        if (!FlxG.save.data.accuracyDisplay)
                            scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
                        scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
                        scoreTxt.scrollFactor.set();												  
                        add(scoreTxt);
                
                        scoreTxt.text = Ratings.CalculateRankingE(songScore, songScoreDef, nps, maxNPS, 69);
                        scoreTxt.cameras = [camHUD];
                }
        }

    function changeSelection()
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

            isByteWolf = !isByteWolf;
            if (isByteWolf)
                FlxG.save.data.scoreStyle = "ByteWolf";
            else
                FlxG.save.data.scoreStyle = "Kade Engine";

            remove(scoreTxt);
            createDaTexts(FlxG.save.data.scoreStyle);
        }
    // ripped from play state cuz im lazy
    
	private function generateStaticArrows(player:Int):Void
        {
            for (i in 0...4)
            {
                // FlxG.log.add(i);
                var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
                babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
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
                babyArrow.updateHitbox();
                babyArrow.scrollFactor.set();
    
                babyArrow.ID = i;
    
                if (player == 1)
                {
                    playerStrums.add(babyArrow);
                }
    
                babyArrow.animation.play('static');
                babyArrow.x += 50;
                babyArrow.x += ((FlxG.width / 2) * player);
    
                strumLineNotes.add(babyArrow);

                strumLineNotes.cameras = [camHUD];
                playerStrums.cameras = [camHUD];
            }
        }
}