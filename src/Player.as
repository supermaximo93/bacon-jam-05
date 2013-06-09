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
			loadRotatedGraphic(sprite, 4);
		}
		
	}

}