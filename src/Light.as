package  
{
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Light extends Entity 
	{
		private var _smashed:Boolean;
		
		public function get destroyed():Boolean
		{
			return _smashed;
		}
		
		public function Light(x:int, y:int) 
		{
			super(x, y, null);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffff00ff);
			_smashed = false;
		}
		
		public function smash():void
		{
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xff00ffff);
			_smashed = true;
		}
		
	}

}