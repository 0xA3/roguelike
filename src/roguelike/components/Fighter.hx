package roguelike.components;

import roguelike.TResult;

using xa3.ArrayUtils;

class Fighter {
	
	public var hp:Int;
	public var defense:Int;
	public var power:Int;

	public var owner:Entity;

	public function new( hp:Int, defense:Int, power:Int ) {
		this.hp = hp;
		this.defense = defense;
		this.power = power;
	}

	public function takeDamage( amount:Int ) {
		final results = [];
		hp -= amount;

		if( hp <= 0 ) results.push( Dead( owner ));
		return results;
	}

	public function attack( target:Entity ) {
		final results = [];
		final damage = power - target.fighter.defense;

		if( damage > 0 ) {
			results.push( Message( '${owner.name} attacks ${target.name} for $damage hit points.' ));
			final damageResults = target.fighter.takeDamage( damage );
			results.extend( damageResults );
		} else {
			results.push( Message( '${owner.name} attacks ${target.name} but does no damage.' ));
		}
		return results;
	}
}