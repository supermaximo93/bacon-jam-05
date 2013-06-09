package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Person extends Entity 
	{
		[Embed(source="../assets/images/person.png")] private var sprite:Class;
		
		private static var directionVectors:Array = new Array(
			new FlxPoint(-1, 0),
			new FlxPoint(1, 0),
			new FlxPoint(0, -1),
			new FlxPoint(0, 1)
		);
		
		private static var availableVectors:Array = new Array();
		
		public function Person(x:int, y:int) 
		{
			super(x, y, sprite);
			loadRotatedGraphic(sprite, 4);
		}
		
		public function move():void
		{
			availableVectors.splice(0, availableVectors.length);
			for (var i:int = 0; i < directionVectors.length; ++i)
			{
				var newX:int = tileX + directionVectors[i].x;
				var newY:int = tileY + directionVectors[i].y;
				if (PlayState.instance.nothingAtPosition(newX, newY) && !PlayState.instance.corridorAtPosition(newX, newY))
					availableVectors.push(directionVectors[i]);
			}
			
			if (availableVectors.length == 0)
				return;
				
			var direction:FlxPoint = ArrayHelpers.sample(availableVectors) as FlxPoint;
			if (direction.x < 0)
				moveLeft();
			else if (direction.x > 0)
				moveRight();
			else if (direction.y < 0)
				moveUp();
			else
				moveDown();
		}
	}

}