package roguelike;

#if nodejs
import js.Node.process;
#end

class KeyListener {
	
	public var key = "";
	
	public function new() {
		
		#if nodejs
		final readline = js.Lib.require( 'readline' );
		readline.emitKeypressEvents( process.stdin );
		untyped process.stdin.setRawMode( true );
		process.stdin.addListener( 'keypress', ( str, key ) ->{
			if (key.ctrl && key.name == 'c') {
				process.exit();
			} else {
				this.key = key.name;
			}
		});
		#end
	}
}