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
			add(new FlxText(45, 50, 100, "RAVE CRASHER"));
			add(new FlxText(30, 70, 120, "Press space to start"));
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
				FlxG.music.kill();
				FlxG.switchState(new PlayState());
			}
		}
		
	}

}