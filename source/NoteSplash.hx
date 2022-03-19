package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var lastNoteType:Int = -1;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'NOTE_splashes_explode';

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		var skin:String = 'NOTE_splashes_explode';
		loadAnims(skin);
		offset.set(80, 40);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + 1, true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			animation.addByPrefix("note1-" + 1, "note splash blue " + 1, 24, false);
			animation.addByPrefix("note2-" + 1, "note splash green " + 1, 24, false);
			animation.addByPrefix("note0-" + 1, "note splash purple " + 1, 24, false);
			animation.addByPrefix("note3-" + 1, "note splash red " + 1, 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}