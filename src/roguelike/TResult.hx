package roguelike;

enum TResult {
	Dead( e:Entity );
	Message( message:roguelike.MessageLog.Message );
}