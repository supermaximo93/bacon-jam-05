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
		public static const TILE_SIZE:int = 8;
		private const SCORETEXT_OFFSET:int = 5;
		private const COMBOTEXT_OFFSET:int = 20;
		//private const PLAYERMOVESTEXT_OFFSET:int = 100;
		private const LEVEL_WIDTH:int = 50;
		private const LEVEL_HEIGHT:int = 50;
		private const LEVEL_COLUMNS:int = 5;
		private const LEVEL_ROWS:int = 5;
		private const CORRIDOR_PADDING:int = 0;
		
		private var songManager:SongManager;
		private var player:Player;
		private var score:int;
		private var scoreText:FlxText;
		private var combo:int;
		private var comboText:FlxText;
		private var playerMoves:int;
		//private var playerMovesText:FlxText;
		private var hud:FlxGroup;
		private var otherEntities:FlxGroup;
		private var levelData:Object;
		private var tileMap:FlxTilemap;
		
		override public function create():void 
		{
			songManager = new SongManager(120);
			
			tileMap = new FlxTilemap();
			add(tileMap);
			
			otherEntities = new FlxGroup();
			
			player = new Player(5, 5);
			add(player);
			add(otherEntities);
			FlxG.camera.follow(player);
			
			score = 0;
			combo = 0;
			playerMoves = 0;
			scoreText = new FlxText(SCORETEXT_OFFSET, SCORETEXT_OFFSET, 100, "Score: 0");
			comboText = new FlxText(SCORETEXT_OFFSET, COMBOTEXT_OFFSET, 100, "x0");
			comboText.visible = false;
			//playerMovesText = new FlxText(SCORETEXT_OFFSET, PLAYERMOVESTEXT_OFFSET, 100, "Moves: 0");
			hud = new FlxGroup();
			hud.add(scoreText);
			hud.add(comboText);
			//hud.add(playerMovesText);
			hud.setAll("scrollFactor", new FlxPoint(0, 0));
			add(hud);
			
			levelData = getLevelData();
			for (var x:int = 0; x < LEVEL_COLUMNS; ++x)
			{
				for (var y:int = 0; y < LEVEL_ROWS; ++y)
					levelData.rooms[x][y].addLightsToGroup(otherEntities);
			}
			tileMap.loadMap(FlxTilemap.arrayToCSV(levelData.tileMap, LEVEL_WIDTH), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
		}
		
		override public function update():void 
		{			
			var playerDidAction:Boolean = false;
			var comboBreaker:Boolean = false;
			
			if (FlxG.keys.justPressed("W"))
			{
				player.moveUp();
				if (playerIsColliding())
				{
					player.moveDown();
					comboBreaker = true;
				}
				else
					++playerMoves;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("S"))
			{
				player.moveDown();
				if (playerIsColliding())
				{
					player.moveUp();
					comboBreaker = true;
				}
				else
					++playerMoves;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("A"))
			{
				player.moveLeft();
				if (playerIsColliding())
				{
					player.moveRight();
					comboBreaker = true;
				}
				else
					++playerMoves;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("D"))
			{
				player.moveRight();
				if (playerIsColliding())
				{
					player.moveLeft();
					comboBreaker = true;
				}
				else
					++playerMoves;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("UP"))
			{
				if (!playerShotLight("UP"))
					comboBreaker = true;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("DOWN"))
			{
				if (!playerShotLight("DOWN"))
					comboBreaker = true;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("LEFT"))
			{
				if (!playerShotLight("LEFT"))
					comboBreaker = true;
				playerDidAction = true;
			}
			else if (FlxG.keys.justPressed("RIGHT"))
			{
				if (!playerShotLight("RIGHT"))
					comboBreaker = true;
				playerDidAction = true;
			}
			
			CONFIG::debug {
				if (FlxG.keys.justPressed("ESCAPE"))
					System.exit(0);
			}
			
			songManager.update();
			
			if (playerDidAction)
			{
				if (!comboBreaker && songManager.scoreBeat())
				{
					++combo;
					comboText.text = "x" + combo.toString();
					comboText.visible = true;
				}
				else
				{
					combo = 0;
					comboText.visible = false;
				}
				//playerMovesText.text = "Moves: " + playerMoves.toString();
			}
			
			
			if (songManager.moveIsInTimeForVisuals())
				player.scale = new FlxPoint(1.2, 1.2);
			else
				player.scale = new FlxPoint(1.0, 1.0);
			
			scoreText.text = "Score: " + (score - playerMoves).toString();
			
			super.update();
		}
		
		private function playerIsColliding():Boolean
		{
			return playerIsCollidingWithWall() || playerIsCollidingWithEntity();
		}
		
		private function playerIsCollidingWithWall():Boolean
		{
			return wallAtPosition(player.tileX, player.tileY);
		}
		
		private function playerIsCollidingWithEntity():Boolean
		{
			return entityAtPosition(player.tileX, player.tileY) != null;
		}
		
		private function playerShotLight(direction:String):Boolean
		{
			var hitscanVector:FlxPoint = getVectorForDirection(direction);
			if (hitscanVector == null)
				return false;
			
			var x:int = player.tileX;
			var y:int = player.tileY;
			
			var levelHeight:int = levelData.tileMap.length / LEVEL_WIDTH;
			while (x > 0 && x < LEVEL_WIDTH && y > 0 && y < levelHeight)
			{
				x += hitscanVector.x;
				y += hitscanVector.y;
				if (wallAtPosition(x, y))
					return false;
				var entity:Entity = entityAtPosition(x, y);
				if (entity != null)
				{
					var light:Light = entity as Light;
					if (light == null || light.smashed)
						return false;
					
					light.smash();
					score += combo;
					return true;
					
				}
			}
			
			return false;
		}
		
		private function wallAtPosition(x:int, y:int):Boolean
		{
			return levelData.tileMap[x + (y * LEVEL_WIDTH)] == 1;
		}
		
		private function entityAtPosition(x:int, y:int):Entity
		{
			for (var i:int = 0; i < otherEntities.members.length; ++i)
			{
				var entity:Entity = otherEntities.members[i] as Entity;
				if (entity != null && entity.alive && entity.tileX == x && entity.tileY == y)
					return entity;
			}
			return null;
		}
		
		private function getVectorForDirection(direction:String):FlxPoint
		{
			switch (direction)
			{
				case "UP": return new FlxPoint(0, -1);
				case "DOWN": return new FlxPoint(0, 1);
				case "LEFT": return new FlxPoint(-1, 0);
				case "RIGHT": return new FlxPoint(1, 0);
			}
			return null;
		}
		
		private function getLevelData():Object
		{
			return MapGenerator.generateMap(LEVEL_WIDTH, LEVEL_HEIGHT, LEVEL_COLUMNS, LEVEL_ROWS, CORRIDOR_PADDING);
		}
		
	}

}