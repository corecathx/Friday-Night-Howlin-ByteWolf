package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitgf:FlxSprite;

	var yes = true;
	var no = false;

	var portraitbf2:FlxSprite;
	var portraitbf1:FlxSprite;
	var portraitByte2:FlxSprite;
	var portraitByte1:FlxSprite;
	var portraitgf2:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'byte':
				//FlxG.sound.playMusic(Paths.music('WolfFurry'), 0);
				//FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-700, -700).makeGraphic(3200, 3200, 0xFF2196F3);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'byte':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal',24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.antialiasing = true;
			case 'woof':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal',24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.antialiasing = true;
			case 'howl':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal',24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.antialiasing = true;
			case 'hello uwu':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal',[4] ,"", 24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
				box.antialiasing = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
			{
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			} else if (PlayState.SONG.song.toLowerCase() == 'byte' || PlayState.SONG.song.toLowerCase() == 'woof' || PlayState.SONG.song.toLowerCase() == 'howl')
			{
				portraitLeft = new FlxSprite(120, 150);
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
				portraitLeft.animation.addByPrefix('enter', 'Byte talk normal', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.100));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				portraitLeft.antialiasing = true;
			}
	
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
			{
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			} else if (PlayState.SONG.song.toLowerCase() == 'byte' || PlayState.SONG.song.toLowerCase() == 'woof' || PlayState.SONG.song.toLowerCase() == 'howl')
			{
				portraitRight = new FlxSprite(720, 170);
				portraitRight.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
				portraitRight.animation.addByPrefix('enter', 'BF talk normal', 24, false);
				//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.100));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
				portraitRight.antialiasing = true;
			}
		//gf box sheee
		portraitgf = new FlxSprite(320, 170);
		portraitgf.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitgf.animation.addByPrefix('enter', 'GF talk normal', 24, false);
		//portraitgf.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.175));
		portraitgf.updateHitbox();
		portraitgf.scrollFactor.set();
		add(portraitgf);
		portraitgf.visible = false;
		portraitgf.antialiasing = true;

		portraitgf2 = new FlxSprite(320, 170);
		portraitgf2.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitgf2.animation.addByPrefix('enter', 'GF Talk Smile', 24, false);
		//portraitgf2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.175));
		portraitgf2.updateHitbox();
		portraitgf2.scrollFactor.set();
		add(portraitgf2);
		portraitgf2.visible = false;
		portraitgf2.antialiasing = true;

		portraitByte1 = new FlxSprite(120, 150);
		portraitByte1.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitByte1.animation.addByPrefix('enter', 'Byte talk smile', 24, false);
		//portraitByte2.setGraphicSize(Std.int(portraitByte2.width * PlayState.daPixelZoom * 0.100));
		portraitByte1.updateHitbox();
		portraitByte1.scrollFactor.set();
		add(portraitByte1);
		portraitByte1.visible = false;
		portraitByte1.antialiasing = true;

		portraitByte2 = new FlxSprite(120, 150);
		portraitByte2.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitByte2.animation.addByPrefix('enter', 'Byte talk whoa', 24, false);
		//portraitByte2.setGraphicSize(Std.int(portraitByte2.width * PlayState.daPixelZoom * 0.100));
		portraitByte2.updateHitbox();
		portraitByte2.scrollFactor.set();
		add(portraitByte2);
		portraitByte2.visible = false;
		portraitByte2.antialiasing = true;

		portraitbf1 = new FlxSprite(720, 170);
		portraitbf1.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitbf1.animation.addByPrefix('enter', 'BF talk n2', 24, false);
		//portraitbf2.setGraphicSize(Std.int(portraitbf2.width * PlayState.daPixelZoom * 0.100));
		portraitbf1.updateHitbox();
		portraitbf1.scrollFactor.set();
		add(portraitbf1);
		portraitbf1.visible = false;
		portraitbf1.antialiasing = true;

		portraitbf2 = new FlxSprite(720, 170);
		portraitbf2.frames = Paths.getSparrowAtlas('portraits/portraits', 'shared');
		portraitbf2.animation.addByPrefix('enter', 'BF talk whoa', 24, false);
		//portraitbf2.setGraphicSize(Std.int(portraitbf2.width * PlayState.daPixelZoom * 0.100));
		portraitbf2.updateHitbox();
		portraitbf2.scrollFactor.set();
		add(portraitbf2);
		portraitbf2.visible = false;
		portraitbf2.antialiasing = true;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		//portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'VCR OSD Mono';
		dropText.color = 0xFF2196F3;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'VCR OSD Mono';
		swagDialogue.color = 0xFF0D47A1;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		//lol
		switch (curCharacter)
			{
				case 'bf':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText'), 0.6)];
				case 'byte':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('byteText'), 0.6)];
				case 'bf2':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText'), 0.6)];
				case 'byte2':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('byteText'), 0.6)];
				case 'gf':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				case 'bf-whoa':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendText'), 0.6)];
				case 'byte-sweat':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('byteText'), 0.6)];
				case 'gf-smile':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				case 'bfgf':
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfgfText'), 0.6)];
			}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'byte')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitgf.visible = false;
				portraitByte2.visible = false;
				portraitgf2.visible = false;
				portraitbf2.visible = false;
				portraitByte1.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'byte':
				portraitRight.visible = false;
				portraitgf.visible = false;
				portraitByte2.visible = false;
				portraitgf2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitByte2.visible = false;
				portraitgf2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitgf.visible)
				{
					portraitgf.visible = true;
					portraitgf.animation.play('enter');
				}
			case 'bf-whoa':
				portraitLeft.visible = false;
				portraitgf.visible = false;
				portraitByte2.visible = false;
				portraitgf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitbf2.visible)
				{
					portraitbf2.visible = true;
					portraitbf2.animation.play('enter');
				}
			case 'byte-sweat':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitgf.visible = false;
				portraitgf2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitByte2.visible)
				{
					portraitByte2.visible = true;
					portraitByte2.animation.play('enter');
				}
			case 'gf-smile':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitByte2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitgf2.visible)
				{
					portraitgf2.visible = true;
					portraitgf2.animation.play('enter');
				}
			case 'bfgf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitByte2.visible = false;
				portraitgf.visible = false;
				portraitgf2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitByte1.visible = false;
				if (!portraitgf.visible && !portraitRight.visible)
					{
						portraitgf.visible = true;
						portraitRight.visible = true;
						portraitgf.animation.play('enter');
						portraitRight.animation.play('enter');
					}

			case 'byte2':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitByte2.visible = false;
				portraitbf2.visible = false;
				portraitbf1.visible = false;
				portraitgf.visible = false;
				portraitgf2.visible = false;
				if (!portraitByte1.visible)
					{
						portraitByte1.visible = true;
						portraitByte1.animation.play('enter');
					}
			case 'bf2':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitByte2.visible = false;
				portraitbf2.visible = false;
				portraitgf.visible = false;
				portraitgf2.visible = false;
				portraitByte1.visible = false;
				if (!portraitbf1.visible)
					{
						portraitbf1.visible = true;
						portraitbf1.animation.play('enter');
					}
		}

	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
