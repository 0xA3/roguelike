package roguelike.components;

import roguelike.mapobjects.GameMap;

using xa3.ArrayUtils;

class BasicMonster {
	
	public var owner:Entity;

	public function new() {	}

	public function takeTurn( target:Entity, fov:Fov, gameMap:GameMap, entities:Array<Entity> ) {
		final results = [];
		final monster = owner;

		if( fov.isVisible( monster.x, monster.y )) {
			if( monster.distanceTo( target ) >= 2 ) {
				monster.moveAstar( target, entities, gameMap );
			} else if( target.fighter != null && target.fighter.hp > 0 ) {
				final attackResults = monster.fighter.attack( target );
				results.extend( attackResults );
			}
		}
		return results;
	}
}