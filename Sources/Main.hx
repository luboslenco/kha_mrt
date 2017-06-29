package;

import kha.System;

class Main {

	public static function main() {
		System.init({title: "Empty", width: 800, height: 600}, init);
	}

	static function init() {
		var game = new Empty();
		System.notifyOnRender(game.render);
	}
}
