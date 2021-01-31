package roguelike;

import asciix.Ansix;
import asciix.Cell;
import astar.Graph;
import astar.MovementDirection;
import astar.types.Direction;
import haxe.Timer;
import roguelike.components.Fighter;
import roguelike.components.Inventory;
import roguelike.GameState;
import roguelike.mapobjects.GameMap;
import roguelike.RenderFunctions.clearAll;
import roguelike.RenderFunctions.renderAll;
import roguelike.skins.TCell;
import roguelike.TResult;
import Std.int;

#if nodejs
import js.Node.process;
#end

using xa3.ArrayUtils;

class Engine {
	
	public static final randomInit = 0;
	public static final mapSeed = 1;
	public static final itemsSeed = 1;
	public static final enemiesSeed = 2;

	static final screenWidth = 80;
	static final screenHeight = 50;
	static final barWidth = 20;
	static final panelHeight = 7;
	static final panelY = screenHeight - panelHeight;
	static final mapWidth = 80;
	static final mapHeight = 43;
	static final messageX = barWidth + 2;
	static final messageWidth = screenWidth + barWidth - 2;
	static final messageHeight = panelHeight - 1;

	public static final roomMaxSize = 10;
	public static final roomMinSize = 6;
	public static final maxRooms = 30;
	public static final maxMonstersPerRoom = 3;
	public static final maxItemsPerRoom = 20;

	public static final fovAlgorithm = 0;
	public static final fovLightWalls = true;
	public static final fovRadius = 10;

	public static final OrcHitPoints = 10;
	public static final OrcDefense = 0;
	public static final OrcPower = 3;

	public static final TrollHitPoints = 16;
	public static final TrollDefense = 1;
	public static final TrollPower = 4;

	public static final cells = roguelike.skins.RoguelikeTutorials.cells;
	public static final colorThemeColors = asciix.colorThemes.WindowsConsole.colors;

	// public static final cells = roguelike.skins.Classic.cells;

	var con:Array<Array<Cell>> = [];
	var panel:Array<Array<Cell>> = [];

	final keyListener:KeyListener;
	final entities:Array<Entity> = [];
	var player:Entity;
	var npc:Entity;
	var gameMap:GameMap;
	var fov:Fov;
	var messageLog:MessageLog;

	var fovRecompute = true;
	var gameState = PlayersTurn;
	// var gameStateString = "";
	var previousGameState = PlayersTurn;
	var playerTurnResults:Array<TResult> = [];

	public function new( keyListener:KeyListener ) {
		this.keyListener = keyListener;
	}

	public function init() {

		xa3.MTRandom.initializeRandGenerator( randomInit );

		con = RenderFunctions.createGrid( screenWidth, screenHeight );
		panel = RenderFunctions.createGrid( screenWidth, panelHeight );

		final fighterComponent = new Fighter( 30, 2, 5 );
		final inventoryComponent = new Inventory( 26 );
		player = new Entity( int( screenWidth / 2 ), int( screenHeight / 2 ), cells[Player], "Player", true, RenderOrder.ACTOR , fighterComponent, inventoryComponent );
		entities.push( player );

		final movementDirection = EightWay;
		final graph = new Graph( mapWidth, mapHeight, movementDirection );
		final sqr2 = Math.sqrt( 2 );
		final costs = [	0 => [N => 1, W => 1, S => 1, E => 1, NW => sqr2, SW => sqr2, SE => sqr2, NE => sqr2 ]];
		graph.setCosts( costs );

		gameMap = new GameMap( mapWidth, mapHeight, graph );
		
		fov = Fov.fromGameMap( gameMap );
		
		gameMap.makeMap( fov, maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities, maxMonstersPerRoom, maxItemsPerRoom );


		messageLog = new MessageLog( messageX, messageWidth, messageHeight );
	}

	public function start() {
		
		Sys.print( Ansix.clear() );
		fov.update( player, fovRadius );
		render();
	
	}
	
	function render() {
		clearAll( con, entities, screenWidth, screenHeight );
		renderAll( con, panel, entities, player, gameMap, fov, messageLog, screenWidth, screenHeight, barWidth, panelHeight, panelY, gameState );
		Sys.print( Ansix.resetCursor() + Ansix.renderGrid2d( con, screenWidth ) + Ansix.resetFormat() );
		loop();
	}

	function loop() {
		Timer.delay( handleGameState, 16 );
	}

	function handleGameState() {
		
		// gameStateString = switch gameState {
		// 	case PlayersTurn: "PlayersTurn";
		// 	case EnemyTurn: "EnemyTurn";
		// 	case PlayerDead: "PlayerDead";
		// 	case InventoryUse: "InventoryUse";
		// 	case InventoryDrop: "InventoryDrop";
		// }

		playerTurnResults = [];
		switch gameState {
			case PlayersTurn: handlePlayerTurnKeys();
			case EnemyTurn: updateEnemy();
			case PlayerDead: handlePlayerDeadKeys();
			case InventoryUse, InventoryDrop: handleInventoryKeys();
		}
		keyListener.key = "";
	}

