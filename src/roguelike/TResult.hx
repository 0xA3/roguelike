package roguelike;

import roguelike.MessageLog.Message;

enum TResult {
	Dead( e:Entity );
	ItemAdded( item:Entity, message:Message );
	ItemConsumed;
	ItemDropped( item:Entity, message:Message );
	InventoryFull( message:Message );
	Message( message:Message );
}