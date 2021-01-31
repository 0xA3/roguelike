package roguelike;

import roguelike.components.Inventory;
import asciix.Cell;
import roguelike.Engine.cells;
import roguelike.skins.TCell;

class Menus {
	
	public static function menu( con:Array<Array<Cell>>, header:String, emptyOptions:String, options:Array<String>, width:Int, screenWidth:Int, screenHeight:Int ) {
		if( options.length > 26 ) throw "Cannot have a menu with more than 26 options.";

		// calculate total height for the header (after auto-wrap) and one line per option
		final headerHeight = RenderFunctions.getTextHeight( header, width, screenHeight );
		final optionsHeight = options.length == 0 ? RenderFunctions.getTextHeight( emptyOptions, width, screenHeight ) : options.length;
		final height = headerHeight + optionsHeight;

		// create an off-screen console that represents the menu's window
		final window = RenderFunctions.createGrid( width, height );
		
		// print the header with auto-wrap
		RenderFunctions.drawTextInRect( header, 0, 0, width, height, window, cells[Text], Left );

		if( options.length == 0 ) {
			RenderFunctions.drawText( emptyOptions, 0, headerHeight , window, cells[Text], Left );
		} else {
			final a = "a".code;
			// print all the options
			for( i in 0...options.length ) {
				final text = '(${String.fromCharCode(a + i)}) ${options[i]}';
				RenderFunctions.drawText( text, 0, headerHeight + i, window, cells[Text], Left );
			}
		}
		
		// blit the contents of "window" to the root console
		final x = Std.int( screenWidth / 2 - width / 2 );
		final y = Std.int( screenHeight / 2 - height / 2 );
		RenderFunctions.blit( con, window, x, y, 1, 0.7 );
	}

	public static function inventoryMenu( con:Array<Array<Cell>>, header:String, inventory:Inventory, inventoryWidth:Int, screenWidth:Int, screenHeight:Int ) {
		// show a menu with each item of the inventory as an option
		final options = [for( entity in inventory.items ) entity.name];
		menu( con, header, 'Inventory is empty', options, inventoryWidth, screenWidth, screenHeight );
	}
}