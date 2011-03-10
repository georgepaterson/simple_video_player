## Setup

Inject using swfobject and optionally set the javascript tracking (this will default to update_player):, e.g:

    flash_vars = {

        update_function: 'my.update.function'

    };


    swfobject.embedSWF("LBiPlayer.swf", "video_player", 320, 270, "9.0.0", "resources/expressInstall.swf", flash_vars);

Note: the video will be resized to the full dimensions of the swf, in this case 320 x 270.

## Controlling the player

The Flash player does what you tell it to and nothing more, so all state and logic must be defined by javascript. To control the player you use the following functions.

    flash_object.play(); // plays from the current position

    flash_object.play(60); // plays from 60%

    flash_object.pause(); // pauses the video

    flash_object.stop(); // stops the video

    flash_object.volume(50); // sets volume to 50%

    flash_object.load('test.flv'); // loads file (needs to be relative to the swf)

You also need to know what the player is currently doing. Events are sent to the javascript function you specified to achieve this.

    var update_player = function(status, params) {

        switch(status) {

                case 'init':

                    console.log('player ready');

                break;

                case 'loaded':

                    console.log('loaded', params.duration);

                break;

                case 'playing':

                /* this is sent every 500 milliseconds while playing. */

                console.log('playing', params.position);

                break;

                case 'paused':

                    console.log('paused', params.position);

                break;

                case 'stopped':

                    console.log('stopped');

                break;

        }

    }
