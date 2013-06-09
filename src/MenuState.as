package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class MenuState extends FlxState 
	{
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
				FlxG.switchState(new PlayState());
		}
		
	}

}