package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	
	public class MapGenerator 
	{		
		public static function generateMap(width:int, height:int, columns:int, rows:int, corridorPadding:int):Object
		{
			var roomWidth:int = width / columns;
			var roomHeight:int = height / rows;
			var rooms:Array = generateRoomConnections(columns, rows, roomWidth, roomHeight);
			var collisionMap:Array = generateCollisionMapFromRooms(rooms, width, height, columns, rows, corridorPadding);
			
			var mapArray:Array = new Array();
			
			for (var y:int = 0; y < height; ++y)
			{
				for (var x:int = 0; x < width; ++x)
					mapArray.push(collisionMap[x][y]);
			}
				
			return {
				tileMap: mapArray,
				rooms: rooms
			};
		}
		
		private static function generateCollisionMapFromRooms(rooms:Array, width:int, height:int, columns:int, rows:int, corridorPadding:int):Array
		{
			var collisionMap:Array = ArrayHelpers.new2DArray(width, height, 0);
			var roomWidth:int = width / columns;
			var roomHeight:int = height / rows;
			var x:int, y:int;
			for (x = 0; x < columns; ++x)
			{
				for (y = 0; y < rows; ++y)
				{
					if (rooms[x][y].isCorridor)
						fillInRoom(collisionMap, x, y, roomWidth, roomHeight);
					else
						wallOffRoom(collisionMap, x, y, roomWidth, roomHeight);
				}
			}
			
			for (x = 0; x < columns; ++x)
			{
				for (y = 0; y < rows; ++y)
				{
					var room:MapRoom = rooms[x][y];
					for (var i:int = 0; i < room.connectedRooms.length; ++i)
					{
						var otherRoom:MapRoom = room.connectedRooms[i];
						digCorridor(collisionMap, new FlxPoint(room.positionX, room.positionY), new FlxPoint(otherRoom.positionX, otherRoom.positionY), roomWidth, roomHeight, corridorPadding);
					}
				}
			}
			
			return collisionMap;
		}
		
		private static function fillInRoom(collisionMap:Array, roomX:int, roomY:int, roomWidth:int, roomHeight:int):void
		{
			var startX:int = roomX * roomWidth;
			var finishX:int = startX + roomWidth - 1;
			var startY:int = roomY * roomHeight;
			var finishY:int = startY + roomHeight - 1;
			
			for (var x:int = startX; x <= finishX; ++x)
			{
				for (var y:int = startY; y <= finishY; ++y)
					collisionMap[x][y] = 1;
			}
		}
		
		private static function wallOffRoom(collisionMap:Array, roomX:int, roomY:int, roomWidth:int, roomHeight:int):void
		{
			var startX:int = roomX * roomWidth;
			var finishX:int = startX + roomWidth - 1;
			var startY:int = roomY * roomHeight;
			var finishY:int = startY + roomHeight - 1;
			
			for (var x:int = startX; x <= finishX; ++x)
			{
				collisionMap[x][startY] = 1;
				collisionMap[x][finishY] = 1;
			}
			
			for (var y:int = startY; y <= finishY; ++y)
			{
				collisionMap[startX][y] = 1;
				collisionMap[finishX][y] = 1;
			}
		}
		
		private static function digCorridor(collisionMap:Array, start:FlxPoint, finish:FlxPoint, roomWidth:int, roomHeight:int, corridorPadding:int):void
		{
			var temp:int, startX:int, finishX:int, startY:int, finishY:int, x:int, y:int;
			
			if (start.y == finish.y)
			{
				if (start.x > finish.x)
				{
					temp = start.x;
					start.x = finish.x;
					finish.x = temp;
				}
				
				startX = (start.x * roomWidth) + (roomWidth / 2);
				finishX = startX + roomWidth + 1;
				startY = (start.y * roomHeight) + (roomHeight / 2) - corridorPadding;
				finishY = startY + (corridorPadding * 2);
				for (x = startX; x < finishX; ++x)
				{
					for (y = startY; y <= finishY; ++y)
						collisionMap[x][y] = 0;
				}
			}
			else
			{
				if (start.y > finish.y)
				{
					temp = start.y;
					start.y = finish.y;
					finish.y = temp;
				}
				
				startY = (start.y * roomHeight) + (roomHeight / 2);
                finishY = startY + roomHeight + 1;
                startX = (start.x * roomWidth) + (roomWidth / 2) - corridorPadding;
                finishX = startX + (corridorPadding * 2);
                for (y = startY; y < finishY; ++y)
                {
                    for (x = startX; x <= finishX; ++x)
                        collisionMap[x][y] = 0;
                }
			}
		}
		
		private static function generateRoomConnections(columns:int, rows:int, roomWidth:int, roomHeight:int):Array
		{
			var rooms:Array = ArrayHelpers.new2DArray(columns, rows, null);
			var disconnectedRooms:Array = new Array();
			for (var x:int = 0; x < columns; ++x)
			{
				for (var y:int = 0; y < rows; ++y)
				{
					var room:MapRoom = new MapRoom(x, y, roomWidth, roomHeight);
					rooms[x][y] = room;
					disconnectedRooms.push(room);
				}
			}
			
			var currentRoom:MapRoom = ArrayHelpers.sample(disconnectedRooms) as MapRoom;
			var nextRoom:MapRoom = null;
			while ((nextRoom = currentRoom.getNeighborWhere(rooms, columns, rows, function(r:MapRoom):Boolean { return !r.connected; } )) != null)
			{
				ArrayHelpers.removeElement(disconnectedRooms, currentRoom);
				ArrayHelpers.removeElement(disconnectedRooms, nextRoom);
				currentRoom.connectTo(nextRoom);
				currentRoom = nextRoom;
			}
			
			while (disconnectedRooms.length > 0)
			{
				currentRoom = ArrayHelpers.sample(disconnectedRooms) as MapRoom;
				nextRoom = currentRoom.getNeighborWhere(rooms, columns, rows, function(r:MapRoom):Boolean { return r.connected; } );
				
				if (nextRoom != null)
				{
					ArrayHelpers.removeElement(disconnectedRooms, currentRoom);
					ArrayHelpers.removeElement(disconnectedRooms, nextRoom);
					currentRoom.connectTo(nextRoom);
				}
			}
			
			return rooms;
		}
		
	}
	
}