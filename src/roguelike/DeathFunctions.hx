package roguelike;

import roguelike.Engine.cells;
import roguelike.Engine.TCell;
import roguelike.GameState;
import roguelike.MessageLog.Message;
import asciix.Cell;

class DeathFunctions {
	
	public static function killPlayer( player:Entity, deathAvatar:Cell ) {
		player.avatar = deathAvatar;

		final message:Message = { text: 'You died!', format: cells[PlayerDeathMessage] };
		return { message: message, state: GameState.PlayerDead };
	}

	public static function killMonster( monster:Entity, deathAvatar:Cell ) {
		final deathMessage:Message = { text: '${monster.name} is dead!', format: cells[EnemyDeathMessage] };

		monster.avatar = deathAvatar;

		monster.isBlock = false;
		monster.renderOrder = RenderOrder.CORPSE;
		monster.fighter = null;
		monster.ai = null;
		monster.name = 'remains of ${monster.name}';

		return deathMessage;
	}
}