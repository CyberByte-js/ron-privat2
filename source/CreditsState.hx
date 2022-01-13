package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;

class CreditsState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var cstate:Int = 1;
	var bg:FlxBackdrop;
	var arrows:FlxSprite;
	var credits:FlxSprite;
	var thing:FlxSprite;
	
	override function create()
	{
		super.create();
		bg = new FlxBackdrop(Paths.image('creditsScreen/bg'), 0.2, 0.2, true, true);
		bg.scale.set(0.5,0.5);
		add(bg);
		thing = new FlxSprite().loadGraphic(Paths.image('creditsScreen/whiteThing'));
		thing.scale.set(0.5,0.5);
		thing.screenCenter();
		thing.scrollFactor.set();
		add(thing);
		arrows = new FlxSprite().loadGraphic(Paths.image('creditsScreen/arrows'));
		arrows.scale.set(0.5,0.5);
		arrows.screenCenter();
		arrows.scrollFactor.set();
		add(arrows);
		FlxTween.tween(arrows, {y: arrows.y + 50}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(thing, {y: thing.y + 20}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});
		credits = new FlxSprite().loadGraphic(Paths.image('creditsScreen/credits1'));
		credits.scale.set(0.5,0.5);
		credits.screenCenter();
		credits.scrollFactor.set();
		add(credits);
	}
	
	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		cstate += change;
		
		if (cstate < 1)
			cstate = 5;
		if (cstate > 5)
			cstate = 1;
			
		remove(credits);
		credits = new FlxSprite().loadGraphic(Paths.image('creditsScreen/credits'+cstate));
		credits.scale.set(0.5,0.5);
		credits.screenCenter();
		credits.scrollFactor.set();
		add(credits);
	}

	override function update(elapsed:Float)
	{
		bg.x += 2;
		bg.y += 1;
		var rightP = FlxG.keys.justPressed.RIGHT;
		var leftP = FlxG.keys.justPressed.LEFT;
		super.update(elapsed);
		if (rightP)
			changeSelection(1);
		if (leftP)
			changeSelection(-1);
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		credits.y = thing.y;
	}
}
