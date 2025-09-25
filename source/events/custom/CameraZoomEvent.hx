package events.custom;

class CameraZoomEvent extends BaseEvent {
    public function new() {
        super(
            "Camera Zoom",
            "Adjusts camera zoom.\nValue1: Camera zoom amount (default 0.015)\nValue2: HUD zoom amount (default 0.03)"
        );
    }

    override public function run(params:Array<String>):Void {
        var camZoom:Float = if(params.length > 0 && params[0] != "") Std.parseFloat(params[0]) else 0.015;
        var hudZoom:Float = if(params.length > 1 && params[1] != "") Std.parseFloat(params[1]) else 0.03;

        // Apply zooms
       FlxG.camera.zoom = camZoom;
        if (ClientPrefs.data.camHUDOption) {
            PlayState.instance.camHUD.zoom = hudZoom; // assuming you have a variable for HUD zoom
        }
    }
}