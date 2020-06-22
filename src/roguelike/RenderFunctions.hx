package roguelike;

import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.mapobjects.GameMap;
import asciix.Cell;
import asciix.Color;

using StringTools;

class RenderFunctions {
	
	static function renderBar( panel:Array<Array<Cell>>, x:Int, y:Int, totalWidth:Int, name:String, value:Int, maximum:Int, barColor:Color, backColor:Color ) {

		drawRect( panel, x, y, totalWidth, 1, cells[HealthBackground] );

		final barWidth = Std.int( value / maximum * totalWidth );
		if( barWidth > 0 ) drawRect( panel, x, y, barWidth, 1, cells[HealthBar] );

		drawText( '$name $value/$maximum', Std.int( x + totalWidth / 2 ), y, panel, cells[Text], Center );
	}

	public static function renderAll(
		con:Array<Array<Cell>>,
		panel:Array<Array<Cell>>,
		entities:Array<Entity>,
		player:Entity,
		gameMap:GameMap,
		fov:Fov,
		messageLog:MessageLog,
		screenWidth:Int,
		screenHeight:Int,
		barWidth:Int,
		panelHeight:Int,
		panelY:Int
	) {
		// Draw all the tiles in the game map
		for( y in 0...gameMap.height ) {
			for( x in 0...gameMap.width ) {
				final isVisible = fov.isVisible( x, y );
				final isWall = gameMap.tiles[y][x].isBlocked;
				if( isVisible ) {
					pasteCell( con[y][x], isWall ? cells[LightWall] : cells[LightGround] );
					gameMap.setExplored( x, y );
				} else {
					if( gameMap.isExplored( x, y )) {
						pasteCell( con[y][x], isWall ? cells[DarkWall] : cells[DarkGround] );
					}
				}
			}
		}

		entities.sort(( a, b ) -> a.renderOrder - b.renderOrder );

		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				drawEntity( con, fov, entity );
			}
		}

		clearGrid( panel );
		
		for( i in 0...messageLog.messages.length ) {
			final message = messageLog.messages[i];
			final y = i + 1;
			drawText( message.text, 0, y, panel, message.format, Left );
		}
		renderBar( panel, 0, 0, barWidth, 'HP', player.fighter.hp, player.fighter.maxHp, BrightRed, Red );
		// trace( panel.map( row -> row.map( cell -> String.fromCharCode( cell.code )).join("") ).join( "\n") );
		blit( con, panel, 0, panelY );

	}

	public static function clearAll( grid:Array<Array<Cell>>, entities:Array<Entity>, screenWidth:Int, screenHeight:Int ) {
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				clearEntity( grid, entity );
			}
		}
	}

	static function blit( dest:Array<Array<Cell>>, src:Array<Array<Cell>>, x:Int, y:Int ) {
		final destHeight = dest.length;
		final destWidth = dest.length == 0 ? 0 : dest[0].length;
		final srcHeight = src.length;
		final srcWidth = src.length == 0 ? 0 : src[0].length;
		final maxX = destWidth;
		final maxY = destHeight;
		for( py in 0...srcHeight ) {
			final destY = y + py;
			if( destY >= maxY ) break;
			for( px in 0...srcWidth ) {
				final destX = x + px;
				if( destX >= maxX ) break;
				pasteCell( dest[destY][destX], src[py][px] );
			}
		}
	}

	static function clearGrid( grid:Array<Array<Cell>> ) {
		for( y in 0...grid.length ) {
			final row = grid[y];
			for( x in 0...row.length ) {
				setCell( grid[y][x], " ".code );
			}
		}
	}

	public static function drawText( s:String, x:Int, y:Int,  grid:Array<Array<Cell>>, format:Cell, align:Align ) {
		final gridWidth = grid[y].length;
		final startX = switch align {
			case Left: x;
			case Center: Std.int( Math.round( x - s.length / 2 ));
			case Right: x - s.length;
		}

		for( i in 0...s.length ) {
			final px = startX + i;
			if( px < gridWidth ) {
				setCell( grid[y][px], s.charCodeAt( i ), format.color, format.background );
			}
		}
	}

	public static function drawRect( grid:Array<Array<Cell>>, x:Int, y:Int, width:Int, height:Int, cell:Cell ) {
		for( py in y...y + height ) {
			for( px in x...x + width ) {
				pasteCell( grid[py][px], cell );
			}
		}
	}

	public static function drawEntity( grid:Array<Array<Cell>>, fov:Fov, entity:Entity ) {
		// trace( 'drawEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( entity.avatar )}' );
		if( fov.isVisible( entity.x, entity.y )) {
			pasteCell( grid[entity.y][entity.x], entity.avatar );
		}
		// trace( 'drawEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( grid[entity.y][entity.x] )}' );
	}

	public static function clearEntity( grid:Array<Array<Cell>>, entity:Entity ) {
		pasteCell( grid[entity.y][entity.x], cells[Empty] );
		// trace( 'clearEntity [${entity.x}:${entity.y}] ${Ansix.cellToString( grid[entity.y][entity.x] )}' );
	}
	
	public static function pasteCell( dest:Cell, src:Cell ) {
		if( src.code != 0 ) dest.code = src.code;
		if( src.color != Transparent ) dest.color = src.color;
		if( src.background != Transparent ) dest.background = src.background;

		// trace( 'char: "${src.char}" - "${dest.char}"' );
		// trace( 'color: ${Ansix.colorToString( src.color )} - ${Ansix.colorToString( dest.color )}' );
		// trace( 'background: ${Ansix.colorToString( src.background )} - ${Ansix.colorToString( dest.background )}' );
	}

	static function setCell( dest:Cell, code:Int, color = Default, background = Default ) {
		if( code != 0 ) dest.code = code;
		if( color != Transparent ) dest.color = color;
		if( background != Transparent ) dest.background = background;
	}

}

enum Align {
	Left;
	Center;
	Right;
}