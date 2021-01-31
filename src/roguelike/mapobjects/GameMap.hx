package roguelike.mapobjects;

import astar.Graph;
import Math.max;
import Math.min;
import roguelike.components.BasicMonster;
import roguelike.components.Fighter;
import roguelike.components.Item;
import roguelike.Engine.cells;
import roguelike.skins.TCell;
import Std.int;
import xa3.MTRandom;

using Lambda;

class GameMap {
	
	public final width:Int;
	public final height:Int;
	final graph:Graph;
	public final tiles:Array<Array<Tile>>;

	public function new( width:Int, height:Int, graph:Graph ) {
		this.width = width;
		this.height = height;
		this.graph = graph;
		tiles = initializeTiles();
	}

	public function initializeTiles() {
		final tiles = [for( y in 0...height ) [for( x in 0...width ) new Tile( true )]];
		return tiles;
	}

	public function isBlocked( x:Int, y:Int ) return tiles[y][x].isBlocked;
	public function isBlockSight( x:Int, y:Int ) return tiles[y][x].isBlockSight;
	public function isExplored( x:Int, y:Int ) return tiles[y][x].isExplored;

	public function setExplored( x:Int, y:Int ) {
		tiles[y][x].isExplored = true;
	}

	public function makeMap( fov:Fov, maxRooms:Int, roomMinSize:Int, roomMaxSize:Int, mapWidth:Int, mapHeight:Int, player:Entity, entities:Array<Entity>, maxMonstersPerRoom:Int, maxItemsPerRoom:Int ) {
		xa3.MTRandom.initializeRandGenerator( Engine.mapSeed );
		final rooms:Array<Rect> = [];
		for( r in 0...maxRooms ) {
			// random width and height
			final w = roomMinSize + MTRandom.quickIntRand( roomMaxSize - roomMinSize );
			final h = roomMinSize + MTRandom.quickIntRand( roomMaxSize - roomMinSize );

			// random position without going out of the boundaries of the map
			final x = MTRandom.quickIntRand( mapWidth - w - 1 );
			final y = MTRandom.quickIntRand( mapHeight - h - 1 );

			final room = new Rect( x, y, w, h );
			
			// run through the other rooms and see if they intersect with this one
			var isIntersect = false;
			for( otherRoom in rooms ) {
				if( room.intersect( otherRoom )) {
					isIntersect = true;
					break;
				}
			}

			if( !isIntersect ) {
				// this means there are no intersections, so this room is valid

				// "paint" it to the map's tiles
				createRoom( room );

				// center coordinates of new room, will be useful later
				final center = room.getCenter();

				if( rooms.length == 0 ) {
					// this is the first room, where the player starts at
					player.x = center.x;
					player.y = center.y;
				} else {
					// all rooms after the first
					// connect it to the previous room with a tunnel

					// center coordinates of previous room
					final prevCenter = rooms[rooms.length - 1].getCenter();

					// flip a coin (random number that is either 0 or 1)
					if( MTRandom.quickIntRand( 2 ) == 1 ) {
						// first move horizontally, then vertically
						createHTunnel( prevCenter.x, center.x, prevCenter.y );
						createVTunnel( prevCenter.y, center.y, center.x );
					} else {
						// first move vertically, then horizontally
						createVTunnel( prevCenter.y, center.y, prevCenter.x );
						createHTunnel( prevCenter.x, center.x, center.y );
					}

				}

				rooms.push( room );
			}

		}

		for( room in rooms ) placeItems( fov, room, entities, maxMonstersPerRoom, maxItemsPerRoom );
		for( room in rooms ) placeMonsters( fov, room, entities, maxMonstersPerRoom, maxItemsPerRoom );

	}

	public function getPath( source:Entity, target:Entity, entities:Array<Entity> ) {
		final world = tiles.map( row -> row.map( tile -> tile.isBlocked ? 1 : 0 ));
		for( entity in entities ) {
			if( entity.isBlock && entity != source && entity != target ) world[entity.y][entity.x] = 1;
		}
		graph.setWorld( world.flatten() );
		final result = graph.solve( source.x, source.y, target.x, target.y );
		return result;
	}

