package roguelike;

import roguelike.mapobjects.GameMap;
import roguelike.components.Fighter;
import roguelike.components.BasicMonster;
import xa3.Ansix.Cell;

class Entity {
	
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var isBlock:Bool;
	public var avatar:Cell;

	public var fighter:Null<Fighter>;
	public var ai:Null<BasicMonster>;

	public function new( x:Int, y:Int, avatar:Cell, name:String, isBlock = false, ?fighter:Fighter, ?ai:BasicMonster ) {
		this.x = x;
		this.y = y;
		this.name = name;
		this.avatar = avatar;
		this.isBlock = isBlock;
		// trace( 'new Entity ${xa3.Ansix.cellToString( avatar )}' );

		this.fighter = fighter;
		this.ai = ai;

		if( this.fighter != null ) fighter.owner = this;
		if( this.ai != null ) ai.owner = this;

	}

	public function move( dx:Int, dy:Int ) {
		x += dx;
		y += dy;
	}

	public function moveTowards( targetX:Int, targetY:Int, gameMap:GameMap, entities:Array<Entity> ) {
		final distanceX = targetX - x;
		final distanceY = targetY - y;
		final distance = Math.sqrt( distanceX * distanceX + distanceY * distanceY );

		final dx = Math.round( distanceX / distance );
		final dy = Math.round( distanceY / distance );

		final destinationX = x + dx;
		final destinationY = y + dy;

		if( !gameMap.isBlocked( destinationX, destinationY )
			&& getBlockingEntitiesAtLocation( entities, destinationX, destinationY ) == None ) {
			move( dx, dy );
		}
	}

	public function moveAstar( target:Entity, entities:Array<Entity>, gameMap:GameMap ) {
		final result = gameMap.getPath( this, target, entities );
		if( result.result == astar.types.Result.Solved ) {
			if( result.path.length > 1 ) {
				final step = result.path[1];
				// trace( 'move monster from $x:$y to ${step.x}:${step.y}' );
				x = step.x;
				y = step.y;
			}
		} else {
			moveTowards( target.x, target.y, gameMap, entities );
		}
	}

	public function distanceTo( other:Entity ) {
		final dx = other.x - x;
		final dy = other.y - y;
		return Math.sqrt( dx * dx + dy * dy );
	}

	public static function getBlockingEntitiesAtLocation( entities:Array<Entity>, x:Int, y:Int ) {
		for( entity in entities ) {
			if( entity.isBlock && entity.x == x && entity.y == y ) return Entity( entity );
		}
		return None;
	}

}