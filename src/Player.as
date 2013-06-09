package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends Entity 
	{
		[Embed(source="../assets/images/player.png")] private var sprite:Class;
		
		public function Player(x:int, y:int)
		{
			super(x, y, sprite);
			//makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xff0000ff);
		}
		
	}

}