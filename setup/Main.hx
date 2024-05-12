package;

import commands.*;

class Main {
    public static var commands:Array<Command> = [];

    public static function initCommands() {
        commands = [
            {
                names: ["setup"],
                doc: "Setups (or updates) all libraries required for the engine.",
                func: Update.main,
                dDoc: "This command runs through all libraries in libs.xml, and install them.\nIf they're already installed, they will be updated."
            }
        ];
    }

    public static function main() {
        initCommands();
        var args = Sys.args();
        var commandName = args.shift();
        if (commandName != null)
            commandName = commandName.toLowerCase();
        for(c in commands) {
            if (c.names.contains(commandName)) {
                c.func(args);
                return;
            }
        }
    }

    public static function help(args:Array<String>) {
        var cmdName = args.shift();
        if (cmdName != null) {
            cmdName = cmdName.toLowerCase();

            var matchingCommand = null;
            for(c in commands) if (c.names.contains(cmdName)) {
                matchingCommand = c;
                break;
            }

            if (matchingCommand == null) {
                Sys.println('help - Command named ${cmdName} not found.');
                return;
            }

            Sys.println('${matchingCommand.names.join(", ")}');
            Sys.println("---");
            Sys.println(matchingCommand.dDoc);

            return;
        }
        // shows help
        Sys.println("Psych Engine Command Line utility");
        Sys.println('Available commands (${commands.length}):\n');
        for(line in commands) {
            Sys.println('${line.names.join(", ")} - ${line.doc}');
        }
    }
}

typedef Command = {
    var names:Array<String>;
    var func:Array<String>->Void;
    var ?doc:String;
    var ?dDoc:String;
}