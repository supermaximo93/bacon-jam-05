package  
{
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Light extends Entity 
	{
		private var _smashed:Boolean;
		private var _room:MapRoom;
		
		public function get smashed():Boolean
		{
			return _smashed;
		}
		
		public function Light(x:int, y:int, room:MapRoom) 
		{
			super(x, y, null);
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xffff00ff);
			_smashed = false;
			_room = room;
		}
		
		public function smash():void
		{
			makeGraphic(PlayState.TILE_SIZE, PlayState.TILE_SIZE, 0xff00ffff);
			_smashed = true;
			_room.removeLight(this);
			PlayState.instance.decLightCount();
		}
		
	}

}