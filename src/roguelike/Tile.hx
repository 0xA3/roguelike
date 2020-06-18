package roguelike;

class Tile {
	// A tile on a map. It may or may not be blocked, and may or may not block sight.
	
	public var isBlocked:Bool;
	public var isBlockSight:Bool;
	
	public function new( isBlocked:Bool, ?isBlockSight:Bool ) {
		this.isBlocked = isBlocked;
		
		// By default, if a tile blocks entities, it also blocks sight
		this.isBlockSight = isBlockSight == null ? isBlocked : isBlockSight;
	}

}