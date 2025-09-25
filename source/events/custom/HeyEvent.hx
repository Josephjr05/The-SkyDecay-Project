package events.custom;

class HeyEvent extends BaseEvent {
    public function new() {
        super(
            "Hey!",
            "Plays the Hey animation.\nValue1: BF/GF/Both\nValue2: Duration (default 0.6)"
        );
    }

    override public function run(params:Array<String>):Void {
        var value1:String = if(params.length > 0) params[0] else "";
        var value2:String = if(params.length > 1) params[1] else "";
        var strumTime:Float = if(params.length > 2) Std.parseFloat(params[2]) else 0;

        var target:Int = 2; // Both by default
        switch(value1.toLowerCase().trim()) {
            case "bf", "boyfriend", "0": target = 0;
            case "gf", "girlfriend", "1": target = 1;
        }

        var duration:Float = if(value2 != null && value2.length > 0) Std.parseFloat(value2) else 0.6;

        // Apply animations
        if(target != 0) {
            if(PlayState.instance.dad.curCharacter.startsWith("gf")) {
                PlayState.instance.dad.playAnim("cheer", true);
                PlayState.instance.dad.specialAnim = true;
                PlayState.instance.dad.heyTimer = duration;
            } else if(PlayState.instance.gf != null) {
                PlayState.instance.gf.playAnim("cheer", true);
                PlayState.instance.gf.specialAnim = true;
               PlayState.instance.gf.heyTimer = duration;
            }
        }

        if(target != 1) {
            PlayState.instance.boyfriend.playAnim("hey", true);
            PlayState.instance.boyfriend.specialAnim = true;
            PlayState.instance.boyfriend.heyTimer = duration;
        }
    }
}