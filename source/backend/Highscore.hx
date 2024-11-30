package backend;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
    public static var songTimes:Map<String, String> = new Map<String, String>();
    public static var songNoteMs:Map<String, Array<Float>> = new Map<String, Array<Float>>();
    public static var songNoteTime:Map<String, Array<Float>> = new Map<String, Array<Float>>();
    
	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setTime(daSong, 'N/A');
		setRating(daSong, 0);
		setMsGroup(daSong, []);
		setTimeGroup(daSong, []);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, diff:Int = 0, rating:Float = -1, msGroup:Array<Float>, timeGroup:Array<Float>):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				setTime(daSong, Date.now().toString());
				if(rating >= 0) setRating(daSong, rating);
				setMsGroup(daSong, msGroup);
				setTimeGroup(daSong, timeGroup);
			}
		}
		else {
			setScore(daSong, score);
			setTime(daSong, Date.now().toString());
			if(rating >= 0) setRating(daSong, rating);
			setMsGroup(daSong, msGroup);
			setTimeGroup(daSong, timeGroup);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
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
	
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}
	
	static function setTime(song:String, time:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songTimes.set(song, time);
		FlxG.save.data.songTimes = songTimes;
		FlxG.save.flush();
	}
	
	static function setMsGroup(song:String, group:Array<Float>):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songNoteMs.set(song, group);
		FlxG.save.data.songNoteMs = songNoteMs;
		FlxG.save.flush();
	}
	
	static function setTimeGroup(song:String, group:Array<Float>):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songNoteTime.set(song, group);
		FlxG.save.data.songNoteTime = songNoteTime;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}
	
	public static function getTime(song:String, diff:Int):String
	{
		var daSong:String = formatSong(song, diff);
		if (!songTimes.exists(daSong)){
			setTime(daSong, 'N/A');			
        }
		return songTimes.get(daSong);
	}
	
	public static function getMsGroup(song:String, diff:Int):Array<Float>
	{
		var daSong:String = formatSong(song, diff);
		if (!songNoteMs.exists(daSong)){
			setMsGroup(daSong, []);			
        }
		return songNoteMs.get(daSong);				
	}
	
	public static function getTimeGroup(song:String, diff:Int):Array<Float>
	{
		var daSong:String = formatSong(song, diff);
		if (!songNoteTime.exists(daSong)){
			setTimeGroup(daSong, []);			
        }
		return songNoteTime.get(daSong);				
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songTimes != null)
		{
			songTimes = FlxG.save.data.songTimes;
		}
		if (FlxG.save.data.songNoteMs != null)
		{
			songNoteMs = FlxG.save.data.songNoteMs;
		}
		if (FlxG.save.data.songNoteTime != null)
		{
			songNoteTime = FlxG.save.data.songNoteTime;
		}
	}
}