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
		
		private var bpm:int;
		private var timePerBeat:Number;
		private var time:Number;
		private var beatAlreadyScored:Boolean;
		
		private var beats:Array = [
			1, 1, 1, 0.5, 0.5
		];
		private var beatIndex:int;
		private var nextBeatTime:Number;
		
		public function SongManager(bpm:int) 
		{
			this.bpm = bpm;
			var beatsPerSecond:Number = bpm / 60.0;
			timePerBeat = 1.0 / beatsPerSecond;
			time = 0.0;
			beatIndex = -1;
			nextBeatTime = timePerBeat;
			beatAlreadyScored = false;
		}
		
		public function update():void
		{
			time += FlxG.elapsed;
			if (time >= nextBeatTime)
			{
				//if (beatIndex < 0)
				//	FlxG.playMusic(testMusic);
				
				time -= nextBeatTime;
				if (++beatIndex >= beats.length)
					beatIndex = 0;
				nextBeatTime = timePerBeat * beats[beatIndex];
				
				FlxG.play(kickSound);
			}
			
			if (!moveIsInTime())
				beatAlreadyScored = false;
		}
		
		public function scoreBeat():Boolean
		{
			var result:Boolean = !beatAlreadyScored && moveIsInTime();
			beatAlreadyScored = true;
			return result;
		}
		
		public function moveIsInTime():Boolean
		{
			return time <= BEAT_TIME_TOLERANCE;// || time >= nextBeatTime - BEAT_TIME_TOLERANCE;
		}
		
		public function moveIsInTimeForVisuals():Boolean
		{
			return time <= BEAT_TIME_TOLERANCE;
		}
		
	}

}