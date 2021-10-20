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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

#if windows
import Sys;
#end

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

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var isCutscene:Bool = false;

	public var video:MP4Handler = new MP4Handler();

	public var cutsceneEnded:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		if (PlayState.SONG.song.toLowerCase() == 'bloodshed')
		{
			FlxG.sound.playMusic(Paths.music('bloodshed-dialogue-mus'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		} else if (PlayState.SONG.song.toLowerCase() == 'ron' || PlayState.SONG.song.toLowerCase() == 'ayo' || PlayState.SONG.song.toLowerCase() == 'wasted' || PlayState.SONG.song.toLowerCase() == 'trojan-virus' || PlayState.SONG.song.toLowerCase() == 'file-manipulation' || PlayState.SONG.song.toLowerCase() == 'atelophobia' || PlayState.SONG.song.toLowerCase() == 'factory-reset')
		{
			FlxG.sound.playMusic(Paths.music('talking-in-a-cool-way'), 0);
			FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
				

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
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
			case 'ron' | 'ayo' | 'wasted' | 'bloodshed' | 'trojan-virus' | 'file-manipulation' | 'atelophobia' | 'factory-reset' | 'bloodshed-old':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;

		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite();
		portraitLeft.frames = Paths.getSparrowAtlas('updateron/portraits/ronPortrait', 'shared');
		portraitLeft.animation.addByPrefix('ron Portrait Enter', 'ron Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width + PlayState.daPixelZoom * 0.175));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.screenCenter();
		portraitLeft.x -= 80;
		portraitLeft.y += 100;
		portraitLeft.scale.set(0.8, 0.8);
		add(portraitLeft);
		portraitLeft.visible = true;

		portraitRight = new FlxSprite();
		portraitRight.frames = Paths.getSparrowAtlas('updateron/portraits/bf', 'shared');
		portraitRight.animation.addByPrefix('bf', 'FTalk', 24, false);
		portraitRight.animation.addByPrefix('BTalk', 'BTalk', 24, false);
		portraitRight.animation.addByPrefix('FTalk', 'FTalk', 24, false);
		portraitRight.animation.addByPrefix('Fear', 'Fear', 24, false);
		portraitRight.animation.addByPrefix('Special', 'Special', 24, false);
		portraitRight.screenCenter();
		portraitRight.x += 250;
		portraitRight.y += 40;
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.8));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.alpha = 0.5;
		portraitRight.visible = true;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.7, FlxG.height * 0.85).loadGraphic(Paths.image('hand'));
		add(handSelect);
		FlxTween.tween(handSelect, {x: FlxG.width * 0.72}, 0.5, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (!talkingRight)
		{
			box.flipX;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFF3F2021;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFD89494;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ronText'), 0.6)];
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

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'ron' || PlayState.SONG.song.toLowerCase() == 'trojan-virus' || PlayState.SONG.song.toLowerCase() == 'file-manipulation' || PlayState.SONG.song.toLowerCase() == 'factory-reset')
						FlxG.sound.music.fadeOut(2.2, 0);
					else if (PlayState.SONG.song.toLowerCase() == 'atelophobia')
					{

					}
					else
					{
						FlxG.sound.music.fadeOut(2.2, 0);
					}
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
						if (!cutsceneEnded)
						{
							finishThing();
							kill();
						}else
						{
							return;	
						}
						
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
		if ((StringTools.contains(curCharacter, 'ron')) || (StringTools.contains(curCharacter, 'Ron')))
		{
			portraitLeft.frames = Paths.getSparrowAtlas('updateron/portraits/'+curCharacter, 'shared');
			portraitLeft.animation.addByPrefix('ron Portrait Enter', 'ron Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width + PlayState.daPixelZoom * 0.175));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			portraitLeft.screenCenter();
			portraitLeft.x -= 80;
			portraitLeft.y += 100;
			portraitLeft.scale.set(0.8, 0.8);
			portraitRight.alpha = 0.5;
			portraitLeft.alpha = 1;
			portraitLeft.animation.play('ron Portrait Enter');
			swagDialogue.sounds =  [FlxG.sound.load(Paths.sound('ronText'), 0.6)];
			dropText.font = Paths.font("w95.otf");
			dropText.color = 0xFFFFF4BB;
			swagDialogue.font = Paths.font("w95.otf");
			swagDialogue.color = 0xFFFFBF00;
			dropText.size = 48;
			swagDialogue.size = 48;
		}
		else
		{
			portraitLeft.alpha = 0.5;
			portraitRight.alpha = 1;
			trace('bf pog!!!');
			portraitRight.animation.play(curCharacter);
			swagDialogue.sounds =  [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFB9E5FF;
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF00BADA;
			dropText.size = 32;
			swagDialogue.size = 32;
		}
	}
	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
