package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
#if desktop
import sys.io.Process;
#end
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.filters.ColorMatrixFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{

	#if desktop
	var user = Sys.getEnv('USERNAME');
	#end
	
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public var video:MP4Handler = new MP4Handler();

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	var sus:String = "SUS";	
	var charInputs:String;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	public var luigi:Bool = false;

	var halloweenLevel:Bool = false;
	
	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var dad:Character;
	public static var dad2:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var satan:FlxSprite;
	var Estatic:FlxSprite;
	var Estatic2:FlxSprite;
	var firebg:FlxSprite;
	var hellbg:FlxSprite;
	var wastedbg:FlxSprite;
	var cloudsa:FlxSprite;
	var witheredRa:FlxSprite;
	var bgLol:FlxSprite;

	var fc:Bool = true;
	var fx:FlxSprite;
	var blackeffect:FlxSprite;
	var ronAnimation:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var loadingScreen:FlxSprite;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	public static var atelophobiaCutsceneDone = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	var uhoh:Bool = false;

	override public function create()
	{
		var charInputs:String = "";
		loadingScreen = new FlxSprite().loadGraphic(Paths.image('loadingGeneral'));
		loadingScreen.screenCenter();
        loadingScreen.setGraphicSize(Std.int(loadingScreen.width * 0.5));
		add(loadingScreen);
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;
		
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{

		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');
			
		// Updating Discord Rich Presence.
		
		// soon
		//var icon:String = storyWeek;
		
		var iconsong:String = 'normal';
		if (SONG.song.toLowerCase() == 'bloodshed')
			iconsong = 'bloodshed';
		if (SONG.song.toLowerCase() == 'trojan-virus')
			iconsong = 'trojan';
		if (SONG.song.toLowerCase() == 'file-manipulation')
			iconsong = 'trojan';
		if (SONG.song.toLowerCase() == 'atelophobia')
			iconsong = 'atelo';
		if (SONG.song.toLowerCase() == 'factory-reset')
			iconsong = 'reset';
		DiscordClient.changePresenceIcon(iconsong, detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);

		FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
		camHUD.setFilters([ShadersHandler.chromaticAberration]);

		//dialogue shit
		switch (songLowercase)
		{
			case 'pretty-wacky':
						dialogue = CoolUtil.coolTextFile(Paths.txt('pretty-wacky/diamane'));
			case 'ron':
						dialogue = CoolUtil.coolTextFile(Paths.txt('ron/ronIsBack'));
			case 'wasted':
						dialogue = CoolUtil.coolTextFile(Paths.txt('wasted/dialog'));
			case 'ayo':
						dialogue = CoolUtil.coolTextFile(Paths.txt('ayo/diaman'));
			case 'bloodshed':
						dialogue = CoolUtil.coolTextFile(Paths.txt('bloodshed/diamane'));
			case 'bloodshed-b':
						dialogue = CoolUtil.coolTextFile(Paths.txt('bloodshed-b/diamane'));
			case 'bloodshed-old':
						dialogue = CoolUtil.coolTextFile(Paths.txt('bloodshed-old/diamane'));
			case 'trojan-virus':
				{
					#if desktop		
					dialogue = [
						":ronPortraitPower:Yooooooo Whats up Bitch",
						":bf:what why tf are you here again",
						":ronPortraitPower:cuz you posted tha video on the internet",
						":ronPortraitPower:i hate u for that and i want you to Spontaneously Combust",
						":bf:oh ok",
						":bf:btw why tf are you glowing",
						":ronPortraitPower:so basicaly i went to buy free power and I got it!!!",
						":bf:guh?? wt",
						":ronPortraitPower:yea someone called " + user + " gave it to me",
						":bf:huh",
						":bf:who",
						":ronPortraitPower:idk but theyre pretty based",
						":ronPortraitPower:anyway I pull up Motherfucker!!! Get ready for your world to be Rocked",
						":bf:alr lmao"
						];
					#else
					dialogue = [
						":ronPortraitPower:Yooooooo Whats up Bitch",
						":bf:what why tf are you here again",
						":ronPortraitPower:cuz you posted tha video on the internet",
						":ronPortraitPower:i hate u for that and i want you to Spontaneously Combust",
						":bf:oh ok",
						":bf:btw why tf are you glowing",
						":ronPortraitPower:so basicaly i went to buy free power and I got it!!!",
						":bf:guh?? wt",
						":ronPortraitPower:yea someone called Admin gave it to me",
						":bf:huh",
						":bf:who",
						":ronPortraitPower:idk but theyre pretty based",
						":ronPortraitPower:anyway I pull up Motherfucker!!! Get ready for your world to be Rocked",
						":bf:alr lmao"
						];
					#end
				}
			case 'file-manipulation':
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('file-manipulation/dialoge'));
				}
			case 'atelophobia':
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('atelophobia/dialoge'));
				}
			case 'factory-reset':
				dialogue = CoolUtil.coolTextFile(Paths.txt('factory-reset/dialogueIForgor'));
			case 'holy-shit-dave-fnf':
				dialogue = CoolUtil.coolTextFile(Paths.txt('holy-shit-dave-fnf/dialoge'));
		}
		

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 1: if (songLowercase == 'Ayo') {stageCheck = 'mad';} else if (songLowercase == 'Bloodshed') {stageCheck == 'hell';} else {stageCheck = SONG.stage;}
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'mad':
			{
				defaultCamZoom = 0.9;
				curStage = 'mad';
				var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/pissedRon_sky'));
				bg.updateHitbox();
				bg.scale.x = 1;
				bg.scale.y = 1;
				bg.active = false;
				bg.antialiasing = true;
				bg.screenCenter();
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				
				var clouds:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/pissedRon_clouds'));
				clouds.updateHitbox();
				clouds.scale.x = 0.7;
				clouds.scale.y = 0.7;
				clouds.screenCenter();
				clouds.active = false;
				clouds.antialiasing = true;
				clouds.scrollFactor.set(0.2, 0.2);
				add(clouds);
				/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				add(glitchSprite);*/
				
				var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('updateron/bg/pissedRon_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
				
				wastedbg = new FlxSprite();
				wastedbg.frames = Paths.getSparrowAtlas('updateron/bg/wastedbg');
				wastedbg.scale.set(4,4);
				wastedbg.animation.addByPrefix('idle', 'bg instance 1', 24, true);
				wastedbg.animation.play('idle');
				wastedbg.screenCenter();
				wastedbg.alpha = 0;
				add(wastedbg);
			}
			case 'verymad':
			{
				defaultCamZoom = 0.9;
				curStage = 'verymad';
				var bg2:FlxSprite = new FlxSprite();
				bg2.frames = Paths.getSparrowAtlas('updateron/bg/trojan_bg');
				bg2.scale.set(4,4);
				bg2.animation.addByPrefix('idle', 'bg instance 1', 24, true);
				bg2.animation.play('idle');
				bg2.scrollFactor.set(0.05, 0.05);
				bg2.screenCenter();
				add(bg2);
				Estatic2 = new FlxSprite();
				Estatic2.frames = Paths.getSparrowAtlas('updateron/bg/trojan_static');
				Estatic2.scale.set(4,4);
				Estatic2.animation.addByPrefix('idle', 'static instance 1', 24, true);
				Estatic2.animation.play('idle');
				Estatic2.scrollFactor.set();
				Estatic2.screenCenter();
				add(Estatic2);
				var console:FlxSprite = new FlxSprite();
				console.frames = Paths.getSparrowAtlas('updateron/bg/trojan_console');
				console.scale.set(4,4);
				console.animation.addByPrefix('idle', 'ezgif.com-gif-maker (7)_gif instance 1', 24, true);
				console.animation.play('idle');
				console.scrollFactor.set(0.05, 0.05);
				console.screenCenter();
				console.alpha = 0.3;
				add(console);
				var popup:FlxSprite = new FlxSprite();
				popup.frames = Paths.getSparrowAtlas('updateron/bg/atelo_popup_animated');
				popup.scale.set(4,4);
				popup.animation.addByPrefix('idle', 'popups instance 1', 24, true);
				popup.animation.play('idle');
				popup.scrollFactor.set(0.05, 0.05);
				popup.screenCenter();
				add(popup);
				bgLol = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/veryAngreRon_sky'));
				bgLol.updateHitbox();
				bgLol.scale.x = 1;
				bgLol.scale.y = 1;
				bgLol.active = false;
				bgLol.antialiasing = true;
				bgLol.screenCenter();
				bgLol.scrollFactor.set(0.1, 0.1);
				add(bgLol);
				witheredRa = new FlxSprite(-512, -260);
				witheredRa.frames = Paths.getSparrowAtlas('updateron/bg/annoyed_rain');
				witheredRa.setGraphicSize(Std.int(witheredRa.width * 4));
				witheredRa.animation.addByPrefix('rain', 'rain', 24, true);
				witheredRa.updateHitbox();
				witheredRa.antialiasing = true;
				witheredRa.scrollFactor.set(0.5,0.1);
				witheredRa.screenCenter(XY);
				add(witheredRa);
				witheredRa.animation.play('rain');
				
				cloudsa = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/veryAngreRon_clouds'));
				cloudsa.updateHitbox();
				cloudsa.scale.x = 0.7;
				cloudsa.scale.y = 0.7;
				cloudsa.screenCenter();
				cloudsa.active = false;
				cloudsa.antialiasing = true;
				cloudsa.scrollFactor.set(0.2, 0.2);
				add(cloudsa);
				/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				add(glitchSprite);*/
				
				var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('updateron/bg/veryAngreRon_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
				ronAnimation = new FlxSprite();
				ronAnimation.frames = Paths.getSparrowAtlas('updateron/characters/ronPower-transformation');
				ronAnimation.animation.addByPrefix('idle', 'ron transformation instance 1', 24, false);
				ronAnimation.animation.play('idle');
				ronAnimation.visible = false;
			}
			case 'hell':
			{
				defaultCamZoom = 0.85;
				curStage = 'hell';
				hellbg = new FlxSprite();
				hellbg.frames = Paths.getSparrowAtlas('updateron/bg/hell_bg');
				hellbg.scale.set(5,5);
				hellbg.animation.addByPrefix('idle instance 1', 'idle instance 1', 48, true);
				hellbg.animation.play('idle instance 1');
				hellbg.antialiasing = true;
				hellbg.screenCenter(XY);
				hellbg.y += hellbg.height / 5;
				hellbg.scrollFactor.set(0.05, 0.05);
				add(hellbg);
				firebg = new FlxSprite();
				firebg.frames = Paths.getSparrowAtlas('updateron/bg/escape_fire');
				firebg.scale.set(6,6);
				firebg.animation.addByPrefix('idle', 'fire instance 1', 24, true);
				firebg.animation.play('idle');
				firebg.scrollFactor.set();
				firebg.screenCenter();
				firebg.alpha = 0;
				add(firebg);
				satan = new FlxSprite(300, 200).loadGraphic(Paths.image('updateron/bg/hellRon_satan'));
				satan.antialiasing = true;
				satan.scale.set(1.2,1.2);
				satan.screenCenter(XY);
				satan.scrollFactor.set(0.15, 0.15);
				satan.y -= 100;
				satan.active = true;
				add(satan);	
				var ground:FlxSprite = new FlxSprite(300,200).loadGraphic(Paths.image('updateron/bg/hellRon_ground'));
				ground.antialiasing = true;
				ground.screenCenter(XY);
				ground.scrollFactor.set(0.9, 0.9);
				ground.active = false;
				add(ground);
				fx = new FlxSprite().loadGraphic(Paths.image('updateron/bg/effect'));
				fx.setGraphicSize(Std.int(2560 * 0.75));
				fx.updateHitbox();
				fx.antialiasing = true;
				fx.screenCenter(XY);
				fx.scrollFactor.set(0, 0);
				fx.alpha = 0.3;		
				blackeffect = new FlxSprite().makeGraphic(FlxG.width*3, FlxG.height*3, FlxColor.BLACK);
				blackeffect.updateHitbox();
				blackeffect.antialiasing = true;
				blackeffect.screenCenter(XY);
				blackeffect.scrollFactor.set();
				blackeffect.alpha = 1;
				if (SONG.song != 'Bloodshed-b')
					blackeffect.alpha = 0;
				add(blackeffect);
				Estatic = new FlxSprite().loadGraphic(Paths.image('updateron/bg/deadly'));
				Estatic.scrollFactor.set();
				Estatic.screenCenter();
				Estatic.alpha = 0;
				Estatic2 = new FlxSprite();
				Estatic2.frames = Paths.getSparrowAtlas('updateron/bg/trojan_static');
				Estatic2.scale.set(4,4);
				Estatic2.animation.addByPrefix('idle', 'static instance 1', 24, true);
				Estatic2.animation.play('idle');
				Estatic2.scrollFactor.set();
				Estatic2.screenCenter();
				Estatic2.alpha = 0;
			}
			case 'glitch':
				defaultCamZoom = 0.7;
				curStage = 'glitch';
				var bg:FlxSprite = new FlxSprite();
				bg.frames = Paths.getSparrowAtlas('updateron/bg/atelo_bg');
				bg.scale.set(2,2);
				bg.animation.addByPrefix('idle', 'bg instance 1', 24, true);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.05, 0.05);
				bg.screenCenter();
				add(bg);
				var popup:FlxSprite = new FlxSprite();
				popup.frames = Paths.getSparrowAtlas('updateron/bg/atelo_popup_animated');
				popup.scale.set(4,4);
				popup.animation.addByPrefix('idle', 'popups instance 1', 24, true);
				popup.animation.play('idle');
				popup.scrollFactor.set(0.05, 0.05);
				popup.screenCenter();
				add(popup);
				var lamp:FlxSprite = new FlxSprite(900, 100);
				lamp.frames = Paths.getSparrowAtlas('updateron/bg/atelo_lamp');
				lamp.scale.set(2,2);
				lamp.animation.addByPrefix('idle', 'lamppost instance 1', 24, true);
				lamp.animation.play('idle');
				lamp.scrollFactor.set(0.9, 0.9);
				add(lamp);
				var ground:FlxSprite = new FlxSprite().loadGraphic(Paths.image('updateron/bg/atelo_ground'));
				ground.scale.set(2,2);
				ground.screenCenter(X);
				ground.antialiasing = true;
				ground.scrollFactor.set(0.9, 0.9);
				ground.active = false;
				add(ground);
				var error:FlxSprite = new FlxSprite(900, 550);
				error.frames = Paths.getSparrowAtlas('updateron/bg/error');
				error.scale.set(2,2);
				error.animation.addByPrefix('idle', 'error instance 1', 24, true);
				error.animation.play('idle');
				error.updateHitbox();
				error.antialiasing = true;
				add(error);
				var error2:FlxSprite = new FlxSprite(-650, 550);
				error2.frames = Paths.getSparrowAtlas('updateron/bg/error');
				error2.scale.set(2,2);
				error2.animation.addByPrefix('idle', 'error instance 1', 24, true);
				error2.animation.play('idle');
				error2.updateHitbox();
				error2.antialiasing = true;
				add(error2);
			case 'baka':
				{
					defaultCamZoom = 0.9;
					curStage = 'baka';
					var bg:FlxSprite = new FlxSprite(300, 200).loadGraphic(Paths.image('ron/bg/unknown'));
					bg.setGraphicSize(Std.int(bg.width * 4));
					bg.setGraphicSize(Std.int(bg.height * 4));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
				}
			case 'win':
				{
					defaultCamZoom = 0.8;
					curStage = 'win';
					
					#if PRELOAD_ALL			
						var images = [];
						var xml = [];
						trace("caching images...");
			
						for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/cachecharacters/")))
						{
							if (!i.endsWith(".png"))
								continue;
							images.push(i);
			
							if (!i.endsWith(".xml"))
								continue;
							xml.push(i);
						}
						for (i in images)
						{
							var replaced = i.replace(".png","");
							FlxG.bitmap.add(Paths.image("updateron/cachecharacters/" + replaced,"shared"));
							trace("cached " + replaced);
						}
					
					for (i in xml)
						{
							var replaced = i.replace(".xml","");
							FlxG.bitmap.add(Paths.image("updateron/cachecharacters/" + replaced,"shared"));
							trace("cached " + replaced);
						}
					#end
					var bg:FlxSprite = new FlxSprite();
					bg.frames = Paths.getSparrowAtlas('updateron/bg/trojan_bg');
					bg.scale.set(4,4);
					bg.animation.addByPrefix('idle', 'bg instance 1', 24, true);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.05, 0.05);
					bg.screenCenter();
					add(bg);
					Estatic2 = new FlxSprite().loadGraphic(Paths.image('updateron/bg/deadly'));
					Estatic2.scrollFactor.set();
					Estatic2.screenCenter();
					Estatic2.alpha = 0;
					var console:FlxSprite = new FlxSprite();
					console.frames = Paths.getSparrowAtlas('updateron/bg/trojan_console');
					console.scale.set(4,4);
					console.animation.addByPrefix('idle', 'ezgif.com-gif-maker (7)_gif instance 1', 24, true);
					console.animation.play('idle');
					console.scrollFactor.set(0.05, 0.05);
					console.screenCenter();
					console.alpha = 0.3;
					add(console);
					var popup:FlxSprite = new FlxSprite();
					popup.frames = Paths.getSparrowAtlas('updateron/bg/atelo_popup_animated');
					popup.scale.set(4,4);
					popup.animation.addByPrefix('idle', 'popups instance 1', 24, true);
					popup.animation.play('idle');
					popup.scrollFactor.set(0.05, 0.05);
					popup.screenCenter();
					add(popup);
					var lamp:FlxSprite = new FlxSprite(900, 100);
					lamp.frames = Paths.getSparrowAtlas('updateron/bg/glitch_lamp');
					lamp.scale.set(2,2);
					lamp.animation.addByPrefix('idle', 'lamppost', 24, true);
					lamp.animation.play('idle');
					lamp.scrollFactor.set(0.9, 0.9);
					add(lamp);
					var ground:FlxSprite = new FlxSprite(-537, -290).loadGraphic(Paths.image('updateron/bg/trojan_ground'));
					ground.updateHitbox();
					ground.active = false;
					ground.antialiasing = true;
					add(ground);
					var error:FlxSprite = new FlxSprite(900, 550);
					error.frames = Paths.getSparrowAtlas('updateron/bg/error');
					error.scale.set(2,2);
					error.animation.addByPrefix('idle', 'error instance 1', 24, true);
					error.animation.play('idle');
					error.updateHitbox();
					error.antialiasing = true;
					add(error);
					Estatic = new FlxSprite();
					Estatic.frames = Paths.getSparrowAtlas('updateron/bg/trojan_static');
					Estatic.scale.set(4,4);
					Estatic.animation.addByPrefix('idle', 'static instance 1', 24, true);
					Estatic.animation.play('idle');
					Estatic.scrollFactor.set();
					Estatic.screenCenter();
					ronAnimation = new FlxSprite();
					ronAnimation.frames = Paths.getSparrowAtlas('updateron/characters/ateloron-Transform');
					ronAnimation.animation.addByPrefix('idle', 'transformation instance 1', 24);
					ronAnimation.animation.play('idle');
					ronAnimation.visible = false;
					add(Estatic2);
				}
			case 'trouble' :
				{
					defaultCamZoom = 0.9;
					curStage = 'trouble';
					var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/nothappy_sky'));
					bg.updateHitbox();
					bg.scale.x = 1.2;
					bg.scale.y = 1.2;
					bg.active = false;
					bg.antialiasing = true;
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);
					/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
					var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
					add(glitchSprite);*/
					
					var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('updateron/bg/nothappy_ground'));
					ground.updateHitbox();
					ground.active = false;
					ground.antialiasing = true;
					add(ground);

					var deadbob:FlxSprite = new FlxSprite(-700, 600).loadGraphic(Paths.image('updateron/bg/GoodHeDied'));
					deadbob.updateHitbox();
					deadbob.active = false;
					deadbob.antialiasing = true;
					add(deadbob);
					
				}
			case 'void':
				{
					defaultCamZoom = 0.5;
					curStage = 'baka';
					var bg:FlxSprite = new FlxSprite(300, 200).loadGraphic(Paths.image('updateron/bg/effect'));
					bg.antialiasing = true;
					bg.active = false;
					add(bg);
				}
				case 'glitch-factory':
					defaultCamZoom = 0.7;
					curStage = 'glitch-factory';
					var bg:FlxSprite = new FlxSprite();
					bg.frames = Paths.getSparrowAtlas('updateron/bg/atelo_bg');
					bg.scale.set(2, 2);
					bg.animation.addByPrefix('idle', 'bg instance 1', 24, true);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.05, 0.05);
					bg.screenCenter();
					add(bg);
					var popup:FlxSprite = new FlxSprite();
					popup.frames = Paths.getSparrowAtlas('updateron/bg/atelo_popup_animated');
					popup.scale.set(4, 4);
					popup.animation.addByPrefix('idle', 'popups instance 1', 24, true);
					popup.animation.play('idle');
					popup.scrollFactor.set(0.05, 0.05);
					popup.screenCenter();
					add(popup);
					var lamp:FlxSprite = new FlxSprite(900, 100);
					lamp.frames = Paths.getSparrowAtlas('updateron/bg/atelo_lamp');
					lamp.scale.set(2, 2);
					lamp.animation.addByPrefix('idle', 'lamppost instance 1', 24, true);
					lamp.animation.play('idle');
					lamp.scrollFactor.set(0.9, 0.9);
					add(lamp);
					var ground:FlxSprite = new FlxSprite().loadGraphic(Paths.image('updateron/bg/atelo_ground'));
					ground.scale.set(2, 2);
					ground.screenCenter(X);
					ground.antialiasing = true;
					ground.scrollFactor.set(0.9, 0.9);
					ground.active = false;
					add(ground);
					var error:FlxSprite = new FlxSprite(900, 550);
					error.frames = Paths.getSparrowAtlas('updateron/bg/error');
					error.scale.set(2, 2);
					error.animation.addByPrefix('idle', 'error instance 1', 24, true);
					error.animation.play('idle');
					error.updateHitbox();
					error.antialiasing = true;
					add(error);
					var error2:FlxSprite = new FlxSprite(-650, 550);
					error2.frames = Paths.getSparrowAtlas('updateron/bg/error');
					error2.scale.set(2, 2);
					error2.animation.addByPrefix('idle', 'error instance 1', 24, true);
					error2.animation.play('idle');
					error2.updateHitbox();
					error2.antialiasing = true;
					add(error2);

					// Morshu
					var morshu:FlxSprite = new FlxSprite(-650, 0);
					morshu.frames = Paths.getSparrowAtlas('updateron/bg/mmm');
					morshu.animation.addByPrefix('idle', 'bop', 24, true);
					morshu.animation.play('idle');
					morshu.updateHitbox();
					morshu.antialiasing = true;
					add(morshu);

					// Caleb
					var caleb:FlxSprite = new FlxSprite(900, 0);
					caleb.frames = Paths.getSparrowAtlas('updateron/bg/ears');
					caleb.animation.addByPrefix('idle', 'bop', 24, true);
					caleb.animation.play('idle');
					caleb.updateHitbox();
					caleb.antialiasing = true;
					add(caleb);
			case 'daveHouse':
			{
				defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('updateron/bg/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;

				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('updateron/bg/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('updateron/bg/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('updateron/bg/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				
				add(stageFront);
			}
			case 'bambiFarm':
			{
				defaultCamZoom = 0.9;
	
				var bg:FlxSprite = new FlxSprite(-700, 0).loadGraphic(Paths.image('updateron/bg/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
	
				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('updateron/bg/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
	
				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('updateron/bg/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('updateron/bg/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;

				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('updateron/bg/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('updateron/bg/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('updateron/bg/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
	
				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('updateron/bg/Sign'));
				sign.antialiasing = true;
				sign.active = false;

				add(bg);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
			}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('updateron/bg/happyRon_sky'));
				bg.updateHitbox();
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				add(glitchSprite);*/
				
				var ground:FlxSprite = new FlxSprite(-537, -290).loadGraphic(Paths.image('updateron/bg/happyRon_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}
		}
		}
		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
			if (curSong == 'Bloodshed' || curSong == 'not-bloodshed')
				gfCheck = 'gf-run';
			if (curSong == 'Ayo')
				gfCheck = 'gf-d';
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'gf-run':
				curGf = 'gf-run';
			case 'gf-b':
				curGf = 'gf-b';
			case 'gf-d':
				curGf = 'gf-d';
			default:
				curGf = 'gf';
		}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);
		dad2 = new Character(800, 150, 'ronslaught-pov');

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		var bfcolor = 0xFF31B0D1;
		if (SONG.player1 == 'bf-b')
			bfcolor = 0xFFFF45FF;

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}
			case 'hell':
				if(FlxG.save.data.distractions){
					// trailArea.scrollFactor.set();
					if (dad.alpha == 1)
					{
						var evilTrail = new FlxTrail(dad, null, 4, 24, 0.15, 0.0345);
						evilTrail.changeValuesEnabled(false, true, true, false);
						// evilTrail.changeValuesEnabled(false, false, false, false);
						// evilTrail.changeGraphic()
						add(evilTrail);
						// evilTrail.scrollFactor.set(1.1, 1.1);
						if (dad.animation.curAnim.name.endsWith('UP'))
							FlxTween.tween(evilTrail, {y: dad.y -= 150}, 1);
						if (dad.animation.curAnim.name.endsWith('DOWN'))
							FlxTween.tween(evilTrail, {y: dad.y += 150}, 1);
						if (dad.animation.curAnim.name.endsWith('LEFT'))
							FlxTween.tween(evilTrail, {x: dad.x -= 150}, 1);
						if (dad.animation.curAnim.name.endsWith('RIGHT'))
							FlxTween.tween(evilTrail, {x: dad.x += 150}, 1);
						if (SONG.song == 'BLOODSHED-TWO')
							remove(evilTrail);
					}
				}
			
				//gf disappears anyway lmao we dont need this
		}

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			add(dad);
			add(boyfriend);
		}
		
		if (SONG.song == 'Double-Trouble')
			add(dad2);

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		var doof2:DialogueBoxDave = new DialogueBoxDave(false, dialogue);
		doof2.scrollFactor.set();
		if (SONG.song.toLowerCase() == 'atelophobia')
			doof.finishThing = gfdies;
		else
			doof.finishThing = startCountdown;
			
		doof2.finishThing = startCountdown;
		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);
		
		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, 0xFFFFD800);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("w95.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFFD800, 0xFF31B0D1);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
		{	
			var songName = SONG.song;
			if (songName == 'Holy-Shit-Dave-Fnf')
				songName = 'Dave-Fnf';
			kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,songName + " - " + CoolUtil.difficultyFromInt(storyDifficulty) + (Main.watermarks ? " | " + "Tristan Engine (KE 1.2)" : ""), 16);
		}
		else
			kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - " + CoolUtil.difficultyFromInt(storyDifficulty) + (Main.watermarks ? " | " + MainMenuState.kadeEngineVer : ""), 16);
		if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
			kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		else
			kadeEngineWatermark.setFormat(Paths.font("w95.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2, healthBarBG.y + 50, 0, "", 20);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
			scoreTxt.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		else
			scoreTxt.setFormat(Paths.font("w95.otf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		add(scoreTxt);
		scoreTxt.screenCenter(X);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
			replayTxt.setFormat(Paths.font("comic.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		else
			replayTxt.setFormat(Paths.font("w95.otf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
			botPlayState.setFormat(Paths.font("comic.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		else
			botPlayState.setFormat(Paths.font("w95.otf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		
		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
				
			healthBar.createFilledBar(0xFFFFD800, bfcolor);

			case 'douyhe':
				dad.x += 70;
				dad.y += 200;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFFFFFF, bfcolor);
			case 'dave':
				dad.y += 160;
				dad.x += 90;
				gf.visible = false;
				boyfriend.y -= 120;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			case 'bambi':
				dad.y += 400;
				gf.visible = false;
				boyfriend.y -= 120;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			case 'ron':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ronDave':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ronPower':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ron-angry':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ronangry-b':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF00DC, bfcolor);
			case 'ron-mad':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ronmad-b':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF00DC, bfcolor);
			case 'hellron-crazy':
				dad.x += 70;
				dad.y += 290;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y + 300);
			case 'hellron':
				dad.x += 70;
				dad.y += 310;
				camPos.set(dad.getGraphicMidpoint().x + 150, dad.getGraphicMidpoint().y + 300);
				healthBar.createFilledBar(0xFF000000, bfcolor);
			case 'hellron-pov':
				dad.x -= 300;
				gf.visible = false;
				healthBar.createFilledBar(0xFF000000, bfcolor);
			case 'devilron':
				dad.x += 70;
				dad.y += 310;
				camPos.set(dad.getGraphicMidpoint().x + 150, dad.getGraphicMidpoint().y + 300);
				healthBar.createFilledBar(0xFF000000, bfcolor);
			case 'demonron':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF0000, bfcolor);
			case 'bijuuron':
				dad.x -= 80;
				dad.y += 120;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFEBDD44, bfcolor);
			case 'susron':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ateloron':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFF000000, bfcolor);
			case 'ronb':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFF00DC, bfcolor);
			case 'ron-usb':
				dad.x += 90;
				dad.y += 190;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFF000000, bfcolor);
			case 'factorytankman':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFF877000, bfcolor);
			case 'factorytankman-b':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFF8E007B, bfcolor);
			case 'ron-usb-b':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFFFFFF, bfcolor);
			case 'hellron-2':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFFFFFF, bfcolor);
			case 'ateloron-b':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				healthBar.createFilledBar(0xFFFFFFFF, bfcolor);
			case 'tankman':
				dad.x += 70;
				dad.y += 250;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');
		remove(loadingScreen);
				

			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case 'ron':
					schoolIntro(doof);
				case 'wasted':
					schoolIntro(doof);
				case 'ayo':
					schoolIntro(doof);
				case 'bloodshed':
					schoolIntro(doof);
					add(fx);
					add(Estatic);
					FlxTween.tween(Estatic, {"scale.x":0.8,"scale.y":0.8}, 0.5, {ease: FlxEase.quadInOut, type: PINGPONG});
				case 'not-bloodshed':
					startCountdown();
					add(fx);
					add(Estatic);
					FlxTween.tween(Estatic, {"scale.x":0.8,"scale.y":0.8}, 0.5, {ease: FlxEase.quadInOut, type: PINGPONG});
				case 'bloodshed-two':
					startCountdown();
					add(fx);
					add(Estatic);
					add(Estatic2);
					FlxTween.tween(Estatic, {"scale.x":0.8,"scale.y":0.8}, 0.5, {ease: FlxEase.quadInOut, type: PINGPONG});
				case 'pretty-wacky':
					schoolIntro(doof);
				case 'bloodshed-old':
					schoolIntro(doof);
					add(fx);
					add(Estatic);
					firebg.alpha = 1;
				case 'trojan-virus':
					schoolIntro(doof);
					add(Estatic);
					add(ronAnimation);
				case 'file-manipulation':
					schoolIntro(doof);
					add(ronAnimation);
					add(Estatic2);
					FlxTween.tween(Estatic2, {"scale.x":0.8,"scale.y":0.8}, 0.5, {ease: FlxEase.quadInOut, type: PINGPONG});
					add(Estatic);
				case 'trojan-virus-b':
					add(Estatic);
					startCountdown();
				case 'file-manipulation-b':
					add(Estatic);
					startCountdown();
				case 'atelophobia':
					camFollow.y = dad.getMidpoint().y;
					camFollow.x = dad.getMidpoint().x + 300;
					FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
					schoolIntro(doof);
				case 'bloodshed-b':
					schoolIntro(doof);
					add(fx);
					gf.visible = false;
				case 'holy-shit-dave-fnf':
					schoolIntro2(doof2, false);
				default:
					startCountdown();
			}

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);

		super.create();
	}
	
	function gfdies():Void
	{
		//PlayState.atelophobiaCutsceneDone = true;
		//finishThing = function() { };
		//video.playMP4(Paths.video('atelscene'), new PlayState(), false, false, false);
		camFollow.y = gf.getMidpoint().y;
		camFollow.x = gf.getMidpoint().x;
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		FlxTween.tween(FlxG.camera, {zoom:1.1}, 0.75, {ease: FlxEase.cubeInOut});
		new FlxTimer().start(1, function(swagTimer:FlxTimer)
		{  	
			FlxG.sound.play(Paths.sound('pop'), 0.8);
			PlayState.gf.visible = false;
			new FlxTimer().start(1.25, function(swagTimer:FlxTimer)
			{  
				camFollow.y = dad.getMidpoint().y;
				camFollow.x = dad.getMidpoint().x + 300;
				FlxTween.tween(FlxG.camera, {zoom:0.9}, 2, {ease: FlxEase.cubeInOut});
				atelophobiaCutsceneDone = true;
				dialogue = CoolUtil.coolTextFile(Paths.txt('atelophobia/dialoge2'));
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
				var lol:DialogueBox = new DialogueBox(false, dialogue);
				lol.scrollFactor.set();
				lol.finishThing = startCountdown;
				add(lol);
				lol.cameras = [camHUD];
			});
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		remove(black);

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			// i HATE the slow black screen intro smh
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}
	
	function schoolIntro2(?dialogueBox2:DialogueBoxDave, ?isStart:Bool = true):Void
	{
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox2 != null)
			{
				add(dialogueBox2);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1, true);


		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		#if windows
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end

		var strtspd = Conductor.crochet / 1000;
		if (songLowercase == 'bloodshed-two')
			strtspd /= 5;

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= strtspd * 1000 * 5;

		var swagCounter:Int = 0;
		startTimer = new FlxTimer().start(strtspd, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, strtspd, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, strtspd, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, strtspd, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
					if (curSong == "Trojan-Virus")
						{
						var bruh:FlxSprite = new FlxSprite();
						bruh.loadGraphic(Paths.image('ron/longbob'));
						bruh.antialiasing = true;
						bruh.active = false;
						bruh.scrollFactor.set();
						bruh.screenCenter();
						add(bruh);
						FlxTween.tween(bruh, {alpha: 0}, 1, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								bruh.destroy();
							}
				});
						}
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));
	
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];

		var data = -1;
		
		switch(evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (evt.keyLocation == KeyLocation.NUM_PAD)
		{
			trace(String.fromCharCode(evt.charCode) + " " + key);
		}

		if (data == -1)
			return;

		var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit


		dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note
		
		if (dataNotes.length != 0)
		{
			var coolNote = dataNotes[0];

			goodNoteHit(coolNote);
			var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			ana.hit = true;
			ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			ana.nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
		}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{			
			if ((FlxG.save.data.coolronweekcopyright) && ((PlayState.SONG.song.toLowerCase() == 'atelophobia') || (PlayState.SONG.song.toLowerCase() == 'ayo') || (PlayState.SONG.song.toLowerCase() == 'factory-reset') ||	(PlayState.SONG.song.toLowerCase() == 'ayo-b') || (PlayState.SONG.song.toLowerCase() == 'factory-reset-b')))
			{
				FlxG.sound.playMusic(Paths.censoredinst(PlayState.SONG.song), 1, false);
			}
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			if ((SONG.stage == 'bambiFarm') || (SONG.stage == 'daveHouse'))
				songName.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			else
				songName.setFormat(Paths.font("w95.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();
			
		if ((FlxG.save.data.coolronweekcopyright) && ((PlayState.SONG.song.toLowerCase() == 'atelophobia') || (PlayState.SONG.song.toLowerCase() == 'ayo') || (PlayState.SONG.song.toLowerCase() == 'factory-reset') ||	(PlayState.SONG.song.toLowerCase() == 'ayo-b') || (PlayState.SONG.song.toLowerCase() == 'factory-reset-b')))
		{
			SONG.needsVoices = false;
			vocals = new FlxSound();
		}

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (storyDifficulty)
				{
					case 3:
					songLowercase = songLowercase + "-b";
				}
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var skin = 'NOTE_assets';

				var gottaHitNote:Bool = section.mustHitSection;

				var daNoteType:Int = songNotes[3];

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
		
				if (gottaHitNote == false) {
					skin = 'ronsip';
					switch (dad.curCharacter)
					{
						case 'douyhe':
							skin = 'NOTE_assets';
						case 'hellron':
							skin = 'ronhell';
						case 'ateloron':
							skin = 'ronhell';
						case 'ron-usb':
							skin = 'ronhell';
						case 'demonron':
							skin = 'demonsip';
						case 'ronb':
							skin = 'evik';
						case 'ronmad-b':
							skin = 'evik';
						case 'ronangry-b':
							skin = 'evik';
						case 'hellron-2':
							skin = 'bhell';
						case 'ateloron-b':
							skin = 'bhell';
						case 'ron-usb-b':
							skin = 'bhell';
						case 'dave':
							skin = 'NOTEold_assets';
						case 'bambi':
							skin = 'NOTEold_assets';
						case 'ronDave':
							skin = 'NOTEold_assets';
					}
				}

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, skin, false, daNoteType);

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, skin, false, daNoteType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, ?force:Bool):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}
				
					case 'normal':
						var skin = 'ronsip';
						switch (dad.curCharacter)
						{
							case 'douyhe':
								skin = 'NOTE_assets';
							case 'hellron':
								skin = 'ronhell';
							case 'devilron':
								skin = 'ronhell';
							case 'ateloron':
								skin = 'ronhell';
							case 'ron-usb':
								skin = 'ronhell';
							case 'demonron':
								skin = 'demonsip';
							case 'devilron':
								skin = 'demonsip';
							case 'ronb':
								skin = 'evik';
							case 'ronmad-b':
								skin = 'evik';
							case 'hellron-2':
								skin = 'bhell';
							case 'ateloron-b':
								skin = 'bhell';
							case 'ron-usb-b':
								skin = 'bhell';
							case 'dave':
								skin = 'NOTEold_assets';
							case 'bambi':
								skin = 'NOTEold_assets';
							case 'ronDave':
								skin = 'NOTEold_assets';
						}
						
						if (force)
						{
							var sskin = 'NOTE_assets';
							if (SONG.player1 == 'ronDave')
								sskin = 'NOTEold_assets';
							babyArrow.frames = Paths.getSparrowAtlas(sskin);
						}
						else
							babyArrow.frames = Paths.getSparrowAtlas(skin);
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
	
					default:
						if (player == 0)
							babyArrow.frames = Paths.getSparrowAtlas('ronsip');
						else
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
					
			var credits = 'uhrhmmmm.. um';
			// jacks what the fuck
			switch (curSong.toLowerCase())
			{
				case 'ron':
					credits = 'wildythomas';
				case 'wasted':
					credits = 'coquers_';
				case 'ayo':
					credits = 'Tigression';
				case 'bloodshed':
					credits = 'BlueBoyeet';
				case 'trojan-virus':
					credits = 'Tigression';
				case 'file-manipulation':
					credits = 'Rareblin';
				case 'atelophobia':
					credits = 'firey';
				case 'factory-reset':	
					credits = 'Tigression';
				case 'ron-b':
					credits = 'DeepFriedBolonese';
				case 'wasted-b':
					credits = 'coquers_';
				case 'ayo-b':
					credits = 'Tigression';
				case 'bloodshed-b':
					credits = 'Tigression';
				case 'trojan-virus-b':
					credits = 'Tigression';
				case 'file-manipulation-b':
					credits = 'Tigression';
				case 'atelophobia-b':
					credits = 'Tigression';
				case 'factory-reset-b':
					credits = 'Tigression';
				case 'holy-shit-dave-fnf':
					credits = 'DeepFriedBolonese';
				case 'slammed':
					credits = 'Tigression';
				case 'meme-machine':
					credits = 'Tigression';
				case 'frosting-over':
					credits = 'Tigression';
				case 'raw-meaty-meats':
					credits = 'Zesty';
				case 'assassination':
					credits = 'Zesty & Tigression';
				case 'steak':
					credits = 'Zesty';
				case 'pretty-wacky':
					credits = 'Tigression';
				case 'he-hates-me':
					credits = 'Lexicord';
				case 'typical-dissecration':
					credits = 'nobody yet';
				case 'trouble':
					credits = 'KyleGFX & kurtfan5468';
				case 'bijuu':
					credits = 'Tigression';
				case 'double-trouble':
					credits = 'yourlocalmusician';
				case 'bloodshed-two':
					credits = 'BlueBoyeet';
				case 'anti-piracy':
					credits = 'BlueBoyeet';
				case 'bloodbath':
					credits = 'BlueBoyeet';
				case 'withered':
					credits = 'ZeroDawn & Sz';
			}
			var rSongname = curSong;
			if (rSongname.toLowerCase().endsWith('-b'))
			{
				rSongname = rSongname.substr(0, rSongname.length-2);
				rSongname += " B-Sides";
			}
			var songNameC:FlxText = new FlxText(0, 0, 0, rSongname, 32);
			var songNameD:FlxText = new FlxText(0, 0, 0, credits, 32);
			songNameC.setFormat(Paths.font("w95.otf"), 52, FlxColor.YELLOW, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK); 
			songNameC.scrollFactor.set();
			songNameC.screenCenter(Y);
			songNameC.x = -songNameC.fieldWidth - 100;
			songNameC.y -= 175;
			songNameD.setFormat(Paths.font("w95.otf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK); 
			songNameD.scrollFactor.set();
			songNameD.screenCenter(Y);
			songNameD.x = -songNameC.fieldWidth - 100;
			songNameD.y -= 125;
			var black:FlxSprite = new FlxSprite(songNameC.x - 600, songNameC.y - 20).makeGraphic(600, Std.int(songNameC.height * 2.75), FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
			add(songNameC);
			add(songNameD);
			trace(songNameC.fieldWidth);
			FlxTween.tween(songNameC, {x: songNameC.fieldWidth - 20}, 1, {
				ease: FlxEase.backInOut,
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(songNameC, {x: -songNameC.fieldWidth - 100}, 1, {
							ease: FlxEase.backInOut,
							onComplete: function(twn:FlxTween)
							{
								songNameC.destroy();
							}
						});
					});
				}
			});
			FlxTween.tween(songNameD, {x: songNameD.fieldWidth - 20}, 1, {
				ease: FlxEase.backInOut,
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(songNameD, {x: -songNameD.fieldWidth - 100}, 1, {
							ease: FlxEase.backInOut,
							onComplete: function(twn:FlxTween)
							{
								songNameD.destroy();
							}
						});
					});
				}
			});
			FlxTween.tween(black, {x: 86 - 200}, 1, {
				ease: FlxEase.backInOut,
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTween.tween(black, {x: -songNameC.x - 600}, 1, {
							ease: FlxEase.backInOut,
							onComplete: function(twn:FlxTween)
							{
								black.destroy();
							}
						});
					});
				}
			});
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');
			camHUD.alpha = luaModchart.getVar('camHudAlpha','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		
		//scoreTxt.x = (originalX - (lengthInPx / 2)) + 550;
		scoreTxt.screenCenter(X);

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (SONG.song == 'Bloodshed')
			{
				#if desktop
				Sys.exit(0);
				#end
			}
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				var pov = 0;
				var mxx = 0;
				var myy = 0;
				var trojan = 0;
				if (dad.animation.curAnim.name.endsWith('UP'))
					myy = 30;
				if (dad.animation.curAnim.name.endsWith('DOWN'))
					myy = -30;
				if (dad.animation.curAnim.name.endsWith('LEFT'))
					mxx = -30;
				if (dad.animation.curAnim.name.endsWith('RIGHT'))
					mxx = 30;

				if (dad.curCharacter == 'hellron-pov')
					pov = 333;
				if (dad.curCharacter == 'ron-usb')
					trojan = 180;
				if ((FlxG.save.data.cameraenable) && (dad.curCharacter != 'bijuuron') && (dad.curCharacter != 'hellron-pov') && (SONG.stage != 'bambiFarm') && (PlayState.SONG.stage != 'daveHouse'))
					camFollow.setPosition(dad.getMidpoint().x + 160 + offsetX + mxx, dad.getMidpoint().y + 150 - myy - 250 + offsetY + trojan);
				else
					camFollow.setPosition(dad.getMidpoint().x + 120 + pov + offsetX, dad.getMidpoint().y - 60 + offsetY - trojan);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				if (FlxG.save.data.cameraenable)
					camFollow.setPosition(boyfriend.x + boyfriend.frameWidth/2 - 100 + offsetX, boyfriend.y + boyfriend.height - boyfriend.frameHeight/2 - 100 + offsetY);
				else
					camFollow.setPosition(boyfriend.x - 200 + offsetX, boyfriend.y + 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					// F
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			defaultCamZoom = 1.1;
			FlxG.camera.zoom = 1.1;
			setChrome(0.0);
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						if (daNote.noteType == 0)
						{
							switch (Math.abs(daNote.noteData))
								{
									case 2:
										dad.playAnim('singUP' + altAnim, true);
									case 3:
										dad.playAnim('singRIGHT' + altAnim, true);
									case 1:
										dad.playAnim('singDOWN' + altAnim, true);
									case 0:
										dad.playAnim('singLEFT' + altAnim, true);
								}
								
							if ((SONG.song.toLowerCase() == 'file-manipulation') && (((curStep >= 816) && (curStep <= 848)) || ((curStep >= 880) && (curStep <= 912))))
							{
								FlxG.camera.zoom += 0.0375;
								defaultCamZoom += 0.0375;
							}				
						}
						else
						{
							switch (Math.abs(daNote.noteData))
								{
									case 2:
										dad2.playAnim('singUP' + altAnim, true);
									case 3:
										dad2.playAnim('singRIGHT' + altAnim, true);
									case 1:
										dad2.playAnim('singDOWN' + altAnim, true);
									case 0:
										dad2.playAnim('singLEFT' + altAnim, true);
								}
						}
						//shakes the fuck out of your screen and hud -ekical
						//now it drains your health because fuck you -ekical
						if ((dad.curCharacter == 'hellron') || (dad.curCharacter == 'devilron'))
							{
								var multiplier:Float = 1;
								if (health >= 1)
									multiplier = 1;
								else
									multiplier = multiplier + ((1-health));
								FlxG.camera.shake(0.025 * multiplier, 0.1);
								camHUD.shake(0.0055 * multiplier, 0.15);
								if (health > 0.03)
									health -= 0.014;
								else
									health = 0.02;
							}
						if (dad.curCharacter == 'ron-usb' || dad.curCharacter == 'ateloron')
							{
								if (health > 0.03)
									health -= 0.014;
								else
									health = 0.02;
							}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate && PlayStateChangeables.useDownscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (loadRep && daNote.isSustainNote)
								{
									// im tired and lazy this sucks I know i'm dumb
									if (findByTime(daNote.strumTime) != null)
										totalNotesHit += 1;
									else
									{
										health -= 0.075;
										vocals.volume = 0;
										if ((theFunne) && (daNote.noteType == 0))
											noteMiss(daNote.noteData, daNote);
									}
								}
								else
								{
									health -= 0.075;
									vocals.volume = 0;
									if ((theFunne) && (daNote.noteType == 0))
										noteMiss(daNote.noteData, daNote);
								}
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
				{
					campaignScore += Math.round(songScore);
	
					storyPlaylist.remove(storyPlaylist[0]);
	
					if (storyPlaylist.length <= 0)
						{
							if (curSong == "Factory Reset")
							{
								FlxG.switchState(new EndingState());
							}else if (curSong.endsWith('-b'))
							{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
								FlxG.switchState(new BSIDEState());
							} else
							{
								FlxG.sound.playMusic(Paths.music('freakyMenu'));
								FlxG.switchState(new StoryMenuState());
							}
		
							transIn = FlxTransitionableState.defaultTransIn;
							transOut = FlxTransitionableState.defaultTransOut;
		
							FlxG.switchState(new StoryMenuState());
		
							// if ()
							StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
		
							if (SONG.validScore)
							{
								NGio.unlockMedal(60961);
								Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
							}
	
						#if windows
						if (luaModchart != null)
						{
							luaModchart.die();
							luaModchart = null;
						}
						#end
	
						// if ()
						StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
	
						if (SONG.validScore)
						{
							NGio.unlockMedal(60961);
							Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
						}
	
						FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
						FlxG.save.flush();
					}
				else
				{
					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (SONG.song.toLowerCase() == 'bloodshed') 
					{
						video.playMP4(Paths.video('bloodshed'), new PlayState(), false, false, false);
					} else {
						LoadingState.loadAndSwitchState(new PlayState());
					}
					
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;


				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
				{
					camHUD.alpha = 1;
					openSubState(new ResultsScreen());
				}
				else
					FlxG.switchState(new MasterPlayState());
			}
		}

		if (SONG.song.toLowerCase() == 'factory-reset-b' && misses == 0 && !PlayStateChangeables.botPlay)
		{
			Achievements.whatTheActualFuck = true;
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			if (daNote.noteType == 0)
			{
				switch(daRating)
				{
					case 'shit':
						score = -300;
						combo = 0;
						health -= 0.2;
						ss = false;
						shits++;
						uhoh = false;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit -= 1;
					case 'bad':
						daRating = 'bad';
						score = 0;
						health -= 0.06;
						ss = false;
						bads++;
						uhoh = false;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					case 'good':
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						uhoh = false;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					case 'sick':
						if (health < 2)
							health += 0.1;
						uhoh = false;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
				}
				
				if(daRating == 'sick')
				{
					spawnNoteSplashOnNote(daNote);
				}
			}
			else
			{
				// haha fuck you
				score = -300;
				combo = 0;
				misses++;
				health -= 0.25;
				ss = false;
				uhoh = true;
				shits++;
				if (FlxG.save.data.accuracyMod == 0)
					totalNotesHit -= 1;
					
				boyfriend.playAnim('singDOWNmiss', true);
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 

				var anas:Array<Ana> = [null,null,null,null];

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									{ // if a direction is hit that shouldn't be
										if (pressArray[shit] && !(directionList.contains(shit)))
											noteMiss(shit, null);
									}
							}
							for (coolNote in possibleNotes)
							{
								if (pressArray[coolNote.noteData])
								{
									if (mashViolations != 0)
										mashViolations--;
									scoreTxt.color = FlxColor.WHITE;
									var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
									anas[coolNote.noteData].hit = true;
									anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
									anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
									goodNoteHit(coolNote);
								}
							}
						}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
				notes.forEachAlive(function(daNote:Note)
				{
					if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
					!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
						PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								var n = findByTime(daNote.strumTime);
								trace(n);
								if(n != null)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					// WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{	
			if (daNote.noteType == 0)
			{
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
				misses++;

				if (daNote != null)
				{
					if (!loadRep)
					{
						saveNotes.push([
							daNote.strumTime,
							0,
							direction,
							166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
						]);
						saveJudge.push("miss");
					}
				}
				else if (!loadRep)
				{
					saveNotes.push([
						Conductor.songPosition,
						0,
						direction,
						166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}

				// var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
				// var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

				if (FlxG.save.data.accuracyMod == 1)
					totalNotesHit -= 1;

				songScore -= 10;

				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');

				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
				}

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
				#end

				updateAccuracy();
			}
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
					{
						health += 0.01;
						totalNotesHit += 1;
					}
					
			if (!uhoh)
			{
				switch (note.noteData)
				{
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 0:
						boyfriend.playAnim('singLEFT', true);
				}
				
				if ((SONG.song.toLowerCase() == 'file-manipulation') && (((curStep >= 816) && (curStep <= 848)) || ((curStep >= 880) && (curStep <= 912))))
				{
					FlxG.camera.zoom += 0.0375;
					defaultCamZoom += 0.0375;
				}	
			}
					
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		
	function spawnNoteSplashOnNote(note:Note) {
		if(note != null) {
			spawnNoteSplash(note.x, note.y, note.noteData);
		}
	}
	
	public function spawnNoteSplash(x:Float, y:Float, data:Int) {
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					// Stop
					
					//gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}
	
	function RonIngameTransform()
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		FlxG.sound.play(Paths.sound('bobSpooky'));
		new FlxTimer().start(1.7, function(tmr:FlxTimer)
		{
			add(black);
			FlxG.camera.fade(FlxColor.WHITE, 0.1, true);
		});

	}

	var danced:Bool = false;

	override function stepHit()
	{
		if (curSong == 'Bloodshed' || curSong == 'not-bloodshed') {
			healthBarBG.alpha = 0;
			healthBar.alpha = 0;
			iconP1.visible = true;
			iconP2.visible = true;
			iconP2.alpha = (2-(health)-0.25)/2+0.2;
			iconP1.alpha = (health-0.25)/2+0.2;
			switch (curStep) {
				case 0:
					PlayStateChangeables.useDownscroll = false;
					strumLine.y = 50;
				case 259:
					defaultCamZoom = 0.95;
				case 341:
					defaultCamZoom = 1.05;
				case 356:
					defaultCamZoom = 1.15;
				case 372:
					defaultCamZoom = 1.25;
				case 389:
					defaultCamZoom = 0.85;
				case 518:
					defaultCamZoom = 0.85;
					satan.angle = 0;
					FlxTween.tween(camHUD, {angle: 20}, 1, {ease: FlxEase.quadInOut, type: BACKWARD});
				case 776:
					defaultCamZoom = 0.9;
					FlxTween.tween(firebg, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
				case 792:
					defaultCamZoom = 0.95;
				case 808:
					defaultCamZoom = 1;
				case 824:
					defaultCamZoom = 1.05;
				case 840:
					defaultCamZoom = 1.1;
				case 856:
					defaultCamZoom = 1.15;
				case 872:
					defaultCamZoom = 1.2;
				case 888:
					defaultCamZoom = 1.25;
				case 904:
					defaultCamZoom = 0.95;
				case 920:
					defaultCamZoom = 1.05;
				case 936:
					defaultCamZoom = 1.15;
				case 952:
					defaultCamZoom = 1.25;
				case 968:
					defaultCamZoom = 0.95;
				case 984:
					defaultCamZoom = 1.05;
				case 1000:
					defaultCamZoom = 1.15;
				case 1016:
					defaultCamZoom = 1.25;
			}
			if ((curStep >= 259) && (curStep <= 518))
			{
				if (fx.alpha < 0.6)
					fx.alpha += 0.05;			
				if (curStep == 260)
				{
					FlxTween.angle(satan, 0, 359.99, 1.5, { 
						ease: FlxEase.quadIn, 
						onComplete: function(twn:FlxTween) 
						{
							FlxTween.angle(satan, 0, 359.99, 0.75, { type: FlxTween.LOOPING } );
						}} 
					);
				}
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.001, 0.15);
			}
			else if ((curStep >= 776) && (curStep <= 1070))
			{
				if (fx.alpha > 0)
					fx.alpha -= 0.05;
				if (curStep == 777)
				{
					FlxTween.angle(satan, 0, 359.99, 0.75, { 
						ease: FlxEase.quadIn, 
						onComplete: function(twn:FlxTween) 
						{
							FlxTween.angle(satan, 0, 359.99, 0.35, { type: FlxTween.LOOPING } );
						}} 
					);
				}
				FlxG.camera.shake(0.015, 0.1);
				camHUD.shake(0.0015, 0.15);
			}
			else
			{
				if ((curStep == 1071) || (curStep == 519))
					FlxTween.cancelTweensOf(satan);
				if (satan.angle != 0)
					FlxTween.angle(satan, satan.angle, 359.99, 0.5, {ease: FlxEase.quadIn});
				if (fx.alpha > 0.3)
					fx.alpha -= 0.05;
			}
			Estatic.alpha = (((2-health)/3)+0.2);
		}
		
		if (curSong == 'Bloodshed-b') {
			healthBarBG.alpha = 0;
			healthBar.alpha = 0;
			iconP1.visible = true;
			iconP2.visible = true;
			iconP2.alpha = (2-(health)-0.25)/2+0.2;
			iconP1.alpha = (health-0.25)/2+0.2;
			switch (curStep) {
				case 0:
					blackeffect.alpha = 0;
				case 64:
					FlxTween.tween(blackeffect, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
					fx.alpha = 0.6;
				case 128:
					FlxTween.tween(fx, {alpha: 0.4}, 2, {ease: FlxEase.quadInOut});
				case 256:
					FlxTween.tween(blackeffect, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(fx, {alpha: 0.8}, 2, {ease: FlxEase.quadInOut});
				case 320:
					FlxTween.tween(blackeffect, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(fx, {alpha: 0.6}, 2, {ease: FlxEase.quadInOut});
				case 512:
					FlxTween.tween(firebg, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
				case 768:
					FlxTween.tween(blackeffect, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(fx, {alpha: 0.8}, 2, {ease: FlxEase.quadInOut});
				case 900:
					FlxTween.tween(firebg, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
				case 1024:
					FlxTween.tween(blackeffect, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(fx, {alpha: 0.6}, 2, {ease: FlxEase.quadInOut});
				case 1152:
					FlxTween.tween(fx, {alpha: 0.4}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(firebg, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
				case 1280:
					FlxTween.tween(blackeffect, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
					FlxTween.tween(fx, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
			}
			if (curStep % 16 == 0)
			{
				if (fx.alpha > 0.6)
					defaultCamZoom -= 0.08;
				else
					defaultCamZoom += 0.08;
					
				if (curStep % 64 == 0)
					defaultCamZoom = 0.85;
			}
			if ((curStep >= 768) && (curStep < 1024))
			{
				dad.playAnim('crazy', false);
			}
			if (((curStep >= 512) && (curStep <= 1024)))
			{
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.001, 0.15);
				if (health > 0.2)
					health -= 0.05;
			}
			if ((curStep >= 1152) && (curStep <= 1536))
			{
				FlxG.camera.shake(0.01, 0.1);
				camHUD.shake(0.001, 0.15);
				if (health > 0.2)
					health -= 0.05;
			}
		}
		
		if (curSong == 'Bloodshed-old') {
			healthBarBG.alpha = 0;
			healthBar.alpha = 0;
			iconP1.visible = true;
			iconP2.visible = true;
			iconP2.alpha = (2-(health)-0.25)/2+0.2;
			iconP1.alpha = (health-0.25)/2+0.2;
			firebg.alpha = 1;
			satan.angle += 5;
			FlxG.camera.shake(0.01, 0.1);
			camHUD.shake(0.001, 0.15);
			Estatic.alpha = (2-health)/2;
		}
		
		if (curSong == 'BLOODSHED-TWO') {
			if (curStep >= 271)
			{
				healthBarBG.alpha = 0;
				healthBar.alpha = 0;
				iconP1.visible = true;
				iconP2.visible = true;
				iconP2.alpha = (2-(health)-0.25)/2+0.2;
				iconP1.alpha = (health-0.25)/2+0.2;
				Estatic.alpha = (2-health)/2;
				Estatic2.alpha = 0.3;
			}
			if (curStep == 263)
			{
				iconP1.visible = false;
				iconP2.visible = false;
				healthBar.alpha = 0;
				healthBarBG.alpha = 0;
				var xx = dad.x;
				var yy = dad.y;
				dad.alpha = 0;
				remove(dad);
				dad = new Character(xx, yy, 'devilron');
				add(dad);
				iconP2.animation.play('devilron');
				var blac:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				blac.scrollFactor.set();
				add(blac);
				defaultCamZoom = 0.9;
				FlxTween.tween(blac, {alpha: 0}, 1, {ease: FlxEase.quadIn});
				blackeffect.alpha = 1;
			}
			if ((curStep == 784) || (curStep == 2367))
			{
				firebg.alpha = 1;
				FlxG.camera.setFilters([ShadersHandler.GrayScale]);
				camHUD.setFilters([ShadersHandler.GrayScale]);
				Estatic2.alpha = 0;
				var xx = dad.x;
				var yy = dad.y;
				dad.alpha = 0;
				remove(dad);
				dad = new Character(xx, yy, 'hellron');
				add(dad);				
				blackeffect.alpha = 0;
				var blac:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				blac.scrollFactor.set();
				add(blac);
				defaultCamZoom = 1.05;
				FlxTween.tween(blac, {alpha: 0}, 1, {ease: FlxEase.quadIn});
			}
			if ((curStep == 911) || (curStep == 2623))
			{
				firebg.alpha = 0;
				FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
				camHUD.setFilters([ShadersHandler.chromaticAberration]);
				Estatic2.alpha = 0.3;
				var xx = dad.x;
				var yy = dad.y;
				dad.alpha = 0;
				remove(dad);
				dad = new Character(xx, yy, 'devilron');
				add(dad);				
				blackeffect.alpha = 1;
				var blac:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				blac.scrollFactor.set();
				add(blac);
				defaultCamZoom = 0.9;
				FlxTween.tween(blac, {alpha: 0}, 1, {ease: FlxEase.quadIn});
			}
		}

		if ((curSong == 'Atelophobia') || (curSong == 'Factory-Reset') || (curSong == 'Bloodshed') || (curSong == 'Bloodshed-b') || (curSong == 'Bloodshed-old') || (curSong == 'BLOODSHED-TWO') || (curSong == 'Factory-Reset-b') || (curSong == 'Atelophobia-b') || (curSong == 'Trojan-Virus') || (curSong == 'Trojan-Virus-b') || (curSong == 'File-Manipulation') || (curSong == 'File Manipulation-b') || (curSong == 'not-bloodshed')) {
			var chromeOffset:Float = (((2 - health/2)/2+0.5));
			chromeOffset /= 350;
			if (chromeOffset <= 0)
				setChrome(0.0);
			else
			{
				if (FlxG.save.data.rgbenable)
				{
					if (curSong != 'File-Manipulation')
						setChrome(chromeOffset*FlxG.save.data.rgbintense);
					else
					{
						var sinus = 1;
						if (curStep >= 538)
							sinus = 2 * Std.int(Math.sin((curStep - 538) / 3));
						setChrome(chromeOffset*FlxG.save.data.rgbintense*sinus);
					}
				}
				else
					setChrome(0.0);
			}
		}
		else
			setChrome(0.0);
		
		if ((curSong == 'wasted') || (curSong == 'Wasted-B'))
		{
			if (curStep == 828)
			{
				camFollow.x = dad.getGraphicMidpoint().x + 300;
				camFollow.y = dad.getGraphicMidpoint().y;
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
				var xx = dad.x;
				var yy = dad.y;
				remove(dad);
				if (curSong == 'wasted')
					dad = new Character(xx, yy, 'ron-mad');
				else
				{	
					wastedbg.alpha = 1;
					dad = new Character(xx, yy, 'ronmad-b');
				}
				add(dad);
			}
			if ((curStep >= 828) && (curSong == 'wasted-b'))
			{
				FlxG.camera.shake(0.025, 0.1);
				camHUD.shake(0.0055, 0.15);
			}
		}
		
		if (curSong == 'Holy-Shit-Dave-Fnf')
		{
			switch (curStep) {
				case 352:
					defaultCamZoom = 1;
				case 368:
					defaultCamZoom = 1.2;
				case 384:
					FlxG.camera.flash(FlxColor.WHITE, 0.2);
					dad.playAnim('um', false);
				case 400:
					defaultCamZoom = 1.5;
				case 448:
					defaultCamZoom = 0.9;
					dad.playAnim('idle', false);
			}
			
			if (curStep == 400)
				dad.playAnim('err', false);
		}
		
		if (curSong == 'Trojan-Virus')
		{
			switch (curStep) {
				case 384:
					FlxTween.tween(cloudsa, {alpha: 0}, 1, {ease: FlxEase.quadIn});
					FlxTween.tween(witheredRa, {alpha: 0}, 1, {ease: FlxEase.quadIn});
					FlxTween.tween(bgLol, {alpha: 0}, 1, {ease: FlxEase.quadIn});
					camHUD.shake(0.002);
					defaultCamZoom += 0.2;
				case 640:
					defaultCamZoom -= 0.2;
				case 770:
					camHUD.visible = false;
				case 768:
					dad.visible = false;
					ronAnimation.x = dad.x-360;
					ronAnimation.y = dad.y-430;
					ronAnimation.visible = true;
					ronAnimation.animation.play('idle', true);
					defaultCamZoom = 1;
					FlxTween.tween(FlxG.camera, {zoom: 1}, 0.4, {ease: FlxEase.expoOut,});
				case 870:
					camHUD.visible = true;
			}
			if ((curStep >= 384) && (curStep <= 640))
				FlxG.camera.shake(0.00625, 0.1);
			
			camHUD.shake(0.00125, 0.15);
		}
		if (curSong == 'bijuu')
			{
				switch (curStep)
				{
					case 105:
						defaultCamZoom = 0.8;
						
				}
			}
		if (curSong == 'File-Manipulation')
		{
			switch (curStep) {
				case 460:
					dad.visible = false;
					ronAnimation.x = dad.x-140;
					ronAnimation.y = dad.y+55;
					ronAnimation.visible = true;
					ronAnimation.animation.play('idle', true);
				case 507:
					camHUD.visible = false;
					trace('work');
				case 513:
					FlxTween.tween(FlxG.camera, {zoom: 2.2}, 4);
					trace("workk");
				case 532:
					FlxTween.cancelTweensOf(FlxG.camera);
				case 535:
					FlxTween.tween(FlxG.camera, {zoom: 0.8}, 2);
					trace("also work");
				case 545:
					FlxTween.cancelTweensOf(FlxG.camera);
				case 544:
					camHUD.visible = true;
					trace('work');
				case 560:
					defaultCamZoom = 1;
				case 563:
					defaultCamZoom = 0.88;
				case 538:
					PlayStateChangeables.scrollSpeed = 3.5;
					var xx = dad.x-20;
					var yy = dad.y+60;
					remove(dad);
					dad = new Character(xx, yy, 'ateloron');
					add(dad);
					iconP2.animation.play('ateloron');
					ronAnimation.visible = false;
				case 544:
					camHUD.visible = true;
				case 556:
					defaultCamZoom = 0.2;
					FlxTween.tween(FlxG.camera, {angle: 180}, 0.1, {ease: FlxEase.expoOut,});
				case 562:
					defaultCamZoom = 0.9;
					FlxG.camera.angle = 0;
				case 912:
					defaultCamZoom = 0.9;
				case 1046:
					FlxTween.tween(camGame, {alpha: 0}, 0.25, {ease: FlxEase.expoOut,});
				case 1056:
					camGame.alpha = 1;
					FlxG.camera.setFilters([ShadersHandler.MosaicShader]);
					camHUD.setFilters([ShadersHandler.MosaicShader]);
				case 1131:
					FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
					camHUD.setFilters([ShadersHandler.chromaticAberration]);
			}
	
			if ((curStep >= 538) && (Estatic2.alpha < 0.5))
				Estatic2.alpha += 0.02;
		}
		if (curSong.toLowerCase() == 'trojan-virus-b')
			{
				switch(curStep)
				{
					case 288:
						FlxG.camera.shake(0.11, 0.11);
				}
			}
	
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 0) {
			iconP1.scale.set(1.1,0.9);
			iconP2.scale.set(1.1,0.9);
	
			FlxTween.tween(iconP1,{'scale.x':1,'scale.y':1},Conductor.crochet / 1000 * 1,{ease: FlxEase.backOut});
			FlxTween.tween(iconP2,{'scale.x':1,'scale.y':1},Conductor.crochet / 1000 * 1,{ease: FlxEase.backOut});

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}
		
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}
		
		if (curSong.toLowerCase() == 'trouble' && curBeat == 504 )
		{
			RonIngameTransform();
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf' && ((dad.curCharacter == 'hellron-2') && (!dad.animation.curAnim.name.startsWith("crazy"))))
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
		}
	
		// this code is terrible
		// iconP1.scale.set(1.5, 0.5);
		// iconP2.scale.set(1.5, 0.5);
		// FlxTween.tween(iconP1, {"scale.x": 1}, 1.5, {ease: FlxEase.quadInOut});
		// FlxTween.tween(iconP1, {"scale.y": 1}, 0.5, {ease: FlxEase.quadInOut});
		// FlxTween.tween(iconP2, {"scale.x": 1}, 1.5, {ease: FlxEase.quadInOut});
		// FlxTween.tween(iconP2, {"scale.y": 1}, 0.5, {ease: FlxEase.quadInOut});
		
		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}

		if (curBeat == 0 && curSong == 'Trojan-Virus')
			{
				var bruh:FlxSprite = new FlxSprite();
				bruh.loadGraphic(Paths.image('ron/longbob'));
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

		if (curBeat == 8 && curSong == 'Trojan-Virus')
			{
				var bruh:FlxSprite = new FlxSprite();
				bruh.loadGraphic(Paths.image('ron/longbob'));
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

		if (curBeat == 2 && curSong == 'Ron')
			{
				var bruh:FlxSprite = new FlxSprite();
				bruh.loadGraphic(Paths.image('ron/longbob'));
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

		if (curSong == 'Ron')
			{
				if (curBeat == 7)
				{
					FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
					dad.playAnim('cheer', true);
				}
				else if (curBeat == 119)
				{
					FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
					dad.playAnim('cheer', true);
				}
				else if (curBeat == 215)
				{
					FlxG.camera.follow(dad, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
					FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
					dad.playAnim('cheer', true);
				}
				else
				{
					FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
				}
			}
		if (curSong == 'ron-b')
		{
			if (curBeat == 7)
			{
				dad.playAnim('cheer', true);
			} else if (curBeat == 19)
			{
				dad.playAnim('cheer', true);
			} else if (curBeat == 119)
			{
				dad.playAnim('cheer', true);
			} else if (curBeat == 215)
			{
				dad.playAnim('cheer', true);
			}
		}
	}
	var curLight:Int = 0;
}
