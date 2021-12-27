import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxObject;
#if windows
import Discord.DiscordClient;
import sys.thread.Thread;
#end

import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.ui.Keyboard;
import flixel.FlxSprite;
import flixel.FlxG;

class ResizeState extends MusicBeatState
{
    var defaultX:Float = FlxG.width * 0.55 - 135;
    var defaultY:Float = FlxG.height / 2 - 50;

    var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backSky', 'shared'));

    var sick:FlxSprite = new FlxSprite().loadGraphic(Paths.image('sick','shared'));

    var sickWidth:Float = 0;

    var charInfo:FlxText;

    private var camHUD:FlxCamera;
    
    public override function create() {
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Customizing Gameplay", null);
		#end

		Conductor.changeBPM(102);
		persistentUpdate = true;

        super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);

        bg.scrollFactor.set(0.9,0.9);

        add(bg);

		var camFollow = new FlxObject(0, 0, 1, 1);

		var camPos:FlxPoint = new FlxPoint(sick.getGraphicMidpoint().x + 400, sick.getGraphicMidpoint().y);

		camFollow.setPosition(camPos.x, camPos.y);

        bg.antialiasing = true;
        sickWidth = sick.width;
        sick.antialiasing = true;
        sick.screenCenter();
        sick.setGraphicSize(Std.int(sick.width * FlxG.save.data.ratingsize));

        charInfo = new FlxText(20, 30, 0, "Rating Text Size : " + FlxG.save.data.ratingsize, 24);
        charInfo.scrollFactor.set();
        charInfo.screenCenter(Y);
		charInfo.setFormat("VCR OSD Mono",24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(charInfo);
        add(sick);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);

		FlxG.camera.zoom = 1;
		FlxG.camera.focusOn(camFollow.getPosition());

        sick.cameras = [camHUD];
        charInfo.cameras = [camHUD];

        sick.updateHitbox();

        FlxG.mouse.visible = true;

    }

    override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        charInfo.text = "Rating Text Size : " + FlxG.save.data.ratingsize;

        FlxG.camera.zoom = FlxMath.lerp(0.8, FlxG.camera.zoom, 0.95);
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);


        if (controls.LEFT_P)
            {
                if (FlxG.save.data.ratingsize <= 0.5)
                    {

                    } else {
                        FlxG.save.data.ratingsize -= 0.1;
                        sick.setGraphicSize(Std.int(sickWidth * FlxG.save.data.ratingsize));
                    }
            }

        if (controls.RIGHT_P)
            {
                if (FlxG.save.data.ratingsize >= 0.7)
                    {
                     
                    } else {
                        FlxG.save.data.ratingsize += 0.1;
                        sick.setGraphicSize(Std.int(sickWidth * FlxG.save.data.ratingsize));                          
                    }
            }
        
        if (FlxG.save.data.ratingsize > 1)
            FlxG.save.data.ratingsize = 1;

        sick.updateHitbox();

        if (controls.BACK)
        {
            FlxG.mouse.visible = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new OptionsMenu());
        }

    }

    override function beatHit() 
    {
        super.beatHit();

        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.010;

    }
}