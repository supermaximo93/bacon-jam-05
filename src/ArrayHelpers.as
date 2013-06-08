package  
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class ArrayHelpers 
	{
		
		public static function removeElement(arr:Array, element:Object):void
		{
			for (var i:int = 0; i < arr.length; ++i)
			{
				if (arr[i] == element)
				{
					arr.splice(i, 1);
					return;
				}
			}
		}
		
		public static function sample(arr:Array):Object
		{
			return arr[int(Math.floor(FlxG.random() * arr.length))];
		}
		
		public static function new2DArray(columns:int, rows:int, initialValue:Object):Array
		{
			var arr:Array = new Array();
			for (var x:int = 0; x < columns; ++x)
			{
				var innerArr:Array = new Array();
				for (var y:int = 0; y < rows; ++y)
					innerArr.push(initialValue);
				arr.push(innerArr);
			}
			return arr;
		}
		
	}

}