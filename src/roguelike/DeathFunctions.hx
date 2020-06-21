package roguelike;

import roguelike.GameStates;
import xa3.Ansix.Cell;

class DeathFunctions {
	
	public static function killPlayer( player:Entity, deathAvatar:Cell ) {
		player.avatar = deathAvatar;

		return { message: 'You died!', state: GameStates.PlayerDead };
	}

	public static function killMonster( monster:Entity, deathAvatar:Cell ) {
		final deathMessage = '${monster.name} is dead!';

		monster.avatar = deathAvatar;

		monster.isBlock = false;
		monster.renderOrder = RenderOrder.CORPSE;
		monster.fighter = null;
		monster.ai = null;
		monster.name = 'remains of ${monster.name}';

		return deathMessage;
	}
}