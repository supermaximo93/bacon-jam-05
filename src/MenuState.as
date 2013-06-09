package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class MenuState extends FlxState 
	{
		private static var playMusic:Boolean = true;
		
		override public function create():void 
		{
			super.create();
			if (playMusic)
				FlxG.playMusic(SongManager.menuMusic);
			playMusic = false;
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.music.stop();
				FlxG.switchState(new PlayState());
			}
		}
		
	}

}