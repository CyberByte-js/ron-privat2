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
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF007D7D);
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);
		popup = new FlxSprite();
		popup.frames = Paths.getSparrowAtlas("official");
		popup.animation.addByPrefix('popup1 instance 1', 'popup1 instance 1', 24, false);
		popup.scrollFactor.set();
		popup.updateHitbox();
		popup.screenCenter();
		add(popup);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			switch (secstate)
			{
				case 0:
					popup.animation.play('popup1 instance 1');
					secstate = 1;
				case 1:
					popup.frames = Paths.getSparrowAtlas("warning");
					popup.animation.addByPrefix('popup2 instance 1', 'popup2 instance 1', 24, false);
					popup.scrollFactor.set();
					popup.updateHitbox();
					popup.screenCenter();
					popup.animation.play('popup2 instance 1');
					secstate = 2;
				case 2:
					popup.frames = Paths.getSparrowAtlas("other");
					popup.animation.addByPrefix('popup3 instance 1', 'popup3 instance 1', 24, false);
					popup.scrollFactor.set();
					popup.updateHitbox();
					popup.screenCenter();
					popup.animation.play('popup3 instance 1');
					secstate = 3;
					var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFFFFFFF);
					black.screenCenter();
					black.scrollFactor.set();
					black.alpha = 0;
					add(black);
					FlxTween.tween(black, {alpha: 1}, 1, {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween) 
						{
							FlxG.switchState(new MainMenuState());
						}
					});
			}
		}
		super.update(elapsed);
	}
}
