package com.lbi.player {
	import flash.events.Event;

	/**
	 * @author layter
	 */
	public class PlayerEvent extends Event {
		public function PlayerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
