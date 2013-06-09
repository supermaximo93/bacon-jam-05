package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class BeatIndicator extends FlxSprite 
	{
		
		public static var mainGroup:FlxGroup;
		public static var dummyGroup:FlxGroup;
		
		private var _killNow:Boolean;
		private var _killTimer:Number;
		private var _isDummy:Boolean;
		private var _dummy:BeatIndicator;		

		public static function init():void
		{
			mainGroup = new FlxGroup(SongManager.BEAT_STREAM_COUNT);
			dummyGroup = new FlxGroup(SongManager.BEAT_STREAM_COUNT);
			initInternal(mainGroup);
			initInternal(dummyGroup);
		}
		
		public static function create(x:Number, y:Number, velocityX:Number):BeatIndicator
		{
			return createInternal(x, y, velocityX, mainGroup);
		}
		
		public static function createDummy(x:Number, y:Number, velocityX:Number):BeatIndicator
		{
			var beatIndicator:BeatIndicator = createInternal(x, y, velocityX, dummyGroup);
			beatIndicator.alpha = 0.5;
			beatIndicator._isDummy = true;
			return beatIndicator;
		}
		
		public static function score():void
		{
			var beatIndicator:BeatIndicator = getClosestBeatIndicatorToCenter();
			if (beatIndicator == null)
				return;
			beatIndicator._killNow = true;
			beatIndicator.scale = new FlxPoint(1.5, 1.5);
			beatIndicator.velocity.x = 0;
			beatIndicator.makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffffff00);
		}
		
		private static function getClosestBeatIndicatorToCenter():BeatIndicator
		{
			var result:BeatIndicator = null;
			var centerX:Number = (FlxG.width / 2) - (PlayState.TILE_SIZE / 2);
			var shortestDistance:Number = 0;
			for (var i:int = 0; i < dummyGroup.members.length; ++i)
			{
				var beatIndicator:BeatIndicator = dummyGroup.members[i] as BeatIndicator;
				if (beatIndicator._killNow)
					continue;
				var distance:Number = Math.abs(beatIndicator.x - centerX);
				if (result == null || distance < shortestDistance)
				{
					result = beatIndicator;
					shortestDistance = distance;
				}
			}
			return result;
		}
		
		private static function initInternal(group:FlxGroup):void
		{
			while (group.length < SongManager.BEAT_STREAM_COUNT)
			{
				var beatIndicator:BeatIndicator = new BeatIndicator(0, 0, 0);
				group.add(beatIndicator);
				beatIndicator.kill();
			}
		}
		
		private static function createInternal(x:Number, y:Number, velocityX:Number, group:FlxGroup):BeatIndicator
		{
			var beatIndicator:BeatIndicator = group.getFirstAvailable() as BeatIndicator;
			if (beatIndicator != null)
			{
				beatIndicator.newReset(x, y, velocityX);
				return beatIndicator;
			}
			
			beatIndicator = new BeatIndicator(x, y, velocityX);
			group.add(beatIndicator);
			return beatIndicator;
		}
		
		public function BeatIndicator(x:Number, y:Number, velocityX:Number) 
		{
			super(x, y, null);
			newReset(x, y, velocityX);
		}
		
		
		public function newReset(x:Number, y:Number, velocityX:Number):void
		{
			super.reset(x, y);
			velocity.x = velocityX;
			scale = new FlxPoint(1.0, 1.0);
			alpha = 1.0;
			_killNow = false;
			_killTimer = 0.0;
			_isDummy = false;
			_dummy = null;
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffffffff);
		}
		
		override public function update():void 
		{
			const KILL_TIME:Number = 0.05;
			
			if (_isDummy)
			{
				if (x < -width)
					kill();
			}
			else
			{				
				if (_dummy == null && x < FlxG.width)
					_dummy = createDummy(x, y, velocity.x);
				else if (x <= (FlxG.width / 2) - (width / 2))
					kill();
			}

			super.update();
			
			if (_killNow)
			{
				_killTimer += FlxG.elapsed;
				if (_killTimer >= KILL_TIME)
					kill();
			}
		}
		
		override public function kill():void 
		{
			_dummy = null;
			super.kill();
		}
		
	}

}