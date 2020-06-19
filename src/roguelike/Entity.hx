package roguelike;

import xa3.Ansix.Cell;

class Entity {
	
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var isBlock:Bool;
	public var avatar:Cell;

	public function new( x:Int, y:Int, avatar:Cell, name:String, isBlock = false ) {
		this.x = x;
		this.y = y;
		this.name = name;
		this.avatar = avatar;
		this.isBlock = isBlock;
		// trace( 'new Entity ${xa3.Ansix.cellToString( avatar )}' );
	}

	public function move( dx:Int, dy:Int ) {
		x += dx;
		y += dy;
	}
}