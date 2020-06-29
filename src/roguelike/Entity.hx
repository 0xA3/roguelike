package roguelike;

import roguelike.components.Item;
import roguelike.components.Inventory;
import roguelike.components.BasicMonster;
import roguelike.components.Fighter;
import roguelike.mapobjects.GameMap;
import roguelike.RenderOrder;
import asciix.Cell;

class Entity {
	
	public var x:Int;
	public var y:Int;
	public var avatar:Cell;
	public var name:String;
	public var isBlock:Bool;
	public var renderOrder:Int;

	public var fighter:Null<Fighter>;
	public var ai:Null<BasicMonster>;
	public var item:Null<Item>;
	public var inventory:Null<Inventory>;

	public function new( x:Int, y:Int, avatar:Cell, name:String, isBlock = false, renderOrder = RenderOrder.CORPSE, ?fighter:Fighter, ?ai:BasicMonster, ?item:Item, ?inventory:Inventory ) {
		this.x = x;
		this.y = y;
		this.name = name;
		this.avatar = avatar;
		this.isBlock = isBlock;
		this.renderOrder = renderOrder;
		// trace( 'new Entity ${asciix.Ansix.cellToString( avatar )}' );

		this.fighter = fighter;
		this.ai = ai;
		this.item = item;
		this.inventory = inventory;

		if( this.fighter != null ) fighter.owner = this;
		if( this.ai != null ) ai.owner = this;
		if( this.item != null ) item.owner = this;
		if( this.inventory != null ) inventory.owner = this;

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