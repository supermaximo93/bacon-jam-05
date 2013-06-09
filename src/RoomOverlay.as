package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class RoomOverlay extends Entity 
	{
		private static var colors:Array = new Array(
			0xff00ffff,
			0xff0000ff,
			0xff00ff00,
			0xffff0000,
			0xffff00ff,
			0xffffff00
		);
		
		private const ALPHA_DELTA_SPEED:Number = 2.0;
		private const MAX_ALPHA:Number = 0.7;
		
		private var _alphaGoingDown:Boolean;
		private var _lightsOut:Boolean;
		
		override public function get canScaleUp():Boolean 
		{
			return false;
		}
		
		public function RoomOverlay(x:int, y:int, width:int, height:int) 
		{
			super(x, y, null);
			makeGraphic(width * PlayState.TILE_SIZE, height * PlayState.TILE_SIZE, ArrayHelpers.sample(colors) as uint);
			_alphaGoingDown = true;
			_lightsOut = false;
			alpha = MAX_ALPHA * FlxG.random();
		}
		
		public function setLightsOut():void
		{
			_lightsOut = true;
			alpha = 1.0;
			makeGraphic(width, height, 0xcc000000);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_lightsOut)
			{
				var alphaDelta:Number = ALPHA_DELTA_SPEED * FlxG.elapsed * (_alphaGoingDown ? -1.0 : 1.0);
				alpha += alphaDelta;
				if (alpha <= 0.0)
				{
					alpha = 0.0;
					_alphaGoingDown = false;
					makeGraphic(width, height, ArrayHelpers.sample(colors) as uint);
				}
				else if (alpha >= MAX_ALPHA)
				{
					alpha = MAX_ALPHA;
					_alphaGoingDown = true;
				}
			}
		}
		
	}

}