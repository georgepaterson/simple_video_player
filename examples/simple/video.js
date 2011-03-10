swfobject.embedSWF("../../bin/SimpleVideoPlayer.swf", "video_player", 960, 480, "9.0.0", "resources/expressInstall.swf");

var update_player, assign_controls;

assign_controls = function(video_player) {
	$('#controls').find('a#play').click(function() {
		video_player.play_video();
		return false;
	});

	$('#controls').find('a#pause').click(function() {
		video_player.pause();
		return false;
	});

	$('#controls').find('a#stop').click(function() {
		video_player.stop_video();
		return false;
	});

	$('#controls').find('a#mute').click(function() {
		video_player.volume(0);
		return false;
	});

	$('#controls').find('a#skip').click(function() {
		video_player.play_video(60);
		return false;
	});

	$('#controls').find('a#load').click(function() {
		video_player.load('assets/test.flv');
		return false;
	});
}

update_player = function(status, params) {

	var video_player;
	
	switch(status) {
		case 'init':

	        if (navigator.appName.indexOf("Microsoft") != -1) {
	            video_player = window['video_player'];
	        } 
	        else {
	            video_player = document['video_player'];
	    	}

			assign_controls(video_player);
			video_player.load('../examples/simple/assets/test.flv');
			
		break;
		case 'loaded':
			//console.log('loaded', params.duration);
		break;
		case 'playing':
			//console.log('playing', params.position);
		break;
		case 'paused':
			//console.log('paused', params.position);
		break;
		case 'stopped':
			console.log('stopped');
		break;
	}
}