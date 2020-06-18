package roguelike;

class GameMap {
	
	public final width:Int;
	public final height:Int;
	public final tiles:Array<Array<Tile>>;

	public function new( width:Int, height:Int ) {
		this.width = width;
		this.height = height;
		tiles = initializeTiles();
	}

	public function initializeTiles() {
		final tiles = [for( y in 0...height ) [for( x in 0...width ) new Tile( false )]];
		tiles[30][22].isBlocked = true;
		tiles[30][22].isBlockSight = true;
		tiles[31][22].isBlocked = true;
		tiles[31][22].isBlockSight = true;
		tiles[32][22].isBlocked = true;
		tiles[32][22].isBlockSight = true;

		return tiles;
	}
}