package roguelike.components;

import roguelike.MessageLog.Message;
import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.TResult;

class Inventory {
	
	public final capacity:Int;
	public final items:Array<Entity> = [];

	public var owner:Entity;
	
	public function new( capacity:Int ) {
		this.capacity = capacity;
	}

	public function addItem( item:Entity ) {
		final results:Array<TResult> = [];

		if( items.length >= capacity ) {
			final message:Message = { text: 'You cannot carry any more. Your inventory is full', format: cells[InventoryMessage] };
			results.push( InventoryFull( message ));
		} else {
			final message:Message = { text: 'You pick up the ${item.name}', format: cells[ItemAddedMessage] };
			items.push( item );
			results.push( ItemAdded( item, message ));
		}
		return results;
	}
}