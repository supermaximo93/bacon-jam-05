package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Player extends FlxSprite 
	{
		
		public function Player(x:int, y:int) 
		{
			super(x, y, null);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xff0000ff);
		}
		
		public function moveUp():void
		{
			y -= PlayState.TILE_SIZE;
		}
		
		public function moveDown():void
		{
			y += PlayState.TILE_SIZE;
		}
		
		public function moveLeft():void
		{
			x -= PlayState.TILE_SIZE;
		}
		
		public function moveRight():void
		{
			x += PlayState.TILE_SIZE;
		}
		
	}

}