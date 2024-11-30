package states.editors.content;

// access private fields

class GetNodeName {
    private var nodeName:String;

    public function new(name:String) {
        this.nodeName = name;
    }

    public function get_nodeName():String {
        return this.nodeName;
    }
}

class SetNodeValue {
    private var nodeValue:String;

    public function new(value:String) {
        this.nodeValue = value;
    }

    // Getter for nodeValue
    public function get_nodeValue():String {
        return this.nodeValue;
    }

    // Setter for nodeValue
    public function set_nodeValue(value:String):Void {
        this.nodeValue = value;
    }
}