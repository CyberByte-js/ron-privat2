package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class NormalPlayState extends MusicBeatState
{
	var songs:Array<FreeplayState.SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var fdiffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var isB:Bool = false;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglistn'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new FreeplayState.SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scale.set(0.7, 0.7);
		bg.screenCenter(XY);
		bg.color = 0xFFE51F89;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		fdiffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "UNFAIR", 24);
		fdiffText.font = scoreText.font;
		fdiffText.visible = false;
		fdiffText.color = 0xFFFF0000;
		add(fdiffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		intendedColor = bg.color;
		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new FreeplayState.SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		FlxG.watch.addQuick("beatShit", curStep);
		Conductor.songPosition = FlxG.sound.music.time;

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MasterPlayState());
		}
		
		if (songs[curSelected].songName == 'BLOODSHED-TWO')
		{
			fdiffText.visible = true;
			diffText.visible = false;
		}
		else
		{
			fdiffText.visible = false;
			diffText.visible = true;
		}

		if (accepted)
		{
			FlxG.camera.antialiasing = true;
			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}
			
			trace(songs[curSelected].songName);

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			if (isB)
				poop = Highscore.formatSong(songFormat + "-b", curDifficulty);

			trace(poop);
			
			if (songs[curSelected].songName == 'BLOODSHED-TWO')
				PlayState.storyDifficulty = 2;
			else
				PlayState.storyDifficulty = curDifficulty;
			if ((songs[curSelected].songName == 'Bloodshed') && (curDifficulty == 3))
			{
				PlayState.storyDifficulty = 2;
				PlayState.SONG = Song.loadFromJson(poop, 'Bloodshed-old');
			}
			else if (isB)
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName + "-b");
			else
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);

			PlayState.isStoryMode = false;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (songs[curSelected].songName.contains("-b"))
		{
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}
		else
		{
			if (curDifficulty < 0)
			{
				modeSwap();
				curDifficulty = 4;
			}
			if (curDifficulty > 3)
				modeSwap();
			if (curDifficulty > 4)
			{	
				modeSwapA();
				curDifficulty = 0;
			}
			if (change == -1 && curDifficulty == 3)
				modeSwapA();
		}

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		if (songHighscore == 'BLOODSHED-TWO')
			curDifficulty = 2;
		
		#if !switch
		if (!isB)
			intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		else
			intendedScore = Highscore.getScore(songHighscore + "-b", curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end

		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
		if (songs[curSelected].songName.contains("-b"))
			diffText.text = CoolUtil.difficultyBFromInt(curDifficulty).toUpperCase();
	}
	
	override function beatHit()
	{
		switch (curSelected)
		{
			case 0:
				FlxG.camera.shake(0.0025, 0.05);
				if (curBeat % 2 == 1)
					FlxG.camera.angle = 1;
				else
					FlxG.camera.angle = -1;
					
				FlxG.camera.y += 2;
				FlxTween.tween(FlxG.camera, {y: 0}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(FlxG.camera, {angle: 0}, 0.2, {ease: FlxEase.quadInOut});
			case 1:
				FlxG.camera.shake(0.0025, 0.05);
				if (curBeat == 1)
				{
					var bruh:FlxSprite = new FlxSprite();
					bruh.loadGraphic(Paths.image('longbob'));
					bruh.antialiasing = true;
					bruh.active = false;
					bruh.scrollFactor.set();
					bruh.screenCenter();
					add(bruh);
					FlxTween.tween(bruh, {alpha: 0},1, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) 
						{
							bruh.destroy();
						}
					});
				}
			case 2:
				FlxG.camera.y += 5;
				FlxTween.tween(FlxG.camera, {y: 0}, 0.2, {ease: FlxEase.quadOut});
			case 3:
				if (curBeat % 2 == 1)
					FlxG.camera.angle = 2;
				else
					FlxG.camera.angle = -2;
					
				FlxTween.tween(FlxG.camera, {angle: 0}, 0.2, {ease: FlxEase.quadInOut});
			case 4:
				FlxG.camera.shake(0.0025, 0.05);
				if (curBeat % 2 == 1)
					FlxG.camera.zoom = 1.01;
				else
					FlxG.camera.zoom = 0.99;
					
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {ease: FlxEase.quadInOut});
			case 5:
				if (curBeat % 5 == 1)
					FlxG.camera.x += 5;
				else if (curBeat % 5 == 3)
					FlxG.camera.x -= 5;
				else if (curBeat % 5 == 2)
					FlxG.camera.y += 5;
				else if (curBeat % 5 == 4)
					FlxG.camera.y -= 5;
					
				FlxTween.tween(FlxG.camera, {x: 0}, 0.2, {ease: FlxEase.quadInOut});
				FlxTween.tween(FlxG.camera, {y: 0}, 0.2, {ease: FlxEase.quadInOut});
			case 6:
				if (curBeat % 2 == 1)
					FlxG.camera.zoom = 1.01;
				else
					FlxG.camera.zoom = 0.99;
					
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {ease: FlxEase.quadInOut});
			case 7:
				FlxG.camera.shake(0.0025, 0.05);
				if (curBeat % 2 == 1)
				{
					FlxG.camera.y += 5;
					FlxG.camera.angle = 2;
				}
				else
				{
					FlxG.camera.y -= 5;
					FlxG.camera.angle = -2;
				}
					
				FlxTween.tween(FlxG.camera, {y: 0}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(FlxG.camera, {angle: 0}, 0.2, {ease: FlxEase.quadInOut});
			case 8:
				FlxG.camera.shake(0.0015, 0.4);
				if (curBeat % 2 == 1)
					FlxG.camera.antialiasing = false;
				else
					FlxG.camera.antialiasing = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		curSelected += change;
		
		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		
		if (songs[curSelected].songName.contains("-b"))
		{
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}
		else
		{
			if (curDifficulty < 0)
			{
				modeSwap();
				curDifficulty = 4;
			}
			if (curDifficulty > 4)
			{
				modeSwapA();
				curDifficulty = 0;
			}
		}
		
		FlxG.camera.antialiasing = true;

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (isB)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName + "-b"), 0);
		else
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end
		
		if (!isB)
			Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase()).bpm/2);
		else
			Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase() + "-b", songs[curSelected].songName.toLowerCase() + "-b").bpm/2);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();

		var clr = 0xFFE51F89;

		if (!isB)
		{
			switch (curSelected)
			{
				case 1:
					clr = FlxColor.YELLOW;
				case 2:
					clr = FlxColor.ORANGE;
				case 3:
					clr = FlxColor.BROWN;
				case 4:
					clr = FlxColor.BLACK;
				case 5:
					clr = 0xFF6E7896;
				case 6:
					clr = FlxColor.GREEN;
				case 7:
					clr = 0xFF202020;
				case 8:
					clr = FlxColor.MAGENTA;
				case 9:
					clr = FlxColor.GRAY;
			}
		} else
		{
			switch (curSelected)
			{
				case 1:
					clr = FlxColor.MAGENTA;
				case 2:
					clr = FlxColor.PURPLE;
				case 3:
					clr = 0xFF8200AA;
				case 4:
					clr = FlxColor.WHITE;
				case 5:
					clr = 0xFF966E6E;
				case 6:
					clr = FlxColor.BLUE;
				case 7:
					clr = 0xFFDCDCDC;
				case 8:
					clr = FlxColor.CYAN;				
			}
		}
		
		
		if(clr != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = clr;
			colorTween = FlxTween.color(bg, 0.5, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
	}

	function modeSwap()
	{
		FlxG.camera.flash(FlxColor.WHITE, 0.5);
		isB = true;

		for (i in 0...songs.length)
			remove(iconArray[i]);
		untyped iconArray.length = 0;
		for (i in 0...songs.length)
		{
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter + "-b");
			icon.sprTracker = grpSongs.members[i];

			iconArray.push(icon);
			add(icon);
		}

		switch (curSelected)
		{
			case 1:
				bg.color = FlxColor.MAGENTA;
			case 2:
				bg.color = FlxColor.PURPLE;
			case 3:
				bg.color = 0xFF8200AA;
			case 4:
				bg.color = FlxColor.WHITE;
			case 5:
				bg.color = 0xFF966E6E;
			case 6:
				bg.color = FlxColor.BLUE;
			case 7:
				bg.color = 0xFFDCDCDC;
			case 8:
				bg.color = FlxColor.CYAN;				
		}
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName + "-b"), 0);
		Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase() + "-b", songs[curSelected].songName.toLowerCase() + "-b").bpm/2);
	}
	function modeSwapA()
	{
		FlxG.camera.flash(FlxColor.WHITE, 0.5);
		isB = false;

		for (i in 0...songs.length)
			remove(iconArray[i]);
		untyped iconArray.length = 0;
		for (i in 0...songs.length)
		{
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = grpSongs.members[i];

			iconArray.push(icon);
			add(icon);
		}

		switch (curSelected)
		{
			case 1:
				bg.color = FlxColor.YELLOW;
			case 2:
				bg.color = FlxColor.ORANGE;
			case 3:
				bg.color = FlxColor.BROWN;
			case 4:
				bg.color = FlxColor.BLACK;
			case 5:
				bg.color = 0xFF6E7896;
			case 6:
				bg.color = FlxColor.GREEN;
			case 7:
				bg.color = 0xFF202020;
			case 8:
				bg.color = FlxColor.MAGENTA;
			case 9:
				bg.color = FlxColor.GRAY;
		}
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		Conductor.changeBPM(Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase()).bpm/2);
	}
}