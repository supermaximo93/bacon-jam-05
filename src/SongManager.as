package  
{
	/**
	 * ...
	 * @author Max Foster
	 */
	
	import flash.media.Sound;
	import org.flixel.*;
	 
	public class SongManager 
	{
		[Embed(source="../assets/music/test.mp3")] private var testMusic:Class;
		[Embed(source="../assets/sounds/kick.mp3")] private var kickSound:Class;
		
		private const BEAT_TIME_TOLERANCE:Number = 0.2;
		
		private var _bpm:int;
		private var _timePerBeat:Number;
		private var _time:Number;
		private var _beatAlreadyScored:Boolean;
		
		private var _beats:Array = [
			1, 1, 1, 0.5, 0.5
		];
		private var _beatIndex:int;
		private var _nextBeatTime:Number;
		
		public function SongManager(bpm:int) 
		{
			_bpm = bpm;
			var beatsPerSecond:Number = bpm / 60.0;
			_timePerBeat = 1.0 / beatsPerSecond;
			_time = 0.0;
			_beatIndex = -1;
			_nextBeatTime = _timePerBeat;
			_beatAlreadyScored = false;
		}
		
		public function update():void
		{
			_time += FlxG.elapsed;
			if (_time >= _nextBeatTime)
			{
				//if (beatIndex < 0)
				//	FlxG.playMusic(testMusic);
				
				_time -= _nextBeatTime;
				if (++_beatIndex >= _beats.length)
					_beatIndex = 0;
				_nextBeatTime = _timePerBeat * _beats[_beatIndex];
				
				FlxG.play(kickSound);
			}
			
			if (!moveIsInTime())
				_beatAlreadyScored = false;
		}
		
		public function scoreBeat():Boolean
		{
			var result:Boolean = !_beatAlreadyScored && moveIsInTime();
			_beatAlreadyScored = true;
			return result;
		}
		
		public function moveIsInTime():Boolean
		{
			return _time <= BEAT_TIME_TOLERANCE;// || time >= nextBeatTime - BEAT_TIME_TOLERANCE;
		}
		
		public function moveIsInTimeForVisuals():Boolean
		{
			return _time <= BEAT_TIME_TOLERANCE;
		}
		
	}

}