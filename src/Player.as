package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends Entity 
	{
		
		public function Player(x:int, y:int) 
		{
			super(x, y, null);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xff0000ff);
		}
		
	}

}