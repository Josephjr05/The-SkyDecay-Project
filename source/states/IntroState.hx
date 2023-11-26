import flixel.FlxState;

#if VIDEOS_ALLOWED
#if (hxCodec >= "2.6.1") import hxcodec.VideoHandler as MP4Handler;
#elseif (hxCodec == "2.6.0") import VideoHandler as MP4Handler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

using StringTools;

class IntroState extends MusicBeatState
{
    var StateToSwitch:FlxState;
 
    public function new(StateToSwitch:MusicBeatState = new TitleState())
    {
        this.StateToSwitch = StateToSwitch;
        super();
    }

    override function create()
    {
        var video = new MP4Handler();
        video.playVideo(Paths.video("Intro"));
        video.finishCallback = function() {
            MusicBeatState.switchState(new TitleState());
        };
        super.create();
    }
}