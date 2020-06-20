package roguelike.components;

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

	public function takeDamage( amount:Int ) hp -= amount;

	public function attack( target:Entity ) {
		final damage = power - target.fighter.defense;

		if( damage > 0 ) {
			target.fighter.takeDamage( damage );
			Sys.println( '${owner.name} attacks ${target.name} for $damage hit points.' );
		} else {
			Sys.println( '${owner.name} attacks ${target.name} but does no damage.' );
		}
	}
}