package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class BeatTarget extends FlxSprite 
	{
		[Embed(source="../assets/images/beat_target.png")] private var sprite:Class;
		
		public function BeatTarget(x:Number, y:Number) 
		{
			super(x, y, sprite);
		}
		
	}

}