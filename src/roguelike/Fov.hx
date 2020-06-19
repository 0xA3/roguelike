package roguelike;

import Std.int;

typedef FovCell = {
	var isVisible:Bool;
	var hasSeen:Bool;
	var isBlockSight:Bool;
}

class Fov {
	
	final map:Array<Array<FovCell>>;
	final width:Int;
	final height:Int;

	function new( map:Array<Array<FovCell>>, width:Int, height:Int ) {
		this.map = map;
		this.width = width;
		this.height = height;
	}

	public static function fromGameMap( gameMap:GameMap ) {
		
		final map:Array<Array<FovCell>> = [for( y in 0...gameMap.height ) [for(x in 0...gameMap.width ) { isVisible: false, hasSeen: false, isBlockSight: gameMap.isBlockSight( x, y ) } ]];
		return new Fov( map, gameMap.width, gameMap.height );
	}

	public function isVisible( x:Int, y:Int ) return map[y][x].isVisible;
	public function hasSeen( x:Int, y:Int ) return map[y][x].hasSeen;

	public function update( entity:Entity, fovRadius:Int ) {
		
		// reset map
		for( y in 0...map.length ) {
			for( x in 0...width ) {
				final cell = map[y][x];
				if( cell.isVisible ) {
					cell.hasSeen = true;
					cell.isVisible = false;
				}
			}
		}

		map[entity.y][entity.x].isVisible = true;

		var angle = 0.0;
		while( angle < 360 ) {
			var dist = 0;
			var x = entity.x + 0.5;
			var y = entity.y + 0.5;
			var xMove = Math.cos( angle );
			var yMove = Math.sin( angle );

			while( true ) {
				x += xMove;
				y += yMove;
				dist++;
				if( dist >= fovRadius || x < 0 || x >= width || y < 0 || y >= height ) break;
				final intX = int( x );
				final intY = int( y );
				map[intY][intX].isVisible = true;
				if( map[intY][intX].isBlockSight ) break;

			}
			angle += 0.18;
		}
	}
}