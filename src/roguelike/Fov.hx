package roguelike;

import roguelike.mapobjects.GameMap;
import Std.int;

typedef FovCell = {
	var isVisible:Bool;
	var hasSeen:Bool;
	var isBlockSight:Bool;
}

class Fov {
	
	final gameMap:GameMap;
	final visibleGrid:Array<Array<Bool>>;
	final width:Int;
	final height:Int;

	function new( gameMap:GameMap, visibleGrid:Array<Array<Bool>>, width:Int, height:Int ) {
		this.gameMap = gameMap;
		this.visibleGrid = visibleGrid;
		this.width = width;
		this.height = height;
	}

	public static function fromGameMap( gameMap:GameMap ) {
		
		final visibleGrid:Array<Array<Bool>> = [for( y in 0...gameMap.height ) [for(x in 0...gameMap.width ) false ]];
		return new Fov( gameMap, visibleGrid, gameMap.width, gameMap.height );
	}

	public function isVisible( x:Int, y:Int ) return visibleGrid[y][x];

	public function update( entity:Entity, fovRadius:Int ) {
		
		// reset map
		for( y in 0...visibleGrid.length ) {
			for( x in 0...width ) {
				final isVisible = visibleGrid[y][x];
				if( isVisible ) {
					visibleGrid[y][x] = false;
				}
			}
		}
		visibleGrid[entity.y][entity.x] = true;

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
				visibleGrid[intY][intX] = true;
				if( gameMap.isBlockSight( intX, intY )) break;

			}
			angle += 0.18;
		}
	}
}