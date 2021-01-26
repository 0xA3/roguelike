package roguelike;

import asciix.Cell;
import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.MessageLog.Message;

typedef ItemResult = {
	final ?consumed:Bool;
	final ?dropped:Entity;
	final message:Message;
}

class ItemFunctions {
	
	public static function heal( entity:Entity, amount:Int ) {
		
		final results:Array<ItemResult> = [];

		if( entity.fighter.hp == entity.fighter.maxHp ) {
			results.push({ consumed: false, message: { text: 'You are already at full health', format: cells[ItemFalseMessage] } });
		} else {
			entity.fighter.heal( amount );
			results.push({ consumed: true, message: { text: 'Your wounds start to feel better!', format: cells[ItemTrueMessage] } });
		}
		return results;
	}
}