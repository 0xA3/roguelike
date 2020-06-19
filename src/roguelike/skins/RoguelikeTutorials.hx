package roguelike.skins;

import roguelike.Engine.TCell;
import xa3.Ansix;

class RoguelikeTutorials {

	public static final cells:Map<TCell, Cell> = [
		Empty => { char: " ", color: Default, background: Default },
		Player => { char: '@', color: White, background: Transparent },
		Orc => { char: "o", color: BrightGreen, background: Transparent },
		Troll => { char: "T", color: Green , background: Transparent },
		
		DarkWall => { char: " ", color: Default, background: RGB( 0, 0, 100 )},
		DarkGround => { char: " ", color: Default, background: RGB( 50, 50, 150 )},
		LightWall => { char: " ", color: Default, background: RGB( 130, 110, 50 )},
		LightGround => { char: " ", color: Default, background: RGB( 200, 180, 50 )}
	];
}