package objects;

// import flixel.FlxG;
// import objects.Note;

// class Sustain extends Note {
// 	public function new() {
// 		super(0, 0);
// 		isSustainNote = true;
// 	}

// 	public function calcHeight(holdScale:Float) {
// 		// Never2x Logic: height is based on sustainLength from chart
// 		this.height = (sustainLength) * 0.45 * holdScale;
// 	}

// 	override function reloadNote(texture:String = '', postfix:String = '') {
// 		super.reloadNote(texture, postfix);
// 		if (animation.getByName(Note.colArray[noteData] + 'hold') != null)
// 			animation.play(Note.colArray[noteData] + 'hold');
// 	}

// 	public function setup(data:NoteData):Note {
// 		super.setup(data);
// 		this.alpha = 0.6;
// 		return this;
// 	}

// 	override public function update(elapsed:Float) {
// 		super.update(elapsed);
// 		// Prevents Psych from doing standard sustain logic
// 	}
// }