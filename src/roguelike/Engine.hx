package roguelike;

import astar.Graph;
import astar.MovementDirection;
import astar.types.Direction;
import haxe.Timer;
import js.Node.process;
import roguelike.components.Fighter;
import roguelike.GameStates;
import roguelike.mapobjects.GameMap;
import roguelike.RenderFunctions.clearAll;
import roguelike.RenderFunctions.renderAll;
import Std.int;
import xa3.Ansix;

using xa3.ArrayUtils;

enum TCell {
	Empty;
	Player;
	DeadPlayer;
	Orc;
	Troll;
	DeadEnemy;
	
	DarkWall;
	DarkGround;
	LightWall;
	LightGround;

	Text;
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
	var playerTurnResults:Array<TResult> = [];

	public function new( keyListener:KeyListener ) {
		this.keyListener = keyListener;
	}

	public function init() {
		
		for( y in 0...screenHeight ) grid.push( [for( x in 0...screenWidth ) { code: " ".code, color: Default, background: Default }] );

		final fighterComponent = new Fighter( 30, 2, 5 );
		player = new Entity( int( screenWidth / 2 ), int( screenHeight / 2 ), cells[Player], "Player", true, RenderOrder.ACTOR , fighterComponent );
		entities.push( player );

		final movementDirection = EightWay;
		final graph = new Graph( mapWidth, mapHeight, movementDirection );
		final sqr2 = Math.sqrt( 2 );
		final costs = [	0 => [N => 1, W => 1, S => 1, E => 1, NW => sqr2, SW => sqr2, SE => sqr2, NE => sqr2 ]];
		graph.setCosts( costs );

		gameMap = new GameMap( mapWidth, mapHeight, graph );
		gameMap.makeMap( maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom );
		

		fov = Fov.fromGameMap( gameMap );
	}

	public function start() {
		
		gameState = PlayersTurn;

		Sys.print( Ansix.clear() );
		fov.update( player, fovRadius );
		render();
	
	}
	
	function render() {
		renderAll( grid, entities, player, gameMap, fov, screenWidth, screenHeight );
		Sys.print( Ansix.resetCursor() + Ansix.renderGrid2d( grid, screenWidth ) + Ansix.resetFormat() );
		clearAll( grid, entities, screenWidth, screenHeight );
		// process.exit();
		loop();
	}

	function loop() {
		Timer.delay( branch, 16 );
	}

	function branch() {
		playerTurnResults = [];
		switch gameState {
			case PlayersTurn: getInput();
			case EnemyTurn: updateEnemy();
			case PlayerDead:
				Sys.println( 'The End' );
				process.exit();
		}
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
			default:
				loop();
				return;
		}
		
		updatePlayer( dx, dy );
	}

	function updatePlayer( dx:Int, dy:Int ) {
		// Sys.println( 'updatePlayer' );
		if( dx != 0 || dy != 0 ) {
			final destinationX = player.x + dx;
			final destinationY = player.y + dy;
			if( !gameMap.isBlocked( destinationX, destinationY )) {
				
				final target = roguelike.Entity.getBlockingEntitiesAtLocation( entities, destinationX, destinationY );

				switch target {
					case Entity( target ):
						final attackResults = player.fighter.attack( target );
						playerTurnResults.extend( attackResults );
					case None:
						player.move( dx, dy );
						fovRecompute = true;
				}
			}
			
			if( fovRecompute ) {
				fov.update( player, fovRadius );
				fovRecompute = false;
			}
		}
		keyListener.key = 0;
		gameState = EnemyTurn;

		for( playerTurnResult in playerTurnResults ) {
			switch playerTurnResult {
				case Message( s ): Sys.println( s );
				case Dead( deadEntity ):
					if( deadEntity == player ) {
						final deathResult = DeathFunctions.killPlayer( player, cells[DeadPlayer] );
						gameState = deathResult.state;
						Sys.println( deathResult.message );
					} else {
						final deathMessage = DeathFunctions.killMonster( deadEntity, cells[DeadEnemy] );
						Sys.println( deathMessage );
					}
			}
		}

		render();
	}

	function updateEnemy() {
		// Sys.println( 'updateEnemy' );
		var nextGameState = PlayersTurn;
		for( entity in entities ) {
			if( entity.ai != null ) {
				// Sys.println( 'The ${entity.name} ponders the meaning of its existence.' );
				final enemyTurnResults = entity.ai.takeTurn( player, fov, gameMap, entities );

				for( enemyTurnResult in enemyTurnResults ) {
					switch enemyTurnResult {
						case Message( s ): Sys.println( s );
						case Dead( deadEntity ):
							if( deadEntity == player ) {
								final deathResult = DeathFunctions.killPlayer( player, cells[DeadPlayer] );
								nextGameState = deathResult.state;
								Sys.println( deathResult.message );
							} else {
								final deathMessage = DeathFunctions.killMonster( deadEntity, cells[DeadEnemy] );
								Sys.println( deathMessage );
							}
					}
				}
			}
		}
		gameState = nextGameState;
		render();
	}


}