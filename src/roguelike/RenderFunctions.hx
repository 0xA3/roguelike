package roguelike;

import roguelike.Engine.TCell;
import roguelike.Engine.cells;
import xa3.Ansix;

class RenderFunctions {
	
	public static function renderAll( grid:Array<Array<Cell>>, entities:Array<Entity>, gameMap:GameMap, fov:Fov, screenWidth:Int, screenHeight:Int ) {
		// Draw all the tiles in the game map
		for( y in 0...gameMap.height ) {
			for( x in 0...gameMap.width ) {
				final isVisible = fov.isVisible( x, y );
				final isWall = gameMap.tiles[y][x].isBlockSight;
				if( isVisible ) {
					grid[y][x] = isWall ? cells[LightWall] : cells[LightGround];
					gameMap.setExplored( x, y );
				} else {
					if( gameMap.isExplored( x, y )) {
						grid[y][x] = isWall ? cells[DarkWall] : cells[DarkGround];
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
		if( fov.isVisible( entity.x, entity.y )) {
			grid[entity.y][entity.x] = entity.avatar;
		}
	}

	public static function clearEntity( grid:Array<Array<Cell>>, entity:Entity ) {
		grid[entity.y][entity.x] = cells[Empty];
	}
}