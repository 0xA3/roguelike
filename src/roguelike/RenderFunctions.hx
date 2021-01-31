package roguelike;

import roguelike.Engine.cells;
import roguelike.skins.TCell;
import roguelike.mapobjects.GameMap;
import asciix.Cell;
import asciix.Color;

using StringTools;

class RenderFunctions {
	
	public static function createGrid( width:Int, height:Int ) {
		return [for( y in 0...height ) [for( x in 0...width ) { code: " ".code, color: Default, background: Default }]];
	}
	
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
		panelY:Int,
		gameState:GameState
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
					} else {
						pasteCell( con[y][x], cells[Empty] );
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

		if( gameState == InventoryUse ) {
			Menus.inventoryMenu( con,
				'Press the key next to an item to use it, or Esc to cancel.\n',
				player.inventory, 50, screenWidth, screenHeight
			);
		} else if( gameState == InventoryDrop ) {
			Menus.inventoryMenu( con,
				'Press the key next to an item to drop it, or Esc to cancel.\n',
				player.inventory, 50, screenWidth, screenHeight
			);
		}
		
	}

	public static function clearAll( grid:Array<Array<Cell>>, entities:Array<Entity>, screenWidth:Int, screenHeight:Int ) {
		for( entity in entities ) {
			if( entity.x >= 0 && entity.x < screenWidth && entity.y >= 0 && entity.y < screenHeight ) {
				clearEntity( grid, entity );
			}
		}
	}

	public static function blit( dest:Array<Array<Cell>>, src:Array<Array<Cell>>, x:Int, y:Int, foregroundAlpha = 1.0, backgroundAlpha = 1.0 ) {
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

	public static function getTextHeight( text:String, width:Int, maxHeight:Int ) {
		if( text == "" ) return 0;

		final wordGrid = splitLinesWords( text );
		final wrappedLines = wrapWordGrid( wordGrid, width );

		return Std.int( Math.min( maxHeight, wrappedLines.length ));
	}

	public static function drawTextInRect( text:String, x:Int, y:Int, width:Int, height:Int, grid:Array<Array<Cell>>, format:Cell, align:Align ) {
		if( text == "" ) return;

		final wordGrid = splitLinesWords( text );
		final wrappedLines = wrapWordGrid( wordGrid, width );
		final realHeight = Std.int( Math.min( height, wrappedLines.length ));
		for( i in 0...realHeight ) {
			drawText( wrappedLines[i], x, y + i, grid, format, align );
		}
	}

	static function splitLinesWords( text:String ) {
		final lines = text.split( "\n" );
		return lines.map( line -> line.split(" "));
	}

	static function wrapWordGrid( wordGrid:Array<Array<String>>, width:Int ) {
		final wrappedWordGrid:Array<Array<String>> = [];
		for( inputRow in wordGrid ) {
			var x = 0;
			var outputRow:Array<String> = [];
			for( word in inputRow ) {
				x += word.length;
				if( x >= width ) {
					wrappedWordGrid.push( outputRow );
					outputRow = new Array<String>();
					x = 0;
				}
				outputRow.push( word );
				x++; // space between words
			}
			wrappedWordGrid.push( outputRow );
		}
		final wrappedLines = wrappedWordGrid.map( row -> row.join(" "));
		return wrappedLines;
	}

	public static function drawText( text:String, x:Int, y:Int, grid:Array<Array<Cell>>, format:Cell, align:Align ) {
		if( y >= grid.length ) {
			trace( 'cannot draw text "$text" y position $y is out of bounds (${grid.length})' );
			return;
		}
		
		final gridWidth = grid[y].length;
		final startX = switch align {
			case Left: x;
			case Center: Std.int( Math.round( x - text.length / 2 ));
			case Right: x - text.length;
		}

		for( i in 0...text.length ) {
			final px = startX + i;
			if( px < gridWidth ) {
				setCell( grid[y][px], text.charCodeAt( i ), format.color, format.background );
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
	
	public static function pasteCell( dest:Cell, src:Cell, foregroundAlpha = 1.0, backgroundAlpha = 1.0 ) {
		if( src.code != 0 ) dest.code = src.code;
		if( src.color != Transparent ) dest.color = blendColors( dest.color, src.color, foregroundAlpha );
		if( src.background != Transparent ) dest.background = blendColors( dest.background, src.background, backgroundAlpha );

		// trace( 'char: "${src.char}" - "${dest.char}"' );
		// trace( 'color: ${Ansix.colorToString( src.color )} - ${Ansix.colorToString( dest.color )}' );
		// trace( 'background: ${Ansix.colorToString( src.background )} - ${Ansix.colorToString( dest.background )}' );
	}

	static function blendColors( destColor:Color, srcColor:Color, alpha:Float ) {
		if( alpha == 1 ) {
			return srcColor;
		} else {
			switch [destColor, srcColor] {
					case [RGB(r1, g1, b1), RGB(r2, g2, b2)]:
						return blendRGB( r1, g1, b1, r2, g2, b2, alpha );
					case [RGB(r1, g1, b1), c2]:
						final rgb2 = Engine.colorThemeColors[c2];
						return blendRGB( r1, g1, b1, rgb2[0], rgb2[1], rgb2[2], alpha );
					case [c1, RGB(r2, g2, b2)]:
						final rgb1 = Engine.colorThemeColors[c1];
						return blendRGB( rgb1[0], rgb1[1], rgb1[2], r2, g2, b2, alpha );
					case [c1, c2]:
						final rgb1 = Engine.colorThemeColors[c1];
						final rgb2 = Engine.colorThemeColors[c2];
						return blendRGB( rgb1[0], rgb1[1], rgb1[2], rgb2[0], rgb2[1], rgb2[2], alpha );

				}
			}
	}

	static function blendRGB( r1:Int, g1:Int, b1:Int, r2:Int, g2:Int, b2:Int, alpha:Float ) {
		final r = blendValue( r1, r2, alpha );
		final g = blendValue( g1, g2, alpha );
		final b = blendValue( b1, b2, alpha );
		return RGB( r, g, b );
	}

	static function blendValue( v1:Int, v2:Int, alpha = 1.0 ) return Std.int( v1 * ( 1 - alpha ) * v2 * alpha );

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