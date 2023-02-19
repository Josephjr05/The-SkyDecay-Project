package;



class VideoIntro extends MusicBeatState
{
    override public function create():Void
        {
            var video:VideoHandler = new VideoHandler();
			video.playVideo(Paths.video('Intro'));
			video.finishCallback = function() {
				MusicBeatState.switchState(new TitleState());
			}
        }
}