package;

//import flixel.addons.editors.spine.FlxSpine;
import openfl.Lib;
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
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ThankYouState extends MusicBeatState
{
    static var loadedup:Bool = false;
    var logoBl:FlxSprite;
    var bgGF:Character;
    var bgBYTE:Character;
    var bgBF:Boyfriend;
    var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backSky'));
    var credGroup:FlxGroup;
    //private var camHUD:FlxCamera;
    var credTextShit:Alphabet;
	var textGroup:FlxGroup;
    var danceLeft:Bool = true;
    var black:FlxSprite;
    var startSongdone:Bool = false;
    var hasCleaned:Bool = false;
    var camPos:FlxPoint;
    var camFollow:FlxObject;

    override function create() 
        {
            Conductor.changeBPM(120);
            persistentUpdate = true;

            #if windows
            DiscordClient.changePresence("At Thank You screen :3", null, null);
            #end

            super.create();
            FlxG.sound.music.stop();
            new FlxTimer().start(0.5, function (wee:FlxTimer) {
                FlxG.sound.music.fadeIn(4, 0, 0.8);
                FlxG.sound.playMusic(Paths.music('howlChillStart'), 0);
            });
            

            logoBl = new FlxSprite(160, 90); //-150, 100
            logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
            logoBl.antialiasing = true;
            logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
            logoBl.updateHitbox();
            logoBl.setGraphicSize(Std.int(logoBl.width * 0.5));
            logoBl.animation.play('bump');
            logoBl.screenCenter();

		    //camHUD = new FlxCamera();
		    //camHUD.bgColor.alpha = 0;
            //FlxG.cameras.add(camHUD);

            bgGF = new Character(400,130,'gf');
            bgGF.scrollFactor.set(0.95, 0.95);

            bgBYTE = new Character(100,100,'byte');
            bgBYTE.scrollFactor.set(0.95, 0.95);

            bgBF = new Boyfriend(770,450,'bf');
            bgBF.scrollFactor.set(0.95, 0.95);

            bg.scrollFactor.set(0.9,0.9);
            bg.antialiasing = true;
            bg.screenCenter();

            black = new FlxSprite(-300, -300).makeGraphic(2000,2000,FlxColor.BLACK);

            add(bg);
            add(bgGF);
            add(bgBF);
            add(bgBYTE);
            add(black);
            add(logoBl);

            logoBl.visible = false;
            camPos = new FlxPoint(bg.getGraphicMidpoint().x, bg.getGraphicMidpoint().y);

            var camFollow = new FlxObject(0, 0, 1, 1);
            camFollow.setPosition(camPos.x, camPos.y);
            add(camFollow);

            FlxG.camera.zoom = 0.7;

            credGroup = new FlxGroup();
            add(credGroup);
            textGroup = new FlxGroup();

            

            FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
            //bg2.alpha = 0;
            //FlxTween.tween(bg2, {y: 0, alpha: 1}, 1.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween){}});
        }
    var isCat:Bool = false;


    function createCoolText(textArray:Array<String>)
        {
            for (i in 0...textArray.length)
            {
                var money:Alphabet = new Alphabet(0, 100, textArray[i], true, false);
                money.screenCenter(X);
                money.y += (i * 60) + 100;
                credGroup.add(money);
                textGroup.add(money);
            }
        }

    function addMoreText(text:String)
        {
            var coolText:Alphabet = new Alphabet(0, 100, text, true, false);
            coolText.screenCenter(X);
            coolText.y += (textGroup.length * 60) + 100;
            credGroup.add(coolText);
            textGroup.add(coolText);
        }

    function deleteCoolText()
        {
            while (textGroup.members.length > 0)
            {
                credGroup.remove(textGroup.members[0], true);
                textGroup.remove(textGroup.members[0], true);
            }
        }


    override function update(elapsed:Float)
        {
            
            if (FlxG.sound.music != null)
                Conductor.songPosition = FlxG.sound.music.time;

            super.update(elapsed);

            FlxG.camera.zoom = FlxMath.lerp(0.7, FlxG.camera.zoom, 0.95);
            //camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);      
            if (hasCleaned)
                {
                    if (FlxG.keys.justPressed.ENTER)
                        {
                            FlxG.save.data.gamedone = true;
                            FlxG.switchState(new MainMenuState());
                            FlxG.sound.play(Paths.sound('confirmMenu'));
                            FlxG.sound.play(Paths.sound('fnf_bf_hey'));
                            FlxG.camera.flash(FlxColor.WHITE, 1);
                        }

                }
        }

    function credDone()
        {
            if (!hasCleaned)
                {
                    hasCleaned = true;
                    remove(black);
                    remove(logoBl);
                    remove(credGroup);
                    FlxG.camera.flash(FlxColor.WHITE, 3);
                    FlxG.sound.music.stop();
                    FlxG.sound.playMusic(Paths.music('howlChillLoop'));
                    Conductor.changeBPM(120);

                    var thx:Alphabet = new Alphabet(0,0,"Thank you for Playing my mod", true,false);
                    thx.isMenuItem = true;
                    thx.screenCenter();
                    add(thx);

                    logoBl.visible = true;
                    logoBl.x = thx.getGraphicMidpoint().x;
                    logoBl.y = thx.getGraphicMidpoint().y + 100;

                    camPos = new FlxPoint(thx.getGraphicMidpoint().x - 800, thx.getGraphicMidpoint().y - 400);
                    FlxG.camera.focusOn(camPos);
                    
                    var press:FlxText = new FlxText(0, 700, 0, "-Press ENTER to exit-", 24);
                    press.scrollFactor.set();
                    press.screenCenter(X);
                    press.alpha = 0;
                    press.setFormat("Pixel Arial 11 Bold", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                    add(press);

                    persistentUpdate = true;
                }

        }

    override function beatHit()
        {
            super.beatHit();
            FlxG.camera.zoom += 0.020;

            bgGF.dance();

            if (curBeat % 8 == 7)
                {
                    bgGF.playAnim('cheer', true);
                    bgBF.playAnim('pawHit', true);
                    bgBYTE.playAnim('byteHey', true);
                }
            if (curBeat % 2 == 0)
                {
                    bgBF.playAnim('idle');
                    bgBYTE.playAnim('idle'); 
                }


            FlxG.log.add(curBeat);
            switch (curBeat)
            {
                case 1:
                    createCoolText(['Thank']);
                case 2:
                    addMoreText('You');
                case 3:
                    deleteCoolText();
                case 4:
                    createCoolText(['For', 'playing']);
                case 6:
                    addMoreText('My Mod');
                case 7:
                    deleteCoolText();
                case 8:
                    createCoolText(['Friday Night Howlin']);
                case 10:
                    addMoreText('vs ByteWolf');
                case 11:
                    deleteCoolText();
                case 12:
                    createCoolText(['ByteWolf', 'by']);
                case 14:
                    addMoreText('CoreDev');
                case 15:
                    deleteCoolText();
                case 16:
                    createCoolText(['KadeEngine', 'by']);
                case 18:
                    addMoreText('KadeDev');
                case 19:
                    deleteCoolText();
                case 20:
                    createCoolText(['Friday Night Funkin By']);
                case 21:
                    addMoreText('ninjamuffin');
                    addMoreText('phantomarcade');
                case 22:
                    addMoreText('kawaisprite');
                    addMoreText('and evilskr');
                case 23:
                    deleteCoolText();
                case 24:
                    createCoolText(['From CoreDev']);
                case 26:
                    addMoreText('To You');
                case 27:
                    deleteCoolText();
                case 28:
                    createCoolText(['Funkin']); 
                case 30:
                    addMoreText('Forever');
                case 31:
                    deleteCoolText();
                    credDone();
            }

        }
}

