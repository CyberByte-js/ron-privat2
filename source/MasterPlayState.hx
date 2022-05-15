package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.addons.display.FlxBackdrop;
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

class MasterPlayState extends MusicBeatState
{
	var songs:Array<FreeplayState.SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var bg:FlxSprite;
	var bgScroll:FlxBackdrop;
	var fire:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('masterlist'));

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
		
		bgScroll = new FlxBackdrop(Paths.image('checkerboard'), 5, 5, true, true);
		bgScroll.scrollFactor.set();
		bgScroll.screenCenter();
		bgScroll.velocity.set(50, 50);
		add(bgScroll);
		
		fire = new FlxSprite();
		fire.frames = Paths.getSparrowAtlas('escape_fire');
		fire.scale.set(4,4);
		fire.animation.addByPrefix('idle', 'fire instance 1', 24, true);
		fire.animation.play('idle');
		fire.scrollFactor.set();
		fire.screenCenter();
		fire.y += 120;
		fire.alpha = 0;
		add(fire);

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

		intendedColor = bg.color;
		changeSelection();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

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
		bgScroll.color = bg.color;
		
		if (curSelected == 7)
			setChrome(FlxG.save.data.rgbintense/200);
		else
			setChrome(0.0);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		FlxG.watch.addQuick("beatShit", curStep);
		Conductor.songPosition = FlxG.sound.music.time;

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
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		
		if (accepted)
		{
			switch (curSelected)
			{
				case 0:
					FlxG.switchState(new NormalPlayState());
				case 1:
					FlxG.switchState(new BSidePlayState());
				case 2:
					FlxG.switchState(new ExtrasPlayState());
			}
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
		
		FlxG.camera.antialiasing = true;
		
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
		
		if (curSelected == 7)
		{
			FlxTween.cancelTweensOf(fire);
			fire.alpha = 0;
			FlxTween.tween(fire, {alpha: 0.5}, 1);
			FlxTween.cancelTweensOf(FlxG.camera);
			FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.5, {ease: FlxEase.quadInOut});
		}
		else
		{
			FlxTween.cancelTweensOf(fire);
			if (fire.alpha > 0)
			{
				FlxTween.tween(fire, {alpha: 0}, fire.alpha*2);
			}
			FlxTween.cancelTweensOf(FlxG.camera);
			FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.quadInOut});
		}

		var clr = FlxColor.YELLOW;
		switch (curSelected)
		{
			case 1:
				clr = FlxColor.RED;
			case 2:
				clr = FlxColor.WHITE;
			case 3:
				clr = FlxColor.LIME;
			case 4:
				clr = FlxColor.BLUE;
			case 5:
				clr = FlxColor.ORANGE;
			case 6:
				clr = FlxColor.MAGENTA;
			case 7:
				clr = FlxColor.BLACK;
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
}