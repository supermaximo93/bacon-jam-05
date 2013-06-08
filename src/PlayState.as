package  
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		
		override public function create():void 
		{
			add(new FlxText(10, 10, 100, "test"));
		}
		
	}

}