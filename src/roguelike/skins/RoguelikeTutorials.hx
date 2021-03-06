package roguelike.skins;

import roguelike.skins.TCell;
import asciix.Cell;

class RoguelikeTutorials {

	public static final cells:Map<TCell, Cell> = [
		Empty => 			{ code: " ".code, color: Default, background: Default },
		Player => 			{ code: "@".code, color: White, background: Transparent },
		DeadPlayer => 		{ code: "%".code, color: Red, background: Transparent },
		Orc => 				{ code: "o".code, color: BrightGreen, background: Transparent },
		Troll => 			{ code: "T".code, color: Green , background: Transparent },
		DeadEnemy => 		{ code: "%".code, color: Red, background: Transparent },
		HealingPotion => 	{ code: "!".code, color: Magenta, background: Transparent },
		LightningScroll => 	{ code: "#".code, color: Yellow, background: Transparent },

		DarkWall => 	{ code: " ".code, color: Default, background: RGB( 0, 0, 100 )},
		DarkGround => 	{ code: " ".code, color: Default, background: RGB( 50, 50, 150 )},
		LightWall => 	{ code: " ".code, color: Default, background: RGB( 130, 110, 50 )},
		LightGround => 	{ code: " ".code, color: Default, background: RGB( 200, 180, 50 )},

		Text => 			{ code: 0		, color: Default, background: Transparent },
		HealthBar =>		{ code: " ".code, color: Default, background: BrightRed },
		HealthBackground =>	{ code: " ".code, color: Default, background: Red },
		
		PlayerDeathMessage =>	{ code: 0		, color: Red, background: Transparent },
		EnemyDeathMessage => 	{ code: 0		, color: Yellow, background: Transparent },
		StatusMessage =>		{ code: 0		, color: White, background: Transparent },
		ItemAddedMessage =>		{ code: 0		, color: Blue, background: Transparent },
		ItemFalseMessage =>		{ code: 0		, color: Yellow, background: Transparent },
		ItemTrueMessage =>		{ code: 0		, color: Green, background: Transparent },
		InventoryMessage =>		{ code: 0		, color: Yellow, background: Transparent },
		WeaponHitMessage =>		{ code: 0		, color: Red, background: Transparent },
		WeaponFalseMessage =>	{ code: 0		, color: Red, background: Transparent },
	];
}