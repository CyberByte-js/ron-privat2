package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import openfl.display.BitmapData;
import openfl.utils.Assets;

using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
	var text2:FlxText;
    var kadeLogo:FlxSprite;
	var loadingBar:FlxBar;

	public static var bitmapData:Map<String,FlxGraphic>;
	var characters = [];
	var bgs = [];
	var portrait = [];
	var maincharacters = [];

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);
		bitmapData = new Map<String,FlxGraphic>();

        text = new FlxText(FlxG.width / 2, FlxG.height / 4,0,"loading...");
		text.setFormat(Paths.font("w95.otf"), 34, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
		text.screenCenter(XY);
		
        text2 = new FlxText(FlxG.width / 2, FlxG.height - FlxG.height / 4,0,"Loading...");
		text2.setFormat(Paths.font("w95.otf"), 34, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        text2.size = 34;
        text2.alignment = FlxTextAlign.CENTER;
		text2.screenCenter(XY);
		
		loadingBar = new FlxBar(text.x, text.y - 200, LEFT_TO_RIGHT, 400, 30, this, 'done', 0, 70, true);
		loadingBar.screenCenter(X);
		loadingBar.scrollFactor.set();
		loadingBar.createFilledBar(FlxColor.BLACK, 0xFFFFFFFF);
		
		var bgBar:FlxSprite = new FlxSprite().makeGraphic(408, 38, FlxColor.BLACK);
		bgBar.x = loadingBar.x - 4;
		bgBar.y = loadingBar.y - 4;
		bgBar.updateHitbox();
		bgBar.antialiasing = true;

		var bgLoading = Paths.image('loading');
		if (FlxG.random.bool(10))
			bgLoading = Paths.image('loadingold');
		// THIS LOOKS TERRIBLE
		if (FlxG.random.bool(1000))
			bgLoading = Paths.image('loadingolder');
        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('loading'));
		kadeLogo.screenCenter();
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.5));
        text.y -= kadeLogo.height / 2 - 65;
        text.x -= 170;
		text2.x -= 85;
		text2.y += 300;
        kadeLogo.alpha = 0;
		
		var gfDance:FlxSprite = new FlxSprite();
		gfDance.frames = Paths.getSparrowAtlas('loadingRun');
		gfDance.animation.addByPrefix('idle', "run", 12, true);
		gfDance.antialiasing = true;
		gfDance.screenCenter(XY);
		gfDance.animation.play('idle');
		gfDance.alpha = 1;
		gfDance.scale.set(0.3,0.3);
		gfDance.y -= 265;

        add(kadeLogo);
		add(bgBar);
		add(loadingBar);
        add(text);
		add(text2);
		add(gfDance);
		
		#if cpp
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			characters.push(i);
			trace(i);
		}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/bg")))
		{
			if (!i.endsWith(".png"))
				continue;
			bgs.push(i);
			trace(i);
		}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/portraits")))
		{
			if (!i.endsWith(".png"))
				continue;
			portrait.push(i);
			trace(i);
		}		
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			maincharacters.push(i);
			trace(i);
		}	
		#end

		sys.thread.Thread.create(() -> {
			cache();
		});

        trace('starting caching..');
        
        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {
        super.update(elapsed);
    }

	function actuallyCache(help:String, path:String)
		{
			var replaced = help.replace(".png","");
			var data:BitmapData = BitmapData.fromFile(path + help);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
            trace("cached " + replaced);
            done++;
			text2.text = "Loading.. (" + done + "/" + toBeDone + ")";
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            kadeLogo.alpha = alpha;
            text.text = done + "/" + toBeDone;
			text.screenCenter(XY);
			text.y = FlxG.height / 8 + 52;
		}

    function cache()
    {
        toBeDone = Lambda.count(characters) + Lambda.count(maincharacters) + Lambda.count(bgs) + Lambda.count(portrait);

        trace("LOADING: " + toBeDone + " OBJECTS.");
		
        for (i in characters)
			actuallyCache(i,"assets/shared/images/updateron/characters/");
        for (i in maincharacters)
			actuallyCache(i,"assets/shared/images/characters");
        for (i in bgs)
			actuallyCache(i,"assets/shared/images/updateron/bg");
        for (i in portrait)
			actuallyCache(i,"assets/shared/images/updateron/portraits");
		
        trace("Finished caching...");
		text.text = toBeDone + "/" + toBeDone;
		text2.text = "DONE! (in a cool way)";
		FlxG.sound.play(Paths.sound('cool'));
		FlxTween.tween(kadeLogo, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut});
		FlxTween.tween(FlxG.camera, {zoom: 3, angle: 20}, 2.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxG.switchState(new TitleState());
			}
		});
    }
}