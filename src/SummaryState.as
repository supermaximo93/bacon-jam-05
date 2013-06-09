package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class SummaryState extends FlxState 
	{		
		private var scoreText:FlxText;
		private var movesText:FlxText;
		private var comboText:FlxText;
		private var consecutiveBeatsText:FlxText;
		
		public function SummaryState(score:int, moves:int, combo:int, consecutiveBeats:int)
		{
			scoreText = new FlxText(5, 5, 200, "Score: " + score.toString());
			movesText = new FlxText(5, 20, 200, "Moves: " + moves.toString());
			comboText = new FlxText(5, 35, 200, "Highest combo: " + combo.toString());
			consecutiveBeatsText = new FlxText(5, 50, 200, "Highest beat combo: " + consecutiveBeats.toString());
		}
		
		override public function create():void 
		{
			add(scoreText);
			add(movesText);
			add(comboText);
			add(consecutiveBeatsText);
			FlxG.playMusic(SongManager.menuMusic);
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
				FlxG.switchState(new MenuState());
		}
		
	}

}