package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class BeatIndicator extends FlxSprite 
	{
		
		public static var group:FlxGroup = new FlxGroup();
		
		private var _killNow:Boolean;
		private var _killTimer:Number;
		
		public function BeatIndicator(x:Number, y:Number, velocityX:Number) 
		{
			super(x, y, null);
			newReset(x, y, velocityX);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffffffff);
		}
		
		public static function create(x:Number, y:Number, velocityX:Number):BeatIndicator
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
		
		public function newReset(x:Number, y:Number, velocityX:Number):void
		{
			super.reset(x, y);
			velocity.x = velocityX;
			scale = new FlxPoint(1.0, 1.0);
			_killNow = false;
			_killTimer = 0.0;
		}
		
		override public function update():void 
		{
			const KILL_TIME:Number = 0.05;
			
			super.update();
			
			if (x <= (FlxG.width / 2) - (width / 2))
			{
				scale = new FlxPoint(1.5, 1.5);
				velocity.x = 0.0;
				_killNow = true;
			}
			
			if (_killNow)
			{
				_killTimer += FlxG.elapsed;
				if (_killTimer >= KILL_TIME)
					kill();
			}
		}
		
	}

}