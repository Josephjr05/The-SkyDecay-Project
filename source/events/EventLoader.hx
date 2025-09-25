package events;

import backend.Paths;
import Type;
import events.BaseEvent;
import events.custom.*;
import states.editors.ChartingState;

class EventLoader {
    public static function loadAllEvents():Void {
        // 1️ Load custom HX events dynamically
        var ahhh = ChartingState.loadFileList('source/events/custom/', ['.hx']);
        var hxFiles:Array<String> = ahhh;
        for(file in hxFiles) {
            var className = 'events.custom.' + file.substr(0, file.lastIndexOf('.hx'));
            var cls:Class<Dynamic> = Type.resolveClass(className);
            if(cls != null) {
                var instance:BaseEvent = cast(Type.createInstance(cls, []), BaseEvent);
                EventManager.register(instance);
            }
        }

        // 2️ Register legacy events
        EventManager.register(new HeyEvent());
        EventManager.register(new CameraZoomEvent());
        // Add other legacy PlayState events here
    }
}
