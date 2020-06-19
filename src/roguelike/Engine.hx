package roguelike;

import haxe.Timer;
import js.Node.process;
import roguelike.RenderFunctions.clearAll;
import roguelike.RenderFunctions.renderAll;
import Std.int;
import xa3.Ansix;

enum TTile {
	DarkWall;
	DarkGround;
	LightWall;
	LightGround;
}

class Engine {
	
	final screenWidth = 80;
	final screenHeight = 50;
	final mapWidth = 80;
	final mapHeight = 45;

	public static final roomMaxSize = 10;
	public static final roomMinSize = 6;
	public static final maxRooms = 30;

	public static final fovAlgorithm = 0;
	public static final fovLightWalls = true;
	public static final fovRadius = 10;

	public static final tiles = [
		DarkWall => RGB( 0, 0, 100 ),
		DarkGround => RGB( 50, 50, 150 ),
		LightWall => RGB( 130, 110, 50 ),
		LightGround => RGB( 200, 180, 50 )
	];
	
	final grid:Array<Array<Cell>> = [];

	final keyListener:KeyListener;
	final entities:Array<Entity> = [];
	var player:Entity;
	var npc:Entity;
	var gameMap:GameMap;
	var fov:Fov;

	var fovRecompute = true;

	public function new( keyListener:KeyListener ) {
		this.keyListener = keyListener;
	}

	public function init() {
		for( y in 0...screenHeight ) {
			grid.push( [for( x in 0...screenWidth ) { s: " ", color: White, background: Black }] );
		}

		player = new Entity( int( screenWidth / 2 ), int( screenHeight / 2 ), '@', White );
		npc = new Entity( int( screenWidth / 2 - 5), int( screenHeight / 2 ), '@', Yellow );
		entities.push( player );
		entities.push( npc );

		gameMap = new GameMap( mapWidth, mapHeight );
		gameMap.makeMap( maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player );

		fov = Fov.fromGameMap( gameMap );
	}

	public function start() {
		Sys.print( Ansix.clear() );
		loop();
	}

	function loop() {
		Timer.delay( reset, 16 );
	}

	function reset() {
		clearAll( grid, entities, screenWidth, screenHeight );
		getInput();
	}

	function getInput() {
		var dx = 0;
		var dy = 0;
		switch keyListener.key {
			case 101: process.exit(); // esc
			case 117 : dy = -1; // up
			case 108: dx = -1; // left
			case 100: dy = 1;	// down
			case 114: dx = 1; // right
			default: // no-op
		}
		keyListener.key = 0;
		update( dx, dy );
	}

	function update( dx:Int, dy:Int ) {
		if( !gameMap.isBlocked( player.x + dx, player.y + dy )) {
			player.move( dx, dy );
			fovRecompute = true;
		}
		render();
	}


	function render() {
		if( fovRecompute ) {
			fov.update( player, fovRadius );
			fovRecompute = false;
		}
		renderAll( grid, entities, gameMap, fov, screenWidth, screenHeight );
		Sys.print( Ansix.resetCursor() + Ansix.renderGrid2d( grid, screenWidth ) + Ansix.resetFormat() );
		
		// process.exit();
		loop();
	}

}