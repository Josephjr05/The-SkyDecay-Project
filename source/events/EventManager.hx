package events;

class EventManager {
    private static var registry:Map<String, BaseEvent> = new Map();

    public static function register(event:BaseEvent):Void {
        registry.set(event.name.toLowerCase(), event);
    }

    public static function getEvent(name:String):BaseEvent {
        return registry.get(name.toLowerCase());
    }

    public static function getRegisteredEvents():Array<String> {
        var arr:Array<String> = [];
        for (key in registry.keys()) {
            arr.push(key);
        }
        return arr;
    }

    public static function run(eventName:String, params:Array<String>):Void {
        var e:BaseEvent = getEvent(eventName);
        if (e != null) e.run(params);
        else trace("EventManager: Unknown event '" + eventName + "'");
    }
}