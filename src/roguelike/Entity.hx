package roguelike;

import xa3.Ansix.Cell;
import xa3.Ansix.Color;

class Entity {
	
	public var x:Int;
	public var y:Int;
	public var avatar:Cell;

	public function new( x:Int, y:Int, avatar:Cell ) {
		this.x = x;
		this.y = y;
		this.avatar = avatar;
	}

	public function move( dx:Int, dy:Int ) {
		x += dx;
		y += dy;
	}
}