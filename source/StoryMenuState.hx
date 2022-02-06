package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Ron', 'Wasted', 'Ayo', 'Bloodshed'],
		['Trojan Virus', 'Recycle-Bin', 'File-Manipulation', 'Factory-Reset'],
		['Raw-Meaty-Meats', 'Assassination', 'Steak'],
		['Holy-Shit-Dave-Fnf', 'Slammed', 'Meme-Machine', 'Frosting-Over'],
		['Bijuu', 'Goncy', 'Scrub-Of-The-Day']
		['Pretty-Wacky','He-Hates-Me', 'Atypical']
	];

	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, false];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['ron', 'bf', 'gf'],
		['ron2', 'bf', 'gf'],
		['cookron', 'bf', 'gf'],
		['bambi', 'ronMain', ''],
		['', 'bf', 'gf'],
		['douyhe', 'bf', 'gf']
	];

	var weekNames:Array<String> = [
		"Tutorial but less cooler B(",
		"VS COOL GUY B)",
		"O shit ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron ron",
		"THE MEAT IS RAW BOYFRIEND, THE MEAT IS RAW *SLAP*",
		"bm mabmabi hory sheet bambir IRL!!!!!!!!!!!!!!!!!!!!!!!!!!!! *vine tuhd*",
		"Folder turned Weeaboo",
		"what"
	];

	var txtWeekTitle:FlxText;
	var copyright:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var secret:String = "";
	var warning:String = "";
	var secretPng:FlxSprite;
	public var video:MP4Handler = new MP4Handler();

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end
		
		if (FlxG.save.data.douyhelikescheese)
			weekUnlocked = [true, true, true, true, true, true];
		else
			weekUnlocked = [true, true, true, true, true, false];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
		
		copyright = new FlxText(FlxG.width * 0.72, 600, 0, "", 32);
		copyright.setFormat(Paths.font("w95.otf"), 24, FlxColor.WHITE, LEFT);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 72).makeGraphic(FlxG.width, 400, 0xFF000000);
		bg = new FlxSprite(0, 56).loadGraphic(Paths.image('storyWeek1'));
		bg2 = new FlxSprite(-4, 64);
		bg2.scale.set(2, 2);
		bg2.frames = Paths.getSparrowAtlas('storyWeek2');
		bg2.antialiasing = true;
		bg2.animation.addByPrefix('storymode instance 1', 'storymode instance 1', 24, true);
		bg2.animation.play('storymode instance 1');
		bg2.updateHitbox();
		bg2.alpha = 0;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);
		secret = "";

		trace("Line 70");
		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();
			// Needs an offset thingie
			if (!weekUnlocked[i])
				weekThing.alpha = 0;
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('insane', 'INSANE');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(bg);
		add(bg2);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		add(copyright);
		
		secretPng = new FlxSprite().loadGraphic(Paths.image('holdup'));
		secretPng.scale.set(0.66,0.66);
		secretPng.screenCenter();
		secretPng.alpha = 0;
		add(secretPng);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{	
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];
		
		if ((curDifficulty == 3) && (curWeek == 1))
			warning = "(Hard mode recommended)";
		else
			warning = "";
		
		if (!FlxG.save.data.coolronweekcopyright)
			copyright.text = "Copyright mode: Off\rC: toggle\r" + warning;
		else
			copyright.text = "Copyright mode: On\rC: toggle\r" + warning;
		if (FlxG.keys.justPressed.C)
				FlxG.save.data.coolronweekcopyright = !FlxG.save.data.coolronweekcopyright;

		if (FlxG.keys.justPressed.ANY)
		{
			if (FlxG.keys.justPressed.A)
			{
				secret += 'a';
			}
			else if (FlxG.keys.justPressed.B)
			{
				secret += 'b';
			}
			else if (FlxG.keys.justPressed.D)
			{
				secret += 'd';
			}
			else if (FlxG.keys.justPressed.E)
			{
				secret += 'e';
			}
			else if (FlxG.keys.justPressed.F)
			{
				secret += 'f';
			}
			else if (FlxG.keys.justPressed.G)
			{
				secret += 'g';
			}
			else if (FlxG.keys.justPressed.H)
			{
				secret += 'h';
			}
			else if (FlxG.keys.justPressed.I)
			{
				secret += 'i';
			}
			else if (FlxG.keys.justPressed.K)
			{
				secret += 'k';
			}
			else if (FlxG.keys.justPressed.L)
			{
				secret += 'l';
			}
			else if (FlxG.keys.justPressed.N)
			{
				secret += 'n';
			}
			else if (FlxG.keys.justPressed.O)
			{
				secret += 'o';
			}
			else if (FlxG.keys.justPressed.R)
			{
				secret += 'r';
			}
			else if (FlxG.keys.justPressed.S)
			{
				secret += 's';
			}
			else if (FlxG.keys.justPressed.T)
			{
				secret += 't';
			}
			else if (FlxG.keys.justPressed.U)
			{
				secret += 'u';
			}
			else if (FlxG.keys.justPressed.V)
			{
				secret += 'v';
			}
			
			if (secret.length >= 46)
			{
				if (secret == 'helikestotalkaboutitanditshisfavoritethingever')
				{
					FlxG.save.data.douyhelikescheese = !FlxG.save.data.douyhelikescheese;
					FlxG.save.flush();
					if (FlxG.save.data.douyhelikescheese)
						weekUnlocked = [true, true, true, true, true, true];
					else
						weekUnlocked = [true, true, true, true, true, false];
					
					secretPng.alpha = 1;
					FlxTween.tween(secretPng, {alpha: 0}, 1);
					FlxG.sound.play(Paths.sound('hi'));
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
				secret = '';
			}
		}

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
				{
					changeDifficulty(1);
					updateText();
				}
				if (controls.LEFT_P)
				{
					changeDifficulty(-1);
					updateText();
				}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;
			if ((curDifficulty == 3) && (curWeek == 1))
				PlayState.storyPlaylist = ['Ron', 'Wasted', 'Ayo', 'Bleeding'];

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			switch (curWeek)
			{
				case 1:
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						video.playMP4(Paths.video('ron'), new PlayState(), false, false, false);
					});					
				case 2:
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						video.playMP4(Paths.video('trojanvirus'), new PlayState(), false, false, false);
					});
				case 3:
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						video.playMP4(Paths.video('cookron'), new PlayState(), false, false, false);
					});				
				default:
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
			}
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 3)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 3:
				sprDifficulty.animation.play('insane');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;
			
		if (!weekUnlocked[curWeek])
		{
			if (change > 0)
				curWeek = 0;
			else
				curWeek = 2;
		}
			
		// nvm
		if (curWeek == 2)
			bg2.alpha = 0;
		else
			bg2.alpha = 0;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0))
				item.alpha = 1;
			else
			{
				item.alpha = 0.6;
				if (!weekUnlocked[curWeek])
					item.alpha = 0;
			}
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];
		if ((curDifficulty == 3) && (curWeek == 1))
			stringThing = ['Ron', 'Wasted', 'Ayo', 'Bleeding'];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
