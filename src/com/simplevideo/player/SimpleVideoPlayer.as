package com.simplevideo.player {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	import flash.display.Sprite;

	/**
	 * @author layter
	 */
	public class SimpleVideoPlayer extends Sprite {
		
		private var flash_vars: Object;
		private var update_js: String;
		private var player: StreamWrapper;
		
		public function SimpleVideoPlayer() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			create_flash_vars();
			
			if (ExternalInterface.available) {
				connect_to_javascript();
			}

			player = new StreamWrapper();
			player.addEventListener(Event.ACTIVATE, init_js, false, 0, true);
			player.init(this.stage, update_js);
			addChild(player);
		}
		
		private function init_js(e : Event) : void {
			ExternalInterface.call(update_js, 'init');
		}
		
		private function create_flash_vars() : void {
			flash_vars = this.loaderInfo.parameters;
		}
		
		private function connect_to_javascript() : void {
			assign_javascript_function();
			add_javascript_callbacks();
		}
		
		private function assign_javascript_function() : void {
			if (!flash_vars.update_function) {
				update_js = 'update_player';
			}
			else {
				update_js = flash_vars.update_function;
			}
		}
		
		private function add_javascript_callbacks() : void {
			ExternalInterface.addCallback('play', play);
			ExternalInterface.addCallback('pause', pause);
			ExternalInterface.addCallback('stop', stop);
			ExternalInterface.addCallback('volume', volume);
			ExternalInterface.addCallback('load', load);
		}
		
		public function play(percent: int = -1) : void {
			player.play(percent);
		}
		
		public function pause() : void {
			player.pause();
		}
		
		public function stop() : void {
			player.stop();
		}
		
		public function volume(percent: int) : void {
			player.volume(percent);
		}
				
		public function load(file: String) : void {
			player.load(file);
		}
		
	}
}
