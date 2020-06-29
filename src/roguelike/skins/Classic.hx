package roguelike.skins;

import roguelike.Engine.TCell;
import asciix.Cell;

class Classic {

	public static final cells:Map<TCell, Cell> = [
		Empty => 			{ code: " ".code, color: Default, background: Default },
		Player => 			{ code: '@'.code, color: Default, background: Transparent },
		DeadPlayer => 		{ code: '%'.code, color: Default, background: Transparent },
		Orc => 				{ code: "o".code, color: Default, background: Transparent },
		Troll => 			{ code: "T".code, color: Default , background: Transparent },
		DeadEnemy => 		{ code: '%'.code, color: Default, background: Transparent },
		HealingPotion => 	{ code: "!".code, color: Default, background: Transparent },
		
		DarkWall => 	{ code: "#".code, color: Default, background: Default },
		DarkGround => 	{ code: " ".code, color: Default, background: Default },
		LightWall => 	{ code: "#".code, color: Default, background: Default },
		LightGround => 	{ code: "·".code, color: Default, background: Default },

		Text => 			{ code: 0		, color: Default, background: Transparent },
		HealthBar =>		{ code: "*".code, color: Default, background: Transparent },
		HealthBackground =>	{ code: "·".code, color: Default, background: Transparent },
		
		PlayerDeathMessage 		=> { code: 0		, color: Default, background: Transparent },
		EnemyDeathMessage 		=> { code: 0		, color: Default, background: Transparent },
		StatusMessage 			=> { code: 0		, color: Default, background: Transparent },
		ItemAddedMessage 		=> { code: 0		, color: Default, background: Transparent },
		InventoryMessage 	=> { code: 0		, color: Default, background: Transparent }
	];
}