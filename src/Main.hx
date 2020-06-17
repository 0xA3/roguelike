import roguelike.KeyListener;
import roguelike.Roguelike;

class Main {
	static function main() {
		
		final keyListener = new KeyListener();
		final game = new Roguelike( keyListener );

		game.init();
		game.start();
	}
}
