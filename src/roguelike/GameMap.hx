package roguelike;

import Std.int;
import Math.min;
import Math.max;
import roguelike.Engine.cells;
import roguelike.Engine.TCell;

class GameMap {
	
	public final width:Int;
	public final height:Int;
	public final tiles:Array<Array<Tile>>;

	public function new( width:Int, height:Int ) {
		this.width = width;
		this.height = height;
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

	public function makeMap( maxRooms:Int, roomMinSize:Int, roomMaxSize:Int, mapWidth:Int, mapHeight:Int, player:Entity, entities:Array<Entity>, maxMonstersPerRoom:Int ) {

		final rooms:Array<Rect> = [];
		for( r in 0...maxRooms ) {
			// random width and height
			final w = roomMinSize + Std.random( roomMaxSize - roomMinSize );
			final h = roomMinSize + Std.random( roomMaxSize - roomMinSize );

			// random position without going out of the boundaries of the map
			final x = Std.random( mapWidth - w - 1 );
			final y = Std.random( mapHeight - h - 1 );

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
					if( Std.random( 2 ) == 1 ) {
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
				placeEntities( room, entities, maxMonstersPerRoom );

			}
		}

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

	function placeEntities( room:Rect, entities:Array<Entity>, maxMonstersPerRoom:Int ) {
		// Get a random number of monsters
		final numberOfMonsters = Std.random( maxMonstersPerRoom );

		for( i in 0...numberOfMonsters ) {
			// Choose a random location in the room
			final xMin = room.x1 + 1;
			final xRange = room.x2 - 1 - xMin;
			final x = xMin + Std.random( xRange );
			final yMin = room.y1 + 1;
			final yRange = room.y2 - 1 - yMin;
			final y = yMin + Std.random( yRange );

			var isPositionFree = true;
			for( entity in entities ) if( entity.x == x && entity.y == y ) {
				isPositionFree = false;
				break;
			}

			if( isPositionFree ) {
				final monsterType = Math.random() < 0.8 ? 0 : 1;
				final monster:Entity = new Entity( 
					x, y, 
					monsterType == 0 ? cells[Orc] : cells[Troll], 
					monsterType == 0 ? "Orc" : "Troll", 
					true );
				
				entities.push( monster );
			}
		}
	}

	public static function getBlockingEntitiesAtLocation( entities:Array<Entity>, x:Int, y:Int ) {
		for( entity in entities ) {
			if( entity.isBlock && entity.x == x && entity.y == y ) return Entity( entity );
		}
		return None;
	}
}

enum BlockingEntity {
	None;
	Entity( e:Entity );
}