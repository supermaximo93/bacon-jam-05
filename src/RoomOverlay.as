package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class RoomOverlay extends Entity 
	{
		private var ALPHA_DELTA_SPEED:Number = 2.0;
		
		private var _alphaGoingDown:Boolean;
		private var _lightsOut:Boolean;
		
		public function RoomOverlay(x:int, y:int, width:int, height:int) 
		{
			super(x, y, null);
			makeGraphic(width * PlayState.TILE_SIZE, height * PlayState.TILE_SIZE, 0xff00ffff);
			_alphaGoingDown = true;
			_lightsOut = false;
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
				}
				else if (alpha >= 1.0)
				{
					alpha = 1.0;
					_alphaGoingDown = true;
				}
			}
		}
		
	}

}