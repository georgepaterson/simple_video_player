package com.lbi.player {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.geom.Rectangle;
	import flash.display.StageDisplayState;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.events.SecurityErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.display.Sprite;

	/**
	 * @author layter
	 */
	public class VideoPlayer extends Sprite {
		
		private var target_stage: Stage;
		private var stream : NetStream;
		private var connection : NetConnection;
		private var file : String;
		private var video : Video;
		private var client : Object;
		private var audio : SoundTransform;
		private var js_function: String;
		private var duration: Number;
		private var play_loop: Timer;
		
		public function init(stage: Stage, tracking_function: String) : void {
			play_loop = new Timer(500);
			play_loop.addEventListener(TimerEvent.TIMER, playing);
			
			this.target_stage = stage;
			this.js_function = tracking_function;
			
			client = {};
			client.onMetaData = handleMetaData;
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
			
			audio = new SoundTransform();
			stream.soundTransform = audio;
			
			addChild( video );

			this.width = target_stage.stageWidth;
			this.height = target_stage.stageHeight;
		}

		private function playing(e: TimerEvent) : void {
			ExternalInterface.call(js_function, 'playing', { position: stream.time });
		}
		
		private function handleMetaData(data : Object) : void {
			duration = data.duration;
			ExternalInterface.call(js_function, 'loaded', { duration: duration });
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found: " + file);
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function connectStream():void {
			stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.client = client;
			
			video = new Video( target_stage.stageWidth, target_stage.stageHeight );
			video.attachNetStream(stream);
			video.smoothing = true;
			addChild(video);

			dispatchEvent(new Event(Event.ACTIVATE));
		}
				
		public function play(percent: int = -1) : void
		{
			if(percent == -1) {
				stream.resume();
			}
			else {
				var time: int = (duration / 100) * percent;
				stream.seek(time);
				stream.resume();
			}

			play_loop.start();
		}
		
		public function pause() : void
		{
			stream.pause();
			ExternalInterface.call(js_function, 'paused', { position: stream.time });

			play_loop.stop();
		}
		
		public function stop() : void
		{
			stream.seek( 0 );
			stream.pause();
			ExternalInterface.call(js_function, 'stopped');
			
			play_loop.stop();
		}
				
		public function volume( v : int ) : void
		{
			audio.volume = v;
			stream.soundTransform = audio;
		}
		
		public function load ( file : String ) : void
		{
			stream.play( file );
			stream.pause();
			
			play_loop.stop();
		}
		
	}
}
