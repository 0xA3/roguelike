package roguelike.components;

enum Kwargs {
	HealingPotion( amount:Int );
	Lightning(
		entities:Array<Entity>,
		fovMap:Fov,
		damage:Int,
		maximumRange:Int
	);
}

class Item {
	
	public var owner:Entity;
	
	public final useFunction:( Entity, Kwargs )->Array<TResult>;
	public final kwargs:Kwargs;

	public function new( useFunction:( Entity, Kwargs )->Array<TResult>, kwargs:Kwargs ) {
		this.useFunction = useFunction;
		this.kwargs = kwargs;
	}
}