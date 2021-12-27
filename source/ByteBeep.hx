package;

import flixel.ui.FlxBar;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import openfl.Lib;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
#if windows
import Discord.DiscordClient;
#end
using StringTools;

class ByteBeep extends MusicBeatState
{
    var char:Character;
    var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('menuDesat'));
    var defCurZoom:Float = 0.9;
    var curZoom:Float = 0.8;
    var camArrow:FlxCamera;
    var strumLineYPos:Int = 50;
    var strumLineNotes:FlxTypedGroup<FlxSprite>;
    var charNum:Int = 0;
    var charName:String = "byte";
    var isBF:Bool = false;
    var camFollow:FlxObject;

    var songLength:Float = 0;
    var songBG:FlxSprite;
    var songBar:FlxBar;

    var songIcon:HealthIcon;
    var songLengthMax:Float;

    var sustainOnHoldLength:Float = 2;

    var curStage:String = 'urmom';

    override function create()
    {
        //Conductor.changeBPM(100);
		persistentUpdate = true;

        #if windows
        DiscordClient.changePresence("ByteWolf - Beep Mode", null,null,true);
        #end

        strumLineNotes = new FlxTypedGroup<FlxSprite>();

        camArrow = new FlxCamera();
        camArrow.bgColor.alpha = 0;

        char = new Character(0,0, 'byte');
        char.setGraphicSize(Std.int(char.width * 0.7));
        char.screenCenter();
        char.scrollFactor.set(0.95, 0.95);

        bg.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
        bg.screenCenter();
        bg.setGraphicSize(Std.int(bg.width * 1.2));
        bg.antialiasing = true;
        generateStaticArrows();

        var camPos:FlxPoint = new FlxPoint(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);

        camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		add(camFollow);
        
        var controlsLmao:FlxText;
        controlsLmao = new FlxText(-10, (FlxG.height / 2), 2000, "", 20);
        controlsLmao.scrollFactor.set();
        controlsLmao.setFormat("VCR OSD Mono",24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        if (FlxG.save.data.dfjk)
            controlsLmao.text = "Controls: \n[DFJK] / [Arrow keys].\n[SPACE] - Playing their Hey Anims\n[Q] / [E] - Changing the Characters";
            else
            controlsLmao.text = "Controls: \n[WASD] / [Arrow keys].\n[SPACE] - Playing their Hey Anims\n[Q] / [E] - Changing the Characters";

        controlsLmao.antialiasing = false;
        controlsLmao.borderSize = 2;

        songLengthMax = FlxG.sound.music.length;

        //layershit
        add(bg);  
        add(char);
        add(strumLineNotes);
        add(controlsLmao);

        generateSongPositionBar();

        FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
        super.create();
    }

    override function update(elapsed:Float) {

        var curTime:Float = FlxG.sound.music.time;
        if (curTime < 0)
            curTime = 0;
        songLength = (curTime / songLengthMax);

        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);
                
        FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.94);

        keyShit();

        songIcon.setGraphicSize(Std.int(FlxMath.lerp(150, songIcon.width, 0.89)));
		songIcon.updateHitbox();

		var iconOffset:Int = 26;

		songIcon.x = songBar.x + (songBar.width * (FlxMath.remapToRange(songBar.percent, 0, 100, 0, 100) * 0.01) - (songIcon.width - iconOffset));

        for (i in 0...strumLineNotes.length)
            {
                strumLineNotes.members[i].x = (FlxMath.lerp(410 + (i * strumLineNotes.members[i].width), strumLineNotes.members[i].x, 0.95));
            }

        if (FlxG.keys.justPressed.E)
            changeCharacter(1);
        if (FlxG.keys.justPressed.Q)
            changeCharacter(-1);

        if (songBar.percent < 20)
			{
				songIcon.animation.curAnim.curFrame = 1;		
			}else {
				songIcon.animation.curAnim.curFrame = 0;
			}

		if (songBar.percent > 80)
			{
                if (char.curCharacter == 'gf')
					songIcon.animation.curAnim.curFrame = 1;
                    else
                    songIcon.animation.curAnim.curFrame = 2;
			}

        if (FlxG.keys.justPressed.SPACE)
            {
                heyAnims();
            }
        if (FlxG.keys.pressed.SPACE && char.animation.curAnim.name.toLowerCase() == heyNames())
            {
                char.holdTimer = 0;
            }

        if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.switchState(new MainMenuState());
            }
    }

    function generateSongPositionBar()
    {
        var colorp1:FlxColor = 0xFF66FF33;

		switch (char.curCharacter)
			{
				case 'bf':
					colorp1 = FlxColor.fromRGB(81, 166, 235);
				case 'gf':
					colorp1 = FlxColor.fromRGB(108, 14, 10);
				case 'byte':
					colorp1 = FlxColor.fromRGB(0, 85, 255);
			}

        if (songBG != null && songBar != null && songIcon != null)
            {
                remove(songBG);
                remove(songBar);
                remove(songIcon);
                songBG = new FlxSprite(0, FlxG.height * 0.85 + 45).loadGraphic(Paths.image('healthBar','shared'));
                songBG.screenCenter(X);
                songBG.antialiasing = true;
                songBG.scrollFactor.set();
                add(songBG);
        
                songBar = new FlxBar(songBG.x + 4, songBG.y + 4, LEFT_TO_RIGHT, Std.int(songBG.width - 8), Std.int(songBG.height - 8), this,'songLength', 0, 1);
                songBar.numDivisions = 1000;
                songBar.scrollFactor.set();
                songBar.screenCenter(X);
                songBar.antialiasing = true;
                songBar.createFilledBar(FlxColor.BLACK, colorp1);
                add(songBar);

                songIcon = new HealthIcon(char.curCharacter, false);
                songIcon.y = songBar.y - (songIcon.height / 2);
                songIcon.setGraphicSize(Std.int(songIcon.width * 1.3));
                add(songIcon);
            } else{
                songBG = new FlxSprite(0, FlxG.height * 0.85 + 45).loadGraphic(Paths.image('healthBar', 'shared'));
                songBG.screenCenter(X);
                songBG.antialiasing = true;
                songBG.scrollFactor.set();
                add(songBG);
        
                songBar = new FlxBar(songBG.x + 4, songBG.y + 4, LEFT_TO_RIGHT, Std.int(songBG.width - 8), Std.int(songBG.height - 8), this,'songLength', 0, 1);
                songBar.numDivisions = 1000;
                songBar.scrollFactor.set();
                songBar.screenCenter(X);
                songBar.antialiasing = true;
                songBar.createFilledBar(FlxColor.BLACK, colorp1);
                add(songBar);

                songIcon = new HealthIcon(char.curCharacter, false);
                songIcon.y = songBar.y - (songIcon.height / 2);
                songIcon.setGraphicSize(Std.int(songIcon.width * 1.3));
                add(songIcon);
            }

    }

    function changeCharacter(addNu:Int = 0)
        {
            charNum += addNu;

            var charshit:String = "";

            if (charNum < 0)
                charNum = 2;
            if (charNum > 2)
                charNum = 0;

            switch (charNum)
                {
                    case 0:
                        remove(char);
                        char = new Character(0,0, 'byte');
                        char.setGraphicSize(Std.int(char.width * 0.7));
                        char.screenCenter();
                        char.scrollFactor.set(0.95, 0.95);
                        add(char);
                        charName = "byte";
                        charshit = "ByteWolf";
                        isBF = false;
                    case 1:
                        remove(char);
                        char = new Character(420,220, 'bf', true);
                        char.setGraphicSize(Std.int(char.width * 0.4));
                        char.scrollFactor.set(0.95, 0.95);
                        add(char);
                        charName = "bf";
                        charshit = "Boyfriend";
                        isBF = true;
                    case 2:
                        remove(char);
                        char = new Character(0,0, 'gf');
                        char.setGraphicSize(Std.int(char.width * 0.7));
                        char.screenCenter();
                        char.scrollFactor.set(0.95, 0.95);
                        charName = "gf";
                        charshit = "Girlfriend";
                        add(char);
                        isBF = false;
                }
            generateSongPositionBar();
        }

    private function keyShit() {
        var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
        var pressArray:Array<Bool> = [
            controls.LEFT_P,
            controls.DOWN_P,
            controls.UP_P,
            controls.RIGHT_P
        ];
        var releaseArray:Array<Bool> = [
            controls.LEFT_R,
            controls.DOWN_R,
            controls.UP_R,
            controls.RIGHT_R
        ];

        strumLineNotes.forEach(function(spr:FlxSprite)
            {

                if (pressArray[spr.ID] && spr.animation.curAnim.name != 'pressed')
                    spr.animation.play('confirm');
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

        if (holdArray.contains(true))
            char.holdTimer = 0;

        if (pressArray[0])
            {
                char.playAnim('singLEFT', true);
            }

        if (pressArray[1])
            {
                char.playAnim('singDOWN', true);
            }

        if (pressArray[2])
            {
                char.playAnim('singUP', true);
            }
        
        if (pressArray[3])
            {
                char.playAnim('singRIGHT', true);
            }
        }

    function heyAnims() {
        switch (char.curCharacter.toLowerCase())
            {
                case 'byte':
                    char.playAnim('byteHey', true);
                case 'bf':
                    char.playAnim('hey', true);
                case 'gf':
                    char.playAnim('cheer', true);
            }

        FlxG.sound.play(Paths.sound('fnf_bf_hey', "shared"));
    }

    function heyNames():String {
        var returnThing:String = '';
        switch (char.curCharacter.toLowerCase())
        {
            case 'byte':
                returnThing = 'byteHey';
            case 'bf':
                returnThing = 'hey';
            case 'gf':
                returnThing = 'cheer';
        }

        return returnThing;
    }

    private function generateStaticArrows():Void
        {
            for (i in 0...4)
            {
                // FlxG.log.add(i);
                var babyArrow:FlxSprite = new FlxSprite(0, strumLineYPos);
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
    
                babyArrow.animation.play('static');
                babyArrow.x = 50;   
    
                strumLineNotes.add(babyArrow);
            }
        }
    override function beatHit()
        {
            super.beatHit();
            if (curBeat % 4 == 0)
                {
                    FlxG.camera.zoom += 0.050;  
                    bg.color = FlxColor.fromRGB(FlxG.random.int(50, 255), FlxG.random.int(50, 255), FlxG.random.int(50, 255));                 
                }

            //camArrow.zoom += 0.4;

            songIcon.setGraphicSize(Std.int(songIcon.width + 30));
            songIcon.updateHitbox();

            if (!char.animation.curAnim.name.startsWith('sing'))
                {
                    char.playAnim('idle');
                    char.dance();
                }    
        }
}

