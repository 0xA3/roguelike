package roguelike.components;

class Item {
	
	public final name:String;

	public var owner:Entity;
	
	public function new( name:String ) {
		this.name = name;
	}
}