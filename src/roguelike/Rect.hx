package roguelike;

import Std.int;

typedef Point = {
	final x:Int;
	final y:Int;
}

class Rect {
	
	public final x1:Int;
	public final y1:Int;
	public final x2:Int;
	public final y2:Int;

	public function new( x:Int, y:Int, w:Int, h:Int ) {
		this.x1 = x;
		this.y1 = y;
		x2 = x + w;
		y2 = y + h;
	}

	public function getCenter():Point {
		final centerX = int(( x1 + x2 ) / 2 );
		final centerY = int(( y1 + y2 ) / 2 );
		return { x: centerX, y: centerY };
	}

	public function intersect( other:Rect ) {
		// returns true if this rectangle intersects with another one
		return x1 <= other.x2 && x2 >= other.x1 && y1 <= other.y2 && y2 >= other.y1;
	}
}