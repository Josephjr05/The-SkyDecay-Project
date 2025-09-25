package events;

class BaseEvent {
    public var name:String;
    public var description:String;

    public function new(name:String, description:String) {
        this.name = name;
        this.description = description;
    }

    public function getDescription():String {
        return description;
    }

    // Override this in every event
    public function run(params:Array<String>):Void {}
}