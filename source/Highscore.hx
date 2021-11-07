package;

import flixel.FlxG;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
import openfl.Lib;
using StringTools;
class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songCombos:Map<String, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songCombos:Map<String, String> = new Map<String, String>();
	#end

	public static var miscData:Map<String, Bool> = new Map();
	public static var visualEffects:Map<String, String> = new Map();
	public static var keyb:Map<Int, String> = new Map();
	
	public static function toggleEffect(effect:Int):Void
	{
	
	var effects:Array<String> = getEffectKeys();
	var myEffects:Array<String> = getEffects();
	var myEffects2:Array<String> = [];
	var myEffects3:Array<String> = [];
	var myEffects4:Array<String> = [];
	
	for (eff in myEffects)
	{
	if (!myEffects2.contains(eff))
	{
	myEffects2.push(eff);
	}
	}
	
	for (eff in effects)
	{
	if (!myEffects2.contains(eff))
	{
	myEffects3.push("NULLIFIED_DATA_IGNOREIT");
	} else {
	myEffects3.push(eff);
	}
	}
	
	if (effect <= effects.length)
	{
	
	if (myEffects3[effect] == "NULLIFIED_DATA_IGNOREIT")
	{
	myEffects3[effect] = effects[effect];
	} else {
	myEffects3[effect] = "NULLIFIED_DATA_IGNOREIT";
	}
	
	for (eff in myEffects3)
	{
	if (eff != "NULLIFIED_DATA_IGNOREIT")
	{
	myEffects4.push(eff);
	}
	}
	
	setEffects(myEffects4);
	
	}
	
	}
	
	public static function getEffects():Array<String>
	{
	if (!visualEffects.exists('Effects'))
		setEffects([]);

	return parseEffects(visualEffects.get('Effects'));
	}
	
	public static function parseEffects(toParse:String):Array<String>
	{
	return haxe.Json.parse(haxe.crypto.Base64.decode(toParse).toString());
	}
	
	public static function setEffects(effects:Array<String>):Void
	{
	visualEffects.set("Effects", haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(haxe.Json.stringify(effects))).toString());
	FlxG.save.data.Effects = visualEffects;
	FlxG.save.flush();
	}
	
	public static function getEffectKeys():Array<String>
	{
	var theKeys:Array<String> = [];
	for (key in getEffectList().keys())
	{
	theKeys.push(key);
	}
	return theKeys;
	}
	
	public static function getEffectList():Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>
	{
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [];
		return filterMap;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		#if !switch
		NGio.postScore(score, song);
		#end

		if(!FlxG.save.data.botplay)
		{
			if (songScores.exists(daSong))
			{
				if (songScores.get(daSong) < score)
					setScore(daSong, score);
			}
			else
				setScore(daSong, score);
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	public static function saveCombo(song:String, combo:String, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		var finalCombo:String = combo.split(')')[0].replace('(', '');

		if(!FlxG.save.data.botplay)
		{
			if (songCombos.exists(daSong))
			{
				if (getComboInt(songCombos.get(daSong)) < getComboInt(finalCombo))
					setCombo(daSong, finalCombo);
			}
			else
				setCombo(daSong, finalCombo);
		}
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end

		if(!FlxG.save.data.botplay)
		{
			var daWeek:String = formatSong('week' + week, diff);

			if (songScores.exists(daWeek))
			{
				if (songScores.get(daWeek) < score)
					setScore(daWeek, score);
			}
			else
				setScore(daWeek, score);
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setCombo(song:String, combo:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songCombos.set(song, combo);
		FlxG.save.data.songCombos = songCombos;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';
		else if (diff == 3)
			daSong += '-cool';

		return daSong;
	}

	static function getComboInt(combo:String):Int
	{
		switch(combo)
		{
			case 'SDCB':
				return 1;
			case 'FC':
				return 2;
			case 'GFC':
				return 3;
			case 'MFC':
				return 4;
			default:
				return 0;
		}
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getCombo(song:String, diff:Int):String
	{
		if (!songCombos.exists(formatSong(song, diff)))
			setCombo(formatSong(song, diff), '');

		return songCombos.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songCombos != null)
		{
			songCombos = FlxG.save.data.songCombos;
		}
	}
}
