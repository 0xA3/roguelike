package roguelike;

import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.mapobjects.GameMap;
import xa3.Ansix;

class RenderFunctions {
	
	public static function renderAll( grid:Array<Array<Cell>>, entities:Array<Entity>, gameMap:GameMap, fov:Fov, screenWidth:Int, screenHeight:Int ) {
		// Draw all the tiles in the game map
		for( y in 0...gameMap.height ) {
			for( x in 0...gameMap.width ) {
				final isVisible = fov.isVisible( x, y );
				final isWall = gameMap.tiles[y][x].isBlocked;
				if( isVisible ) {
					drawCell( grid[y][x], isWall ? cells[LightWall] : cells[LightGround] );
					gameMap.setExplored( x, y );
				} else {
					if( gameMap.isExplored( x, y )) {
						drawCell( grid[y][x], isWall ? cells[DarkWall] : cells[DarkGround] );
					}
				}
			}
		}
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				drawEntity( grid, fov, entity );
			}
		}
	}

	public static function clearAll( grid:Array<Array<Cell>>, entities:Array<Entity>, screenWidth:Int, screenHeight:Int ) {
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				clearEntity( grid, entity );
			}
		}
	}

	public static function drawEntity( grid:Array<Array<Cell>>, fov:Fov, entity:Entity ) {
		// trace( 'drawEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( entity.avatar )}' );
		if( fov.isVisible( entity.x, entity.y )) {
			drawCell( grid[entity.y][entity.x], entity.avatar );
		}
		// trace( 'drawEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( grid[entity.y][entity.x] )}' );
	}

	public static function clearEntity( grid:Array<Array<Cell>>, entity:Entity ) {
		drawCell( grid[entity.y][entity.x], cells[Empty] );
		// trace( 'clearEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( grid[entity.y][entity.x] )}' );
	}
	
	public static function drawCell( dest:Cell, src:Cell ) {
		dest.char = src.char;
		if( src.color != Transparent ) dest.color = src.color;
		if( src.background != Transparent ) dest.background = src.background;

		// trace( 'char: "${src.char}" - "${dest.char}"' );
		// trace( 'color: ${Ansix.colorToString( src.color )} - ${Ansix.colorToString( dest.color )}' );
		// trace( 'background: ${Ansix.colorToString( src.background )} - ${Ansix.colorToString( dest.background )}' );
	}

}
