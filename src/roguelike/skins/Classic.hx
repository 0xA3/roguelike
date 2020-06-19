package roguelike.skins;

import roguelike.Engine.TCell;
import xa3.Ansix;

class Classic {

	public static final cells:Map<TCell, Cell> = [
		Empty => { char: " ", color: Default, background: Default },
		Player => { char: '@', color: White, background: Transparent },
		Npc => { char: '@', color: Yellow, background: Transparent },
		DarkWall => { char: "#", color: Default, background: Default },
		DarkGround => { char: " ", color: Default, background: Default },
		LightWall => { char: "#", color: Default, background: Default },
		LightGround => { char: "·", color: Default, background: Default }
	];
}