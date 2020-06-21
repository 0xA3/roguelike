import roguelike.KeyListener;
import roguelike.Engine;

class Main {
	
	static function main() {
		
		#if nodejs
		// Install source-map-support for nodejs
		// "npm install source-map-support"
		js.Lib.require('source-map-support').install();
		#end

		final keyListener = new KeyListener();
		final game = new Engine( keyListener );

		game.init();
		game.start();

	}
}
