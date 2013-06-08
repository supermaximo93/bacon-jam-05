package  
{
	import flash.system.System;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class PlayState extends FlxState 
	{
		public static const TILE_SIZE:int = 32;
		private const COMBOTEXT_OFFSET:int = 10;
		
		private var songManager:SongManager;
		private var player:Player;
		private var combo:int;
		private var comboText:FlxText;
		private var hud:FlxGroup;
		
		override public function create():void 
		{
			songManager = new SongManager(120);
			player = new Player(100, 100);
			comboText = new FlxText(COMBOTEXT_OFFSET, COMBOTEXT_OFFSET, 100, "x0");
			hud = new FlxGroup();
			add(player);
			hud.add(comboText);
			add(hud);
			hud.setAll("scrollFactor", new FlxPoint(0, 0));
			FlxG.camera.follow(player);
			combo = 0;
		}
		
		override public function update():void 
		{
			
			var playerMoved:Boolean = false;
			if (FlxG.keys.justPressed("W"))
			{
				player.moveUp();
				playerMoved = true;
			}
			else if (FlxG.keys.justPressed("S"))
			{
				player.moveDown();
				playerMoved = true;
			}
			else if (FlxG.keys.justPressed("A"))
			{
				player.moveLeft();
				playerMoved = true;
			}
			else if (FlxG.keys.justPressed("D"))
			{
				player.moveRight();
				playerMoved = true;
			}
			
			CONFIG::debug {
				if (FlxG.keys.justPressed("ESCAPE"))
					System.exit(0);
			}
			
			songManager.update();
			
			if (playerMoved)
			{
				if (songManager.moveIsInTime())
					++combo;
				else
					combo = 0;
				
				comboText.text = "x" + combo.toString();
			}
			
			
			if (songManager.moveIsInTimeForVisuals())
				player.scale = new FlxPoint(1.2, 1.2);
			else
				player.scale = new FlxPoint(1.0, 1.0);
			
			super.update();
		}
		
	}

}