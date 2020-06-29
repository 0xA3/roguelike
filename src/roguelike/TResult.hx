package roguelike;

import roguelike.components.Item;
import roguelike.MessageLog.Message;

enum TResult {
	Dead( e:Entity );
	Message( message:Message );
	ItemAdded( item:Entity, message:Message );
	InventoryFull( message:Message );
}