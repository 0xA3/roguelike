package roguelike;

import xa3.Ansix.Cell;
import xa3.Ansix.Color;

typedef Message = {
	final text:String;
	final format:Cell;
}

class MessageLog {
	
	public final messages:Array<Message> = [];
	public final x:Int;
	public final width:Int;
	public final height:Int;

	public function new( x:Int, width:Int, height:Int ) {
		this.x = x;
		this.width = width;
		this.height = height;
	}

	public function addMessage( m:Message ) {
		final messageLines = wrap( m.text, width );
		for( messageLine in messageLines ) {
			if( messages.length == height ) messages.shift();
			messages.push({ text: messageLine, format: m.format });
		}

	}

	function wrap( s:String, width:Int ) {
		final linesNumber = Math.ceil( s.length / width );
		final lineStarts = [for( i in 0...linesNumber) i * width];
		final lines = lineStarts.map( lineStart -> s.substr( lineStart, width ));
		return lines;
	}
}