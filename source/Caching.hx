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

using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var kadeLogo:FlxSprite;
	var loadingBar:FlxBar;

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        text = new FlxText(FlxG.width / 2, FlxG.height / 4,0,"loading...");
		text.setFormat(Paths.font("w95.otf"), 34, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
		text.screenCenter(XY);
		
        sys.thread.Thread.create(() -> {
            cache();
        });
		
		loadingBar = new FlxBar(text.x, text.y - 250, LEFT_TO_RIGHT, 400, 30, this, 'done', 0, 41, true);
		loadingBar.screenCenter(X);
		loadingBar.scrollFactor.set();
		loadingBar.createFilledBar(FlxColor.BLACK, 0xFFFFFFFF);
		
		var bgBar:FlxSprite = new FlxSprite().makeGraphic(408, 38, FlxColor.BLACK);
		bgBar.x = loadingBar.x - 4;
		bgBar.y = loadingBar.y - 4;
		bgBar.updateHitbox();
		bgBar.antialiasing = true;

        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('loading'));
		kadeLogo.screenCenter();
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.5));
        text.y -= kadeLogo.height / 2 - 125;
        text.x -= 170;
        kadeLogo.alpha = 0;

        add(kadeLogo);
		add(bgBar);
		add(loadingBar);
        add(text);

        trace('starting caching..');
        
        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            kadeLogo.alpha = alpha;
            text.text = done + "/" + toBeDone;
			text.screenCenter(XY);
			text.y = FlxG.height / 8;
        }

        super.update(elapsed);
    }


    function cache()
    {

        var characters = [];
		var bgs = [];

        trace("caching characters...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            characters.push(i);
        }
		
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/ron/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            characters.push(i);
        }
		
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            characters.push(i);
        }
		
		trace("caching bgs...");
		
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/updateron/bg")))
		{
            if (!i.endsWith(".png"))
                continue;
            bgs.push(i);
		}
		
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/ron/bg")))
		{
            if (!i.endsWith(".png"))
                continue;
            bgs.push(i);
		}

        toBeDone = Lambda.count(characters) + Lambda.count(bgs);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in characters)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }
		
        for (i in bgs)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("updateron/bg/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }
	
        trace("Finished caching...");
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