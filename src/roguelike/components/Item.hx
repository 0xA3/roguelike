package roguelike.components;

import roguelike.ItemFunctions.ItemResult;

class Item {
	
	public var owner:Entity;
	
	public final useFunction:( Entity, Int )->Array<ItemResult>;
	public final kwargs:Int;

	public function new( useFunction:( Entity, Int )->Array<ItemResult>, kwargs:Int ) {
		this.useFunction = useFunction;
		this.kwargs = kwargs;
	}
}