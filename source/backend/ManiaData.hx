package backend;

class ManiaData
{
	/**
	 * Array of Key Counts that the game can use.
	 */
	public static var keyCounts:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9];

	/**
	 * Scales for the notes.
	 */
	public static var noteSizes:Array<Float> = [0.9, 0.85, 0.8, 0.7, 0.66, 0.6, 0.55, 0.5, 0.46];

	/**
	 * Scales for the note splashes.
	 */
	public static var splashSizes:Array<Float> = [1.3, 1.2, 1.1, 1, 0.95, 0.9, 0.8, 0.7, 0.6];

	/**
	 * Note offsets for the X axis.
	 */
	public static var noteOffsetsX:Array<Float> = [-100, -75, -50, 0, 35, 45, 55, 65, 70];

	/**
	 * Note offsets for the Y axis.
	 */
	public static var noteOffsetsY:Array<Float> = [0, 0, 0, 0, 10, 25, 25, 40, 40];

	/**
	 * Offsets for ```StrumNote```.
	 */
	public static var strumOffsets:Array<Float> = [0, 0, 0, 0, 0, 8, 7, 8, 8];

	/**
	 * Note animations for each key amount.
	 */
	public static final noteAnimations:Array<Array<String>> = [
		["up" /*"square"*/],
		["left", "right"],
		["left", "up" /*"square"*/, "right"],
		["left", "down", "up", "right"],
		["left", "down", "up" /*"square"*/, "up", "right"],
		["left", "up", "right", "left" /*2"*/, "down", "right" /*2"*/],
		["left", "up", "right", "up" /*"square"*/, "left" /*2"*/, "down", "right" /*2"*/],
		[
			"left",
			"down",
			"up",
			"right",
			"left" /*2"*/,
			"down" /*2"*/,
			"up" /*2"*/,
			"right" /*2"*/],
		[
			"left",
			"down",
			"up",
			"right",
			"up" /*"square"*/,
			"left" /*2"*/,
			"down" /*2"*/,
			"up" /*2"*/,
			"right" /*2"*/]
	];

	/**
	 * Animations for static arrows.
	 */
	public static var staticAnimations:Array<Array<String>> = [
		["up" /*"square"*/],
		["left", "right"],
		["left", "up" /*"square"*/, "right"],
		["left", "down", "up", "right"],
		["left", "down", "up" /*"square"*/, "up", "right"],
		["left", "up", "right", "left", "down", "right"],
		["left", "up", "right", "up" /*"square"*/, "left", "down", "right"],
		["left", "down", "up", "right", "left", "down", "up", "right"],
		["left", "down", "up", "right", "up" /*"square"*/, "left", "down", "up", "right"]
	];
	
	public static var colArray:Array<Array<String>> = [
		["square"],
		["purple", "red"],
		["purple", "square", "red"],
		["purple", "blue", "green", "red"],
		["purple", "blue", "square", "green", "red"],
		["purple", "green", "red", "purple", "blue", "red"],
		["purple", "green", "red", "square", "purple", "blue", "red"],
		["purple", "blue", "green", "red", "purple", "blue", "green", "red"],
		["purple", "blue", "green", "red", "square", "purple", "blue", "green", "red"]
	];

	/**
	 * Sing animations.
	 */
	public static var playerAnimations:Map<String, String> = [
		"left" => "left",
		"down" => "down",
		"up" => "up",
		"right" => "right",
	];
}