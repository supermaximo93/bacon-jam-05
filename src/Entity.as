package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Entity extends FlxSprite 
	{
		
		private var _tileX:int;
		private var _tileY:int;
		
		public function get tileX():int
		{
			return _tileX;
		}
		
		public function set tileX(value:int):void
		{
			_tileX = value;
			updateXFromTileX();
		}
		
		public function get tileY():int
		{
			return _tileY;
		}
		
		public function set tileY(value:int):void
		{
			_tileY = value;
			updateYFromTileY();
		}
		
		public function get canScaleUp():Boolean
		{
			return true;
		}
		
		public function Entity(tileX:int, tileY:int, graphic:Class=null) 
		{
			this.tileX = tileX;
			this.tileY = tileY;
			super(x, y, graphic);
		}
		
		public function moveUp():void
		{
			--tileY;
			updateYFromTileY();
			angle = 270;
		}
		
		public function moveDown():void
		{
			++tileY;
			updateYFromTileY();
			angle = 90;
		}
		
		public function moveLeft():void
		{
			--tileX;
			updateXFromTileX();
			angle = 180;
		}
		
		public function moveRight():void
		{
			++tileX;
			updateXFromTileX();
			angle = 0;
		}
		
		override public function update():void 
		{
			if (PlayState.instance.songManager.moveIsInTimeForVisuals() && canScaleUp)
				scale.x = scale.y = 1.2;
			else
				scale.x = scale.y = 1.0;
			super.update();
		}
		
		private function updateXFromTileX():void
		{
			x = tileX * PlayState.TILE_SIZE;
		}
		
		private function updateYFromTileY():void
		{
			y = tileY * PlayState.TILE_SIZE;
		}
		
	}

}