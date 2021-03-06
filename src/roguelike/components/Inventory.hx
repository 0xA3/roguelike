package roguelike.components;

import roguelike.MessageLog.Message;
import roguelike.Engine.cells;
import roguelike.skins.TCell;
import roguelike.TResult;

using xa3.ArrayUtils;

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

	public function useItem( item:Entity ) {
		
		final results:Array<TResult> = [];

		final itemComponent = item.item;

		if( itemComponent.useFunction == null ) {
			results.push( Message({ text: 'The ${item.name} cannot be used.', format: cells[ItemFalseMessage]} ));
		} else {
			final kwargs = itemComponent.kwargs;
			final itemUseResults = itemComponent.useFunction( owner, kwargs );

			for( itemUseResult in itemUseResults ) {
				switch itemUseResult {
					case ItemConsumed: removeItem( item );
					default: // no-op
				}
			}
			results.extend( itemUseResults );
		}

		return results;
	}

	public function removeItem( item:Entity ) {
		items.remove( item );
	}

	public function dropItem( item:Entity ) {
		
		final results:Array<TResult> = [];

		item.x = owner.x;
		item.y = owner.y;
		items.remove( item );

		results.push( ItemDropped( item, { text: 'You dropped the ${item.name}', format: cells[InventoryMessage] } ));

		return results;
	}
}