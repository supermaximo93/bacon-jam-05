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
		[Embed(source="../assets/music/song_1.mp3")] public static var song1:Class;
		[Embed(source="../assets/music/menu.mp3")] public static var menuMusic:Class;
		[Embed(source="../assets/sounds/kick.mp3")] private static var kickSound:Class;
		
		public static const BEAT_STREAM_COUNT:int = 15;
		public static const BEAT_STREAM_Y:int = 100;
		private const BEAT_TIME_TOLERANCE:Number = 0.2;
		private const BARS_IN_SONG:int = 56;
		
		private var _bpm:int;
		private var _timePerBeat:Number;
		private var _time:Number;
		private var _beatAlreadyScored:Boolean;
		private var _beatsPassedInBar:Number;
		private var _moveIsInTimeLastUpdate:Boolean;
		private var _barCount:int;
		
		private var _beats:Array = [
			1, 1, 1, 1
		];
		private var _beatStream:Array;
		private var _beatIndex:int;
		private var _nextBeatTime:Number;
		private var _spaceBetweenBeats:Number;
		private var _beatIndicatorVelocity:Number;
		public var sound:FlxSound;
		
		public function SongManager(bpm:int)
		{
			_bpm = bpm;
			var beatsPerSecond:Number = bpm / 60.0;
			_timePerBeat = 1.0 / beatsPerSecond;
			_time = 0.0;
			_beatIndex = -1;
			_nextBeatTime = _timePerBeat * 4;
			_beatAlreadyScored = false;
			_beatsPassedInBar = 0.0;
			_beatStream = new Array();
			_beatIndicatorVelocity = -(FlxG.width + (PlayState.TILE_SIZE / 2)) / _nextBeatTime;
			_spaceBetweenBeats = -_beatIndicatorVelocity * _timePerBeat;
			updateBeatStream();
			_barCount = 0;
		}
		
		public function update():void
		{
			_time += FlxG.elapsed;
			if (_time >= _nextBeatTime)
			{
				if (_beatIndex >= 0)
				{
					_beatsPassedInBar += _beats[_beatIndex];
					if (_beatsPassedInBar >= 4.0)
						_beatsPassedInBar -= 4.0;
					_time -= _nextBeatTime;
				}
				else
				{
					sound = FlxG.play(song1);
					_time = 0.0005;
				}
				
				if (++_beatIndex >= _beats.length)
				{
					_beatIndex = 0;
					if (++_barCount >= BARS_IN_SONG)
					{
						_barCount = 0;
						sound = FlxG.play(song1);
						PlayState.instance.previousSongPosition = 0;
					}
				}
				_nextBeatTime = _timePerBeat * _beats[_beatIndex];
				updateBeatStream();
				
				FlxG.play(kickSound);
			}
			
			if (moveIsInTime())
				_moveIsInTimeLastUpdate = true;
			else
			{
				if (_moveIsInTimeLastUpdate && !_beatAlreadyScored)
					PlayState.instance.missBeat();
				_beatAlreadyScored = false;
				_moveIsInTimeLastUpdate = false;
			}
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
		
		public function startOfBar():Boolean
		{
			return _beatsPassedInBar == 0.0;
		}
		
		private function updateBeatStream():void
		{
			if (_beatStream.length > 0)
				_beatStream.splice(0, _beatStream.length);
			var beatIndex:int = _beatIndex < 0 ? 0 : _beatIndex;
			
			for (var i:int = 0; i < BEAT_STREAM_COUNT; ++i)
			{
				_beatStream.push(_beats[beatIndex]);
				if (++beatIndex >= _beats.length)
					beatIndex = 0;
			}
			
			var indicators:Array = BeatIndicator.mainGroup.members.filter(function(el:*, index:int, arr:Array):Boolean { return el is FlxSprite && (el as FlxSprite).alive; } ).sortOn("x", Array.NUMERIC);
			var indicatorCount:int = indicators.length;
			if (indicatorCount == 0)
			{
				indicators.push(BeatIndicator.create(FlxG.width * 1.5, BEAT_STREAM_Y, _beatIndicatorVelocity));
				++indicatorCount;
			}
			
			while (indicatorCount < BEAT_STREAM_COUNT)
			{
				var indicatorInFront:BeatIndicator = indicators[indicatorCount - 1];
				var nextBeat:Number = _beatStream[indicatorCount - 1];
				indicators.push(BeatIndicator.create(indicatorInFront.x + (nextBeat * _spaceBetweenBeats), BEAT_STREAM_Y, _beatIndicatorVelocity));
				++indicatorCount;
			}
		}
		
	}

}