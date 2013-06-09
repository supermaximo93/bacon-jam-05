package  
{
	import adobe.utils.ProductManager;
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class MapRoom 
	{
		
		private const CHANCE_OF_CORRIDOR:Number = 0.2;
		
		private var _isCorridor:Boolean;
		private var _positionX:int;
		private var _positionY:int;
		private var _connectedRooms:Array;
		private var _lights:Array;
		private var _people:Array;
		private var _overlay:RoomOverlay;
		
		public function get positionX():int
		{
			return _positionX;
		}
		
		public function get positionY():int
		{
			return _positionY;
		}
		
		public function get connectedRooms():Array
		{
			return _connectedRooms;
		}
		
		public function get isCorridor():Boolean
		{
			return _isCorridor && _connectedRooms.length > 1;
		}
		
		public function get connected():Boolean
		{
			return _connectedRooms.length > 0;
		}
		
		public function get lightCount():int
		{
			return _lights.length;
		}
		
		public function MapRoom(positionX:int, positionY:int, roomWidth:int, roomHeight:int)
		{
			_positionX = positionX;
			_positionY = positionY;
			_isCorridor = FlxG.random() <= CHANCE_OF_CORRIDOR;
			_connectedRooms = new Array();
			_lights = new Array();
			_people = new Array();
			_overlay = null;
		}
		
		public function connectTo(room:MapRoom):void
		{
			_connectedRooms.push(room);
			room._connectedRooms.push(this);
		}
		
		public function getNeighborWhere(rooms:Array, columns:int, rows:int, predicate:Function):MapRoom
		{
			var neighbors:Array = new Array();
			
			for (var x:int = positionX - 1; x <= positionX + 1; ++x)
			{
				if (x < 0 || x >= columns)
					continue;
				
				for (var y:int = positionY - 1; y <= positionY + 1; ++y)
				{
					if (y < 0 || y >= rows)
						continue;
					if (positionX == x && positionY == y)
						continue;
					if (x - positionX != 0 && y - positionY != 0)
						continue;
					
					var room:MapRoom = rooms[x][y];
					if (predicate(room))
						neighbors.push(room);
				}
			}
			
			if (neighbors.length > 0)
				return ArrayHelpers.sample(neighbors) as MapRoom;
			return null;
		}
		
		public function addLightsAndPeopleToGroup(group:FlxGroup, peopleArr:Array):void
		{
			var i:int;
			for (i = 0; i < _lights.length; ++i)
				group.add(_lights[i]);
			for (i = 0; i < _people.length; ++i)
			{
				group.add(_people[i]);
				peopleArr.push(_people[i]);
			}
			if (_overlay != null)
				group.add(_overlay);
		}
		
		public function removeLight(light:Light):void
		{
			ArrayHelpers.removeElement(_lights, light);
			if (_lights.length == 0)
				_overlay.setLightsOut();
		}
		
		public function generateLightsAndPeople(roomWidth:int, roomHeight:int):void
		{
			if (_isCorridor)
				return;
			
			const LIGHTS_PER_SQUARE:Number = 0.06;
			const PEOPLE_PER_SQUARE:Number = 0.04;
			var lightCount:int = int(LIGHTS_PER_SQUARE * roomWidth * roomHeight * FlxG.random());
			var personCount:int = int(PEOPLE_PER_SQUARE * roomWidth * roomHeight * FlxG.random());
			
			var minX:int = (positionX * roomWidth) + 1;
			var maxX:int = minX + roomWidth - 2;
			var midX:int = int(lerp(minX, maxX, 0.5));
			var minY:int = (positionY * roomHeight) + 1;
			var maxY:int = minY + roomHeight - 2;
			var midY:int = int(lerp(minY, maxY, 0.5));
			
			do
			{
				var x:int = int(lerp(minX, maxX, FlxG.random()));
				var y:int = int(lerp(minY, maxY, FlxG.random()));
				
				if (PlayState.instance.corridorAtPosition(x - 1, y))
					continue;
				if (PlayState.instance.corridorAtPosition(x + 1, y))
					continue;
				if (PlayState.instance.corridorAtPosition(x, y - 1))
					continue;
				if (PlayState.instance.corridorAtPosition(x, y + 1))
					continue;
				
				if (!entityAtPosition(_lights, x, y) && !entityAtPosition(_people, x, y))
				{
					if (_lights.length < lightCount)
						_lights.push(new Light(x, y, this));
					else
						_people.push(new Person(x, y));
				}
				
			} while (_lights.length < lightCount || _people.length < personCount);
			
			if (lightCount > 0)
				_overlay = new RoomOverlay(minX, minY, roomWidth - 2, roomHeight - 2);
		}
		
		private function entityAtPosition(arr:Array, x:int, y:int):Boolean
		{
			for (var i:int = 0; i < arr.length; ++i)
			{
				var entity:Entity = arr[i] as Entity;
				if (entity.tileX == x && entity.tileY == y)
					return true;
			}
			return false;
		}
		
		private function lerp(min:Number, max:Number, percentage:Number):Number
		{
			return min + ((max - min) * percentage);
		}
		
	}

}