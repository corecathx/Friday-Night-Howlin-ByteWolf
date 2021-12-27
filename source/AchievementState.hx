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

class AchievementState extends MusicBeatState
{
    var curSelected:Int = 1;

    var bg:FlxSprite = new FlxSprite(-80, 0).loadGraphic(Paths.image('backSky'));
    
    var achievements:FlxTypedGroup<FlxSprite>;
    var acItems:Array<String> = ['0', '1', '2']; //lol don't ask me about this line
    var acItem:FlxSprite;
    var camFollow:FlxObject;

    var acInfo:FlxText;
    var acDesc:FlxText;

    var targetY:Int = 0;

    override function create() 
        {
            if (!FlxG.sound.music.playing)
				{
					FlxG.sound.playMusic(Paths.music('breakfast'));
				}
            
            bg.scrollFactor.set(0.3,0.3);
            bg.setGraphicSize(Std.int(bg.width * 0.8));
            bg.antialiasing = true;
            bg.screenCenter();
            add(bg);

            achievements = new FlxTypedGroup<FlxSprite>();
            add(achievements);

            for (i in 0...acItems.length)
                {
                    acItem = new FlxSprite(350 + (i * 200), 250).loadGraphic(Paths.image('achievementOverlays/ac-icon' + i, 'shared'));
                    acItem.updateHitbox();
                    //acItem.setGraphicSize(Std.int(acItem.width * 0.2));
                    acItem.ID = i;
                    acItem.scrollFactor.set(1,1);
                    acItem.antialiasing = true;
					achievements.add(acItem);
                }

            camFollow = new FlxObject(0, 0, 1, 1);
            camFollow.screenCenter();
            add(camFollow);
    
            FlxG.camera.follow(camFollow, null, 0.20 * (60 / FlxG.save.data.fpsCap));
            // FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
            FlxG.camera.zoom = 1;
            FlxG.camera.focusOn(camFollow.getPosition());

            var acBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.8).makeGraphic(FlxG.width, 200, FlxColor.BLACK);
            acBG.scrollFactor.set(0,0);
            acBG.alpha = 0.7;
            add(acBG);

            acInfo = new FlxText(400, FlxG.height * 0.85, 0, "", 24);
            acInfo.setFormat('VCR OSD Mono', 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            acInfo.screenCenter(X);
            acInfo.scrollFactor.set(0,0);
            acInfo.updateHitbox();
            add(acInfo);

            acDesc = new FlxText(360, FlxG.height * 0.9, 0, "", 20);
            acDesc.setFormat('VCR OSD Mono', 20, FlxColor.GRAY, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            acDesc.screenCenter(X);
            acDesc.scrollFactor.set(0,0);
            acDesc.updateHitbox();
            add(acDesc);

            var shit:FlxText = new FlxText(5, FlxG.height - 18, 0, "V.S ByteWolf V.1.3.0 (Kade Engine) - AchievementState", 12);
            shit.scrollFactor.set();
            shit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            add(shit);

            super.create();
        }

    override function update(elapsed:Float)
        {
            super.update(elapsed);
            if (controls.RIGHT_P)
                changeSelection(1);

            if (controls.LEFT_P)
                changeSelection(-1);

            if (controls.BACK)
                FlxG.switchState(new OptionsMenu());

            if (!FlxG.save.data.gamedone)
                {
                    achievements.members[0].color = FlxColor.BLACK;
                }
            
            if (!FlxG.save.data.dpn)
                {
                    achievements.members[1].color = FlxColor.BLACK;
                }

            if (!FlxG.save.data.howlfull)
                {
                    achievements.members[2].color = FlxColor.BLACK;
                }

            switch (curSelected)
                {
                    case 0:
                        if (FlxG.save.data.gamedone)
                            {
                                acInfo.text = "Completed the Byte Week";
                                acInfo.color = FlxColor.YELLOW;
                                acDesc.text = "(You finished this mod's week)"; 
                            } else{
                                acInfo.text = "Locked";
                                acInfo.color = FlxColor.RED;
                                acDesc.text = "This achievement are still locked.";
                            }

                    case 1:
                        if (FlxG.save.data.dpn)
                            {
                                acInfo.text = "Your first game over caused by the PawNote";
                                acInfo.color = FlxColor.YELLOW;
                                acDesc.text = "(lol u died cuz the pawnotes)";
                            } else{
                                acInfo.text = "Locked";
                                acInfo.color = FlxColor.RED;
                                acDesc.text = "This achievement are still locked.";
                            }

                    case 2:
                        if (FlxG.save.data.howlfull)
                            {
                                acInfo.text = "100% Accuracy on Howl?!";
                                acInfo.color = FlxColor.YELLOW;
                                acDesc.text = "(Wait, how did you do that?)";
                            } else{
                                acInfo.text = "Locked";
                                acInfo.color = FlxColor.RED;
                                acDesc.text = "This achievement are still locked.";
                            }
                }
        }

    function changeSelection(change:Int = 0)
        {     
            curSelected += change;
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

            if (curSelected >= acItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = acItems.length - 1;

            achievements.forEach(function(spr:FlxSprite)
                {
                    spr.alpha = 0.6;
                            
                    if (spr.ID == curSelected)
                        {
                            spr.alpha = 1;
                            camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
                        }
                    spr.updateHitbox();
                });
        }

    function createPopUp(popNum:Int)
    {
        var popUpSprite:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('achievementOverlays/achievement' + popNum, 'shared'));
        add(popUpSprite);
        
        popUpSprite.x = popUpSprite.x + 500;
        FlxTween.tween(popUpSprite, { x: popUpSprite.x - 500 }, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
        new FlxTimer().start(4, function(tmr:FlxTimer){
            FlxTween.tween(popUpSprite, { x: popUpSprite.x + 500, alpha: 0 }, 1, {ease: FlxEase.circIn, onComplete: function(twn:FlxTween){}});
        });
    }
}



