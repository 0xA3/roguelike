package roguelike;

import js.Node.process;

class KeyListener {
	
	public var key = 0;
	
	public function new() {
		
		final readline = js.Lib.require( 'readline' );
		readline.emitKeypressEvents( process.stdin );
		untyped process.stdin.setRawMode( true );
		process.stdin.addListener( 'keypress', ( str, key ) ->{
			if (key.ctrl && key.name == 'c') {
				process.exit();
			} else {
				this.key = key.name.charCodeAt( 0 );
			}
		});
	}
}