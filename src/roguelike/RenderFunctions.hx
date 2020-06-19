package roguelike;

import roguelike.Engine.colors;
import xa3.Ansix;

class RenderFunctions {
	
	public static function renderAll( con:Array<Array<Cell>>, entities:Array<Entity>, gameMap:GameMap, screenWidth:Int, screenHeight:Int ) {
		// Draw all the tiles in the game map
		for( y in 0...gameMap.height ) {
			for( x in 0...gameMap.width ) {
				final wall = gameMap.tiles[y][x].isBlockSight;
				con[y][x].background = wall ? colors["darkWall"] : colors["darkGround"];
			}
		}
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				drawEntity( con, entity );
			}
		}
	}

	public static function clearAll( con:Array<Array<Cell>>, entities:Array<Entity>, screenWidth:Int, screenHeight:Int ) {
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				clearEntity( con, entity );
			}
		}
	}

	public static function drawEntity( con:Array<Array<Cell>>, entity:Entity ) {
		con[entity.y][entity.x].s = entity.char;
		con[entity.y][entity.x].color = entity.color;
	}

	public static function clearEntity( con:Array<Array<Cell>>, entity:Entity ) {
		con[entity.y][entity.x].s = " ";
		con[entity.y][entity.x].background = Black;
	}
}