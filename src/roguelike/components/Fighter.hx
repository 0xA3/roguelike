package roguelike.components;

import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.TResult;

using xa3.ArrayUtils;

class Fighter {
	
	public var maxHp:Int;
	public var hp:Int;
	public var defense:Int;
	public var power:Int;

	public var owner:Entity;

	public function new( hp:Int, defense:Int, power:Int ) {
		this.hp = hp;
		this.defense = defense;
		this.power = power;
		maxHp = hp;
	}

	public function takeDamage( amount:Int ) {
		final results = [];
		hp = Std.int( Math.max( 0, hp - amount ));

		if( hp <= 0 ) results.push( Dead( owner ));
		return results;
	}

	public function heal( amount:Int ) {
		hp = Std.int( Math.min( maxHp, hp + amount ));
	}

	public function attack( target:Entity ) {
		final results = [];
		final damage = power - target.fighter.defense;

		if( damage > 0 ) {
			results.push( Message({ text: '${owner.name} attacks ${target.name} for $damage hit points.', format: cells[StatusMessage] }));
			final damageResults = target.fighter.takeDamage( damage );
			results.extend( damageResults );
		} else {
			results.push( Message({ text: '${owner.name} attacks ${target.name} but does no damage.', format: cells[StatusMessage] }));
		}
		return results;
	}
}