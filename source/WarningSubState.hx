package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class WarningSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var secstate:Int = 0;
	var popup:FlxSprite;
	
	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('warning/warnBg'));
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);
		popup = new FlxSprite();
		popup.frames = Paths.getSparrowAtlas("warning/official");
		popup.animation.addByPrefix('popup1 instance 1', 'popup1 instance 1', 24, false);
		popup.scrollFactor.set();
		popup.updateHitbox();
		popup.screenCenter();
		add(popup);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
	}
}
