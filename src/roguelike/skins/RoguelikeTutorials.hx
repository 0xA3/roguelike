package roguelike.skins;

import roguelike.Engine.TCell;
import xa3.Ansix;

class RoguelikeTutorials {

	public static final cells:Map<TCell, Cell> = [
		Empty => 		{ code: " ".code, color: Default, background: Default },
		Player => 		{ code: "@".code, color: White, background: Transparent },
		DeadPlayer => 	{ code: "%".code, color: Red, background: Transparent },
		Orc => 			{ code: "o".code, color: BrightGreen, background: Transparent },
		Troll => 		{ code: "T".code, color: Green , background: Transparent },
		DeadEnemy => 	{ code: "%".code, color: Red, background: Transparent },
		
		DarkWall => 	{ code: " ".code, color: Default, background: RGB( 0, 0, 100 )},
		DarkGround => 	{ code: " ".code, color: Default, background: RGB( 50, 50, 150 )},
		LightWall => 	{ code: " ".code, color: Default, background: RGB( 130, 110, 50 )},
		LightGround => 	{ code: " ".code, color: Default, background: RGB( 200, 180, 50 )},

		Text => 		{ code: 0		, color: Default, background: Transparent }
	];
}