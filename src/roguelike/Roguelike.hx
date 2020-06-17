package roguelike;

import xa3.Ansix;
import haxe.Timer;

import js.Node.process;

class Roguelike {
	
	final width = 80;
	final height = 50;

	final grid:Array<Array<String>> = [];

	var x:Int;
	var y:Int;

	final keyListener:KeyListener;

	public function new( keyListener:KeyListener ) {
		this.keyListener = keyListener;
	}

	public function init() {
		for( y in 0...height ) {
			grid.push( [for( x in 0...width ) " "] );
		}
		x = Std.int( width / 2 );
		y = Std.int( width / 2 );
	}

	public function start() {
		Sys.print( Ansix.clear );
		loop();
	}

	function loop() {
		Timer.delay( reset, 100 );
	}

	function reset() {
		grid[y][x] = " ";
		getInput();
	}

	function getInput() {
		switch keyListener.key {
			case 101: process.exit(); // esc
			case 117 : y = ( y + height - 1 ) % height; // up
			case 108: x = ( x + width - 1 ) % width; // left
			case 100: y = ( y + 1 ) % height;	// down
			case 114: x = ( x + 1 ) % width; // right
			default: // no-op
		}
		keyListener.key = 0;
		update();
	}

	function update() {
		render();
	}

	function render() {
		grid[y][x] = Ansix.format( "@", [Color( White )] );
		Sys.print( Ansix.resetCursor + grid.map( row -> row.join("")).join( "\n" ));
		
		loop();
	}
}