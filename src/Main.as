package 
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Main extends FlxGame 
	{
		
		public static const FRAMERATE:int = 60;
		
		public function Main():void 
		{
			super(320, 240, PlayState, 2, FRAMERATE, FRAMERATE);
		}
	}
	
}