	function createRoom( room:Rect ) {
		for( x in room.x1 + 1...room.x2 ) {
			for( y in room.y1 + 1...room.y2 ) {
				tiles[y][x].isBlocked = false;
				tiles[y][x].isBlockSight = false;
			}
		}
	}

	function createHTunnel( x1:Int, x2:Int, y:Int ) {
		for( x in int( min( x1, x2 ))...int( max( x1, x2 ) + 1 )) {
			tiles[y][x].isBlocked = false;
			tiles[y][x].isBlockSight = false;
		}
	}
	
	function createVTunnel( y1:Int, y2:Int, x:Int ) {
		for( y in int( min( y1, y2 ))...int( max( y1, y2 ) + 1 )) {
			tiles[y][x].isBlocked = false;
			tiles[y][x].isBlockSight = false;
		}
	}

	function placeItems( fov: Fov, room:Rect, entities:Array<Entity>, maxMonstersPerRoom:Int, maxItemsPerRoom:Int ) {
		xa3.MTRandom.initializeRandGenerator( Engine.itemsSeed );
		// Get a random number of items
		final numberOfItems = MTRandom.quickIntRand( maxItemsPerRoom );
		// place items
		for( i in 0...numberOfItems ) {
			final x1 = room.x1 + 1;
			final w1 = room.x2 - 1 - x1;
			final y1 = room.y1 + 1;
			final h1 = room.y2 - 1 - y1;
			final x = x1 + MTRandom.quickIntRand( w1 );
			final y = y1 + MTRandom.quickIntRand( h1 );

			if( checkPosition( x, y, entities )) {
				
				final itemChance = MTRandom.quickIntRand( 100 );

				if( itemChance < 70 ) {

					final itemName = "Healing Potion";
					final item = new Entity( x, y, cells[HealingPotion], itemName, false, RenderOrder.ITEM, new Item( ItemFunctions.heal, HealingPotion( 4 )));
					entities.push( item );
				} else {

					final itemName = "Lightning Scroll";
					final item = new Entity( x, y, cells[LightningScroll], itemName, false, RenderOrder.ITEM, new Item( ItemFunctions.castLightning, Lightning( entities, fov, 20, 5 )) );
					entities.push( item );
				}
				
			}

		}
	}

	function placeMonsters( fov: Fov, room:Rect, entities:Array<Entity>, maxMonstersPerRoom:Int, maxItemsPerRoom:Int ) {
		xa3.MTRandom.initializeRandGenerator( Engine.enemiesSeed );
		// Get a random number of monsters
		final numberOfMonsters = MTRandom.quickIntRand( maxMonstersPerRoom );

		// place monsters
		for( i in 0...numberOfMonsters ) {
			// Choose a random location in the room
			final xMin = room.x1 + 1;
			final xRange = room.x2 - 1 - xMin;
			final x = xMin + MTRandom.quickIntRand( xRange );
			final yMin = room.y1 + 1;
			final yRange = room.y2 - 1 - yMin;
			final y = yMin + MTRandom.quickIntRand( yRange );

			if( checkPosition( x, y, entities )) {
				final monsterType = MTRandom.quickRand() < 0.8 ? Orc : Troll;
				switch monsterType {
					case Orc:
						final fighterComponent = new Fighter( Engine.OrcHitPoints, Engine.OrcDefense, Engine.OrcPower );
						final aiComponent = new BasicMonster();
						final monster = new Entity( x, y, cells[monsterType], "Orc", true, RenderOrder.ACTOR, fighterComponent, aiComponent );
						entities.push( monster );

					case Troll:
						final fighterComponent = new Fighter( Engine.TrollHitPoints, Engine.TrollDefense, Engine.TrollPower );
						final aiComponent = new BasicMonster();
						final monster = new Entity( x, y, cells[monsterType], "Troll", true, RenderOrder.ACTOR, fighterComponent, aiComponent );
						entities.push( monster );

					default: // no-op
				}
				
			}
		}
	}
	
	static function checkPosition( x:Int, y:Int, entities:Array<Entity> ) {
		for( entity in entities ) if( entity.x == x && entity.y == y ) {
			return false;
		}
		return true;
	}

}

enum BlockingEntity {
	None;
	Entity( e:Entity );
}