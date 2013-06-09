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
		private const SCORETEXT_OFFSET_X:int = 5;
		private const SCORETEXT_OFFSET_Y:int = 5;
		private const COMBOTEXT_OFFSET_X:int = 5;
		private const COMBOTEXT_OFFSET_Y:int = 20;
		private const LIGHTCOUNTTEXT_OFFSET_X:int = 100;
		private const LIGHTCOUNTTEXT_OFFSET_Y:int = 5;
		private const BEATTEXT_OFFSET_X:int = 5;
		private const BEATTEXT_OFFSET_Y:int = 100;
		//private const PLAYERMOVESTEXT_OFFSET:int = 100;
		private const LEVEL_WIDTH:int = 50;
		private const LEVEL_HEIGHT:int = 50;
		private const LEVEL_COLUMNS:int = 5;
		private const LEVEL_ROWS:int = 5;
		private const CORRIDOR_PADDING:int = 0;
		
		private static var _instance:PlayState;
		
		public var songManager:SongManager;
		private var player:Player;
		private var score:int;
		private var scoreText:FlxText;
		private var combo:int;
		private var comboText:FlxText;
		private var lightCount:int;
		private var lightCountText:FlxText;
		private var consecutiveBeats:int;
		private var beatText:FlxText;
		private var playerMoves:int;
		//private var playerMovesText:FlxText;
		private var hud:FlxGroup;
		private var otherEntities:FlxGroup;
		private var levelData:Object;
		private var tileMap:FlxTilemap;
		private var people:Array;
		private var peopleMovedThisBeat:Boolean;
		private var highestCombo:int;
		private var highestConsecutiveBeats:int;
		public var previousSongPosition:Number;
		
		public static function get instance():PlayState
		{
			return _instance;
		}
		
		override public function create():void 
		{
			FlxG.bgColor = 0xffdddddd;
			_instance = this;
			BeatIndicator.init();
			songManager = new SongManager(120);
			
			tileMap = new FlxTilemap();
			add(tileMap);
			
			otherEntities = new FlxGroup();
			
			player = new Player(5, 5);
			add(player);
			add(otherEntities);
			
			score = 0;
			combo = 0;
			playerMoves = 0;
			consecutiveBeats = 0;
			highestCombo = 0;
			highestConsecutiveBeats = 0;
			
			scoreText = new FlxText(SCORETEXT_OFFSET_X, SCORETEXT_OFFSET_Y, 100, "Score: 0");
			comboText = new FlxText(COMBOTEXT_OFFSET_X, COMBOTEXT_OFFSET_Y, 100, "x0");
			comboText.visible = false;
			lightCountText = new FlxText(LIGHTCOUNTTEXT_OFFSET_X, LIGHTCOUNTTEXT_OFFSET_Y, 100);
			beatText = new FlxText(BEATTEXT_OFFSET_X, BEATTEXT_OFFSET_Y, 100, "x0");
			beatText.visible = false;
			//playerMovesText = new FlxText(SCORETEXT_OFFSET, PLAYERMOVESTEXT_OFFSET, 100, "Moves: 0");
			hud = new FlxGroup();
			hud.add(new BeatTarget((FlxG.width / 2) - 5, SongManager.BEAT_STREAM_Y - 1));
			hud.add(BeatIndicator.mainGroup);
			hud.add(BeatIndicator.dummyGroup);
			hud.add(scoreText);
			hud.add(comboText);
			hud.add(lightCountText);
			hud.add(beatText);
			//hud.add(playerMovesText);
			hud.setAll("scrollFactor", new FlxPoint(0, 0));
			add(hud);
			
			people = new Array();
			peopleMovedThisBeat = false;
			
			levelData = getLevelData();
			var roomWidth:int = LEVEL_WIDTH / LEVEL_COLUMNS;
			var roomHeight:int = LEVEL_HEIGHT / LEVEL_ROWS;
			lightCount = 0;
			for (var x:int = 0; x < LEVEL_COLUMNS; ++x)
			{
				for (var y:int = 0; y < LEVEL_ROWS; ++y)
				{
					var room:MapRoom = levelData.rooms[x][y];
					room.generateLightsAndPeople(roomWidth, roomHeight);
					room.addLightsAndPeopleToGroup(otherEntities, people);
					lightCount += room.lightCount;
				}
			}
			tileMap.loadMap(FlxTilemap.arrayToCSV(levelData.tileMap, LEVEL_WIDTH), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			FlxG.camera.follow(player);
			FlxG.camera.setBounds(0, 0, tileMap.width, tileMap.height);
			lightCountText.text = "Lights: " + lightCount.toString();
			
			previousSongPosition = 0;
		}
		
		override public function update():void 
		{
			if (songManager.sound != null)
			{
				FlxG.elapsed = (songManager.sound.position - previousSongPosition) / 1000.0;
				previousSongPosition = songManager.sound.position;
			}
			
			if (songManager.moveIsInTimeForVisuals())
			{
				if (!peopleMovedThisBeat)
				{
					movePeople();
					peopleMovedThisBeat = true;
				}
			}
			else
				peopleMovedThisBeat = false;
			
			var playerDidAction:Boolean = false;
			var comboBreaker:Boolean = false;
			var smashedLight:Boolean = false;
			
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
				if (playerShotLight("UP"))
					smashedLight = true;
				else
					comboBreaker = true;
				playerDidAction = true;
				player.angle = 270;
			}
			else if (FlxG.keys.justPressed("DOWN"))
			{
				if (playerShotLight("DOWN"))
					smashedLight = true;
				else
					comboBreaker = true;
				playerDidAction = true;
				player.angle = 90;
			}
			else if (FlxG.keys.justPressed("LEFT"))
			{
				if (playerShotLight("LEFT"))
					smashedLight = true;
				else
					comboBreaker = true;
				playerDidAction = true;
				player.angle = 180;
			}
			else if (FlxG.keys.justPressed("RIGHT"))
			{
				if (playerShotLight("RIGHT"))
					smashedLight = true;
				else
					comboBreaker = true;
				playerDidAction = true;
				player.angle = 0;
			}
			
			if (FlxG.keys.justPressed("ESCAPE"))
				lightCount = 0;
			
			songManager.update();
			
			if (playerDidAction)
			{
				if (!comboBreaker && songManager.scoreBeat())
				{
					++combo;
					if (combo > highestCombo)
						highestCombo = combo;
					comboText.text = "x" + combo.toString();
					comboText.visible = true;
					if (smashedLight)
					{
						var scoreAdded:int = combo + consecutiveBeats;
						score += scoreAdded;
						if (songManager.startOfBar())
							score += scoreAdded;
					}
					
					BeatIndicator.score();
					++consecutiveBeats;
					if (consecutiveBeats > highestConsecutiveBeats)
						highestConsecutiveBeats = consecutiveBeats;
				}
				else
				{
					combo = 0;
					comboText.visible = false;
				}
				//playerMovesText.text = "Moves: " + playerMoves.toString();
			}
			
			scoreText.text = "Score: " + (score - playerMoves).toString();
			if (consecutiveBeats == 0)
				beatText.visible = false;
			else
			{
				beatText.text = "x" + consecutiveBeats.toString();
				beatText.visible = true;
			}
			
			super.update();
			
			if (lightCount == 0)
			{
				FlxG.switchState(new SummaryState(score, playerMoves, highestCombo, highestConsecutiveBeats));
				songManager.sound.stop();
				songManager.sound.kill();
			}
		}
		
		public function nothingAtPosition(x:int, y:int):Boolean
		{
			return !wallAtPosition(x, y) && entityAtPosition(x, y) == null && !(player.tileX == x && player.tileY == y);
		}
		
		public function wallAtPosition(x:int, y:int):Boolean
		{
			return levelData.tileMap[x + (y * LEVEL_WIDTH)] == 1;
		}
		
		public function entityAtPosition(x:int, y:int):Entity
		{
			for (var i:int = 0; i < otherEntities.members.length; ++i)
			{
				var entity:Entity = otherEntities.members[i] as Entity;
				if (entity != null && entity.alive && entity.tileX == x && entity.tileY == y)
					return entity;
			}
			return null;
		}
		
		public function corridorAtPosition(x:int, y:int):Boolean
		{
			return !wallAtPosition(x, y) && ((wallAtPosition(x - 1, y) && wallAtPosition(x + 1, y)) || (wallAtPosition(x, y - 1) && wallAtPosition(x, y + 1)));
		}
		
		public function decLightCount():void
		{
			--lightCount;
			lightCountText.text = "Lights: " + lightCount.toString();
		}
		
		public function missBeat():void
		{
			consecutiveBeats = 0;
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
					return true;
					
				}
			}
			
			return false;
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
		
		private function movePeople():void
		{
			for (var i:int = 0; i < people.length; ++i)
				people[i].move();
		}
		
		private function getLevelData():Object
		{
			return MapGenerator.generateMap(LEVEL_WIDTH, LEVEL_HEIGHT, LEVEL_COLUMNS, LEVEL_ROWS, CORRIDOR_PADDING);
		}
		
	}

}