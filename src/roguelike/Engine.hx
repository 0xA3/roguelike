package roguelike;

import roguelike.GameStates;
import haxe.Timer;
import js.Node.process;
import roguelike.RenderFunctions.clearAll;
import roguelike.RenderFunctions.renderAll;
import Std.int;
import xa3.Ansix;

enum TCell {
	Empty;
	Player;
	Npc;
	DarkWall;
	DarkGround;
	LightWall;
	LightGround;
	Orc;
	Troll;
}

class Engine {
	
	final screenWidth = 80;
	final screenHeight = 50;
	final mapWidth = 80;
	final mapHeight = 45;

	public static final roomMaxSize = 10;
	public static final roomMinSize = 6;
	public static final maxRooms = 30;
	public static final maxMonstersPerRoom = 3;

	public static final fovAlgorithm = 0;
	public static final fovLightWalls = true;
	public static final fovRadius = 10;

	public static final cells = roguelike.skins.RoguelikeTutorials.cells;
	// public static final cells = roguelike.skins.Classic.cells;
	
	final grid:Array<Array<Cell>> = [];

	final keyListener:KeyListener;
	final entities:Array<Entity> = [];
	var player:Entity;
	var npc:Entity;
	var gameMap:GameMap;
	var fov:Fov;

	var fovRecompute = true;
	var gameState:GameStates;

	public function new( keyListener:KeyListener ) {
		this.keyListener = keyListener;
	}

	public function init() {
		
		
		for( y in 0...screenHeight ) grid.push( [for( x in 0...screenWidth ) { char: " ", color: Default, background: Default }] );

		player = new Entity( int( screenWidth / 2 ), int( screenHeight / 2 ), cells[Player], "Player", true );
		entities.push( player );

		gameMap = new GameMap( mapWidth, mapHeight );
		gameMap.makeMap( maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom );

		fov = Fov.fromGameMap( gameMap );
	}

	public function start() {
		gameState = PlayersTurn;

		Sys.print( Ansix.clear() );
		fov.update( player, fovRadius );
		
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
		
		update( dx, dy );
	}

	function update( dx:Int, dy:Int ) {
		
		 if( gameState == PlayersTurn ) {
			if( dx != 0 || dy != 0 ) {
				final destinationX = player.x + dx;
				final destinationY = player.y + dy;
				if( !gameMap.isBlocked( destinationX, destinationY )) {
					
					final target = GameMap.getBlockingEntitiesAtLocation( entities, destinationX, destinationY );
	
					switch target {
						case Entity( e ): Sys.print( 'You kick the ${e.name} in the shins, much to its annoyance!' );
						case None:
							player.move( dx, dy );
							fovRecompute = true;
					}
				}
				
				if( fovRecompute ) {
					fov.update( player, fovRadius );
					fovRecompute = false;
				}
				keyListener.key = 0;
			}
			gameState = EnemyTurn;

		} else if( gameState == EnemyTurn ) {
			for( entity in entities ) {
				if( entity != player ) {
					Sys.println( 'The ${entity.name} ponders the meaning of its existence.' );
				}
			}
			gameState = PlayersTurn;
		}

		render();
	}


	function render() {

		renderAll( grid, entities, gameMap, fov, screenWidth, screenHeight );
		Sys.print( Ansix.resetCursor() + Ansix.renderGrid2d( grid, screenWidth ) + Ansix.resetFormat() );
		
		// process.exit();
		loop();
	}

}