	function handlePlayerTurnKeys() {
		// if( keyListener.key != "" ) trace( keyListener.key + "               " );
		switch keyListener.key {
			case "escape": // esc
				#if nodejs
				process.exit();
				#end
			case "up": updatePlayer( Move( 0, -1 )); // up
			case "left": updatePlayer( Move( -1, 0 )); // left
			case "down": updatePlayer( Move( 0, 1 )); // down
			case "right": updatePlayer( Move( 1, 0 )); // right
			case "g": updatePlayer( Pickup );
			case "i":
				previousGameState = gameState;
				gameState = InventoryUse;
				render();
			case "d":
				previousGameState = gameState;	
				gameState = InventoryDrop;
				render();
			default:
				loop();
		}
	}

	function handlePlayerDeadKeys() {
		switch keyListener.key {
			case "escape": // esc
				#if nodejs
				process.exit();
				#end
			case "i":
				previousGameState = gameState;
				gameState = InventoryUse;
				render();
			case "d":
				previousGameState = gameState;	
				gameState = InventoryDrop;
				render();
			default:
				loop();
				return;
	
		}

	}

	function handleInventoryKeys() {
		// if( keyListener.key != "" ) trace( keyListener.key + "               " );
		switch keyListener.key {
			case "escape": // esc
				// trace( 'esc - set gameState to $previousGameState' );
				gameState = previousGameState;
				render();
			default:
				if( keyListener.key.length == 1 ) {
					final index = keyListener.key.charCodeAt( 0 ) - "a".code;
					if( index >= 0 && index < player.inventory.items.length ) {
						switch gameState {
							case InventoryUse:  playerTurnResults.extend( player.inventory.useItem( player.inventory.items[index] ));
							case InventoryDrop: playerTurnResults.extend( player.inventory.dropItem( player.inventory.items[index] ));
							default: // no-op
						}
						executeTurnResults( playerTurnResults );
					}	
				} else {
					loop();
				}
		}
	}
	
	function updatePlayer( action:Action ) {
		// Sys.println( 'updatePlayer' );
		switch action {
			case Move( dx, dy ):
				final destinationX = player.x + dx;
				final destinationY = player.y + dy;
				if( !gameMap.isBlocked( destinationX, destinationY )) {
					
					final target = roguelike.Entity.getBlockingEntitiesAtLocation( entities, destinationX, destinationY );

					switch target {
						case Entity( target ):
							if( target.fighter != null ) {
								final attackResults = player.fighter.attack( target );
								playerTurnResults.extend( attackResults );
							}
						case None:
							player.move( dx, dy );
							fovRecompute = true;
					}
				}
				
				if( fovRecompute ) {
					fov.update( player, fovRadius );
					fovRecompute = false;
				}
			case Pickup:
				var isOnItem = false;
				for( entity in entities ) {
					if( entity.item != null && entity.x == player.x && entity.y == player.y ) {
						final pickupResults = player.inventory.addItem( entity );
						playerTurnResults.extend( pickupResults );
						isOnItem = true;
						break;
					}
				}
				if( !isOnItem ) messageLog.addMessage({ text: 'There is nothing here to pick up.', format: cells[InventoryMessage] });
		}
		gameState = EnemyTurn;

		executeTurnResults( playerTurnResults );
	}

	function updateEnemy() {
		// Sys.println( 'updateEnemy' );
		var nextGameState = PlayersTurn;
		for( entity in entities ) {
			if( entity.ai != null ) {
				// Sys.println( 'The ${entity.name} ponders the meaning of its existence.' );
				final enemyTurnResults = entity.ai.takeTurn( player, fov, gameMap, entities );
				executeTurnResults( enemyTurnResults );
			}
		}
		gameState = nextGameState;
		render();
	}

	function executeTurnResults( turnResults:Array<TResult> ) {
		
		for( playerTurnResult in turnResults ) {
			switch playerTurnResult {
				case Dead( deadEntity ):
					if( deadEntity == player ) {
						final deathResult = DeathFunctions.killPlayer( player, cells[DeadPlayer] );
						gameState = deathResult.state;
						messageLog.addMessage( deathResult.message );
					} else {
						final deathMessage = DeathFunctions.killMonster( deadEntity, cells[DeadEnemy] );
						messageLog.addMessage( deathMessage );
					}
				case ItemAdded( item, message ):
					entities.remove( item );
					messageLog.addMessage( message );
				case ItemConsumed: gameState = EnemyTurn;
				case ItemDropped( item, message ):
					entities.push( item );
					messageLog.addMessage( message );
				case InventoryFull( message ): messageLog.addMessage( message );
				case Message( message ): messageLog.addMessage( message );
			}
		}
		render();
	}

}