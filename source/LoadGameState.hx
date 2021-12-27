package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class LoadGameState extends MusicBeatState
{
    //idk man, just dunno
    var wait:FlxText;
    override public function create()
        {
            super.create();
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    loadGame();
                });
        }
    
    function loadGame()
        {
            persistentUpdate = true;
    
            wait = new FlxText(0,0, 0, 'Loading Game...', 24);
            wait.scrollFactor.set();
            wait.setFormat("Pixel Arial 11 Bold", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            wait.screenCenter();
            wait.alpha = 1;
            add(wait);

            new FlxTimer().start(3, function(tmr:FlxTimer)
                {
                    gameloaded();
                });
        }

    function gameloaded() 
        {
            wait.text = 'Done! Starting game...';
            FlxG.sound.play(Paths.sound('gameLoaded'), 0.7);
            new FlxTimer().start(2, function(funi:FlxTimer)
                {
                    FlxG.switchState(new TitleState());
                });   
        }    
    
}