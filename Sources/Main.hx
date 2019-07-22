package;

import kha.System;

class Main {

	public static function main() {
		System.start({title: "Empty", width: 800, height: 600}, init);
	}

	static function init(window:kha.Window) {
		var game = new Empty();
		System.notifyOnFrames(game.render);
	}
}
