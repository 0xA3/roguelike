package roguelike;

import xa3.Ansix.Color;

class Entity {
	
	public var x:Int;
	public var y:Int;
	public var char:String;
	public var color:Color;

	public function new( x:Int, y:Int, char:String, color:Color ) {
		this.x = x;
		this.y = y;
		this.char = char;
		this.color = color;
	}

	public function move( dx:Int, dy:Int ) {
		x += dx;
		y += dy;
	}
}