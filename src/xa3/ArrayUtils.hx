package xa3;

import haxe.ds.Vector;

class ArrayUtils {
	
	public static function extend<T>( a1:Array<T>, a2:Array<T> ) {
		for( element in a2 ) a1.push( element );
	}

	static function colToRow<T>( input:Array<T>, width:Int, height:Int ) {
		final output = new Vector<T>( input.length );
		for( i in 0...input.length ) {
			// final x = Std.int( i / height );
			// final y = i % height;
			// final fi = y * width + x;
			// trace( '${input[i]} ${x}:${y}  $fi' );
			final fi = ( i % height ) * width + Std.int( i / height );
			output[fi] = input[i];
		}
		return output.toArray();
	}

	static function rowToCol<T>( input:Array<T>, width:Int, height:Int ) {
		final output = new Vector<T>( input.length );
		for( i in 0...input.length ) {
			// final x = i % width;
			// final y = Std.int( i / width );
			// final fi = x * height + y;
			final fi = ( i % width ) * height + Std.int( i / width );
			output[fi] = input[i];
		}
		return output.toArray();
	}

}