package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;

using StringTools;

class AboutStateMod extends MusicBeatState
{
    var logo:FlxSprite;
    var bg:FlxSprite = new FlxSprite(-80, 0).loadGraphic(Paths.image('bytestagesky'));
    var bg2:FlxSprite = new FlxSprite(0,600).loadGraphic(Paths.image('aboutmodlol'));
    private var grpmods:FlxTypedGroup<Alphabet>;
    private var camHUD:FlxCamera;

    override function create() 
        {
            Conductor.changeBPM(100);
            persistentUpdate = true;

            super.create();

		    camHUD = new FlxCamera();
		    camHUD.bgColor.alpha = 0;
            FlxG.cameras.add(camHUD);

            bg.scrollFactor.set(0.9,0.9);
            bg.antialiasing = true;
            bg.screenCenter();
            bg2.scrollFactor.set(0.9,0.9);
            bg2.antialiasing = true;

            add(bg);
            add(bg2);

            var camPos:FlxPoint = new FlxPoint(bg.getGraphicMidpoint().x + 400, bg.getGraphicMidpoint().y);

            var camFollow = new FlxObject(0, 0, 1, 1);
            camFollow.setPosition(camPos.x, camPos.y);
            add(camFollow);

            bg2.cameras = [camHUD];

            FlxG.camera.follow(camFollow, LOCKON, 0.01);
            // FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
            FlxG.camera.zoom = 0.9;
            FlxG.camera.focusOn(camFollow.getPosition());
            bg2.alpha = 0;
            FlxTween.tween(bg2, {y: 0, alpha: 1}, 1.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
        }
    var isCat:Bool = false;

    override function update(elapsed:Float)
        {
            if (FlxG.sound.music != null)
                Conductor.songPosition = FlxG.sound.music.time;

            super.update(elapsed);
    
                if (controls.BACK && !isCat)
                    FlxG.switchState(new OptionsMenu());

            FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.95);
            camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
        }

    override function beatHit()
        {
            super.beatHit();
            if (curBeat % 2 == 0)
                {
                    FlxG.camera.zoom += 0.025;
                    camHUD.zoom += 0.035;
                }
            //var randomBoolean:Int = FlxG.random.int(1,4);

            /*if (randomBoolean == 1)
                {
                    bg.loadGraphic(Paths.image('menuBG'));
                } else if (randomBoolean == 2)
                    {
                        bg.loadGraphic(Paths.image('freeplayBlur'));
                    } else if (randomBoolean == 3)
                        {
                            bg.loadGraphic(Paths.image('menuDesat'));
                        }   else if (randomBoolean == 4)
                            {
                                bg.loadGraphic(Paths.image('menuBGMagenta'));
                            }
            
            trace('currentRandomBoolean: ' + randomBoolean);
            trace('beat');*/
        }
}

