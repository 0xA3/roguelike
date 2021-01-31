package roguelike;

import roguelike.components.Item.Kwargs;
import roguelike.Engine.cells;
import roguelike.skins.TCell;
import roguelike.MessageLog.Message;

using xa3.ArrayUtils;

// typedef ItemResult = {
// 	final ?consumed:Bool;
// 	final ?dropped:Entity;
// 	final ?target:Entity;
// 	final tResult:TResult;
// }

class ItemFunctions {
	
	public static function heal( entity:Entity, kwargs:Kwargs ) {
		
		final results:Array<TResult> = [];

		if( entity.fighter.hp == entity.fighter.maxHp ) {
			results.push( Message({ text: 'You are already at full health', format: cells[ItemFalseMessage] }) );
		} else {
			final amount = switch kwargs {
				case HealingPotion(amount): amount;
				default: 0;
			}
			entity.fighter.heal( amount );
			results.push( ItemConsumed );
			results.push( Message({ text: 'Your wounds start to feel better!', format: cells[ItemTrueMessage] }) );
		}
		return results;
	}

	public static function castLightning( entity:Entity, kwargs:Kwargs ) {
		switch kwargs {
			case Lightning( entities, fovMap, damage, maximumRange ):
				return castLightningArgs( entity, entities, fovMap, damage, maximumRange );
			default: throw "Error: cannot cast Lightning with wrong kwargs";
		}
	}
	
	static function castLightningArgs( caster:Entity, entities:Array<Entity>, fov:Fov, damage:Int, maximumRange:Int ) {

		final results:Array<TResult> = [];
		final enemyEntities = entities.filter( entity -> entity != caster && entity.fighter != null && fov.isVisible( entity.x, entity.y ));
		
		enemyEntities.sort(( a, b ) -> {
			final da = caster.distanceTo( a );
			final db = caster.distanceTo( b );
			if( da > db ) return 1;
			if( da < db ) return -1;
			return 0;
		});

		if( enemyEntities.length == 0 ) {
			results.push(Message({ text: 'No enemy is close enough to strike.', format: cells[WeaponFalseMessage] }) );
		} else {
			final target = enemyEntities[0];
			results.push( ItemConsumed );
			results.push( Message({ text: 'A lighting bolt strikes the ${target.name} with a loud thunder! The damage is $damage', format: cells[WeaponHitMessage] }) );
			results.extend( target.fighter.takeDamage( damage ));
		}

		return results;

	}
}