package  
{
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Light extends Entity 
	{
		
		public function Light(x:int, y:int) 
		{
			super(x, y, null);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffff00ff);
		}
		
	}

}