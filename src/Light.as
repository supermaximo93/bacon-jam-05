package  
{
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Light extends Entity 
	{
		[Embed(source="../assets/images/light.png")] private var sprite:Class;
		
		private var _smashed:Boolean;
		private var _room:MapRoom;
		
		public function get smashed():Boolean
		{
			return _smashed;
		}
		
		override public function get canScaleUp():Boolean 
		{
			return !_smashed;
		}
		
		public function Light(x:int, y:int, room:MapRoom) 
		{
			super(x, y, null);
			loadGraphic(sprite, true, false, 8, 8);
			frame = 0;
			_smashed = false;
			_room = room;
		}
		
		public function smash():void
		{
			_smashed = true;
			_room.removeLight(this);
			frame = 1;
			PlayState.instance.decLightCount();
		}
		
	}

}