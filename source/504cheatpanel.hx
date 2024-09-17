package;

import openfl.display.BitmapData;
import haxe.io.Bytes;
import sys.Http;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.text.FlxText;
import StringTools;

/**
	context for this save data code here uhm IT KINDA NEEDS TO BE HERE-
 */
if (FlxG.save.data.theme == null)
	FlxG.save.data.theme = 0;
var adminStrings:Dynamic = [
	[
		["Quit Game", "Closes Psych Engine."],
		["End Song", "Ends The Song."],
		["Botplay", "Botplay... Thats It."],
		["Speed Up", "Makes Song Faster."],
		["Slow Down", "Makes Song Slower."],
		["Stop Time", "Kinda Stops Time."]
	],
	[
		["Break Notes", "Just Makes The Notes Weird."],
		["Spinney Notes", "Stop Taking Lsd."],
		["God Mode", "No Death."],
		["More Health", "Gives Some Health."],
		["Less Health", "Takes Away Some Health."],
		["Turn Off HP Colors", "I Guess You Can Debug?"],
		["Rgb Boyfriend", "Gay Bf. (kinda broke)"]
	],
	[
		["Free Cam", "Control Camera With IJKL."],
		["Zoom Cam In", "Zooms Cam In."],
		["Zoom Cam Out", "Zooms Cam Out."],
		["Opponent Play", "Play As Dad."],
		["Placeholder", "Placeholder."],
		["Placeholder", "Placeholder."]
	]
];

var blackList = [
	"UPDATE", "DONT UPDATE", "Speed Up", "Slow Down", "Change Theme", "Rgb Boyfriend", "Randomize Notes", "More Health", "Less Health" "Zoom Cam In",
	"Zoom Cam Out"
];

var themes = [];

// shit for the panel
var camPanel:FlxCamera;
var version = "1.5";
var bg:FlxSprite;
var boardText:FlxText;
var buttonL:FlxSprite;
var buttonR:FlxSprite;
var buttons:Array<Array<Dynamic>> = [];
var texts:Array<Array<Dynamic>> = [];
var curButton = 0; // i have to do it like this okay :/
var curPage = 0;

//
// shit for mods in the panel
var freeCam:FlxObject;

//

function onCreatePost() {
	FlxG.mouse.enabled = true;
	FlxG.mouse.visible = true;

	camPanel = new FlxCamera();
	camPanel.bgColor = 0x00ffffff;
	FlxG.cameras.add(camPanel, false);
	FlxG.cameras.add(camOther, false);

	freeCam = new FlxObject(0, 0, 1, 1);
	freeCam.setPosition(game.camFollow.x, game.camFollow.y);

	var http = new Http("https://raw.githubusercontent.com/504brandon/504-CHEAT-PANEL/DONT-DOWNLOAD-THIS-IS-USED-FOR-HTTP-THINGS-ONLY/version.txt");

	http.onData = function(data:String) {
		if (Std.parseFloat(data) > Std.parseFloat(version)) {
			if (FlxG.save.data.update == null)
				FlxG.save.data.update = true;

			if (FlxG.save.data.update == true)
				adminStrings = [[["UPDATE", "UPDATE TO " + data], ["DONT UPDATE", "KEEP " + version]]];
			else
				adminStrings.push([
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data],
					["UPDATE", "UPDATE TO " + data]
				]);

			version += " OUTDATED";
		}

		if (Std.parseFloat(data) < Std.parseFloat(version))
			version += " BETA";
	}

	http.onError = function(error) {
		debugPrint('error: $error', 0xffee0000);
	}

	http.request();

	var http2 = new Http("https://raw.githubusercontent.com/504brandon/504-CHEAT-PANEL/DONT-DOWNLOAD-THIS-IS-USED-FOR-HTTP-THINGS-ONLY/themes/list.txt");

	http2.onData = function(data:String) {
		themes = data.split("-");

		themes.remove(themes[themes.length]);

		adminStrings[0][6] = ["Change Theme", "Change your theme " + themes[FlxG.save.data.theme]];
	}

	http2.onError = function(error) {
		debugPrint('error: $error', 0xffee0000);

		adminStrings.remove("Change Theme");
	}

	http2.request();

	regenMenu();
}

function onUpdatePost(elapsed:Float) {
	for (array in buttons) {
		if (FlxG.mouse.overlaps(array[1], camPanel) && FlxG.mouse.justPressed) {
			if (!blackList.contains(array[0]))
				array[1].antialiasing = !array[1].antialiasing;

			switch (array[0]) { // this is for when you only click things
				case "UPDATE":
					var http = new Http("https://raw.githubusercontent.com/504brandon/504-CHEAT-PANEL/DONT-DOWNLOAD-THIS-IS-USED-FOR-HTTP-THINGS-ONLY/menu.txt");

					http.onData = function(data:String) {
						File.saveBytes('./' + this, Bytes.ofString(data));
					}

					http.onError = function(error) {
						debugPrint('error: $error', 0xffee0000);
					}

					http.request();

					FlxG.save.data.update = true;

					FlxG.resetState();

				case "DONT UPDATE":
					FlxG.save.data.update = false;
					FlxG.resetState();

				case "Quit Game":
					Sys.exit(1);

				case "End Song":
					game.health += 9999;
					game.finishSong(true);

				case "Botplay":
					game.cpuControlled = array[1].antialiasing;
					game.botplayTxt.visible = array[1].antialiasing;

				case "Speed Up":
					if (game.playbackRate <= 3.0) {
						game.playbackRate += 0.1;
					}

				case "Slow Down":
					if (game.playbackRate >= 0.5) {
						game.playbackRate -= 0.1;
					}

				case "Stop Time":
					if (array[1].antialiasing)
						game.playbackRate = 0;
					else
						game.playbackRate = 1;

				case "Change Theme":
					FlxG.save.data.theme++;
					if (Std.int(FlxG.save.data.theme) > themes.length - 1)
						FlxG.save.data.theme = 0;

					adminStrings[0][6] = ["Change Theme", "Change your theme " + themes[FlxG.save.data.theme]];

					regenMenu();

				case "Rgb Boyfriend":
					rgbRecolor(game.boyfriend);

				case "Break Notes":
					for (note in game.unspawnNotes) {
						note.angle = FlxG.random.float(-180, 180);
						note.noteData = FlxG.random.int(0, 3);
					}

				case "Jack Notes":
					for (note in game.unspawnNotes) {
						note.isSustainNote = false;
						var colors:Array<String> = ['purple', 'blue', 'green', 'red'];
						note.animation.addByPrefix("newNote", colors[note.noteData] + "0");
						note.animation.play("newNote");
						note.alpha = 1;
						note.offsetX -= note.width / 2;
						note.scale.set(0.8, 0.8);
					}

				case "Spinney Notes":
					if (!array[1].antialiasing) {
						for (strum in game.playerStrums.members)
							strum.angle = 0;

						for (strum in game.opponentStrums.members)
							strum.angle = 0;
					}

				case "More Health":
					game.health += 0.2;

				case "Less Health":
					game.health -= 0.2;

				case "Opponent Play":
					for (note in game.unspawnNotes) {
						note.noAnimation = array[1].antialiasing;
						note.canBeHit = !note.canBeHit;
						note.mustPress = !note.mustPress;
					}

				case "Free Cam":
					if (array[1].antialiasing)
						FlxG.camera.follow(freeCam, "LOCKON", 0);
					else
						FlxG.camera.follow(camFollow, "LOCKON", 0);

					FlxG.camera.snapToTarget();

				case "Zoom Cam In":
					game.defaultCamZoom += 0.2;
					FlxG.camera.zoom += 0.2;

				case "Zoom Cam Out":
					game.defaultCamZoom -= 0.2;
					FlxG.camera.zoom -= 0.2;
			}
		}

		if (array[1].antialiasing) {
			switch (array[0]) { // this is for things that will occur every second
				case "God Mode":
					game.health = 2;

				case "Spinney Notes":
					for (strum in game.playerStrums.members)
						strum.angle += 1.5;

					for (strum in game.opponentStrums.members)
						strum.angle += 1.5;

				case "Rainbow Notes":
					for (note in game.unspawnNotes) {
						note.rgbShader.r += note.strumTime;
						note.rgbShader.g += note.strumTime;
						note.rgbShader.b += note.strumTime;
					}

				case "Turn Off HP Colors":
					game.healthBar.setColors(0xFFFF0000, 0xFF66FF33);

				case "Free Cam":
					if (FlxG.keys.pressed.I)
						freeCam.y -= 10;
					if (FlxG.keys.pressed.J)
						freeCam.x -= 10;
					if (FlxG.keys.pressed.L)
						freeCam.x += 10;
					if (FlxG.keys.pressed.K)
						freeCam.y += 10;

				case "Opponent Play":
					boyfriend.holdTimer = -1000;
					dad.holdTimer = -1000;
			}
		} else {
			switch (array[0]) { // this is for turning them off
				case "Turn Off HP Colors":
					game.reloadHealthBarColors();
			}
		}

		if (array[1].antialiasing)
			array[1].setColorTransform(1, 10, 1);
		else
			array[1].setColorTransform(0.5, 0.5, 0.5);
	}

	if (FlxG.mouse.overlaps(buttonL, camPanel) && FlxG.mouse.justPressed && curPage != 0) {
		curPage--;
		regenMenu();
	}

	if (FlxG.mouse.overlaps(buttonR, camPanel) && FlxG.mouse.justPressed && curPage != adminStrings.length - 1) {
		curPage++;
		regenMenu();
	}
}

function opponentNoteHitPost(daNote) {
	for (array in buttons) {
		if (array[1].antialiasing) {
			switch (array[0]) { // this is for thingies that occur when dad presses a note
				case "Opponent Play":
					var singAnims = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

					game.boyfriend.playAnim(singAnims[daNote.noteData]);
			}
		}
	}
}

function goodNoteHitPost(daNote) {
	for (array in buttons) {
		if (array[1].antialiasing) {
			switch (array[0]) { // this is for thingies that occur when dad presses a note
				case "Opponent Play":
					var singAnims = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

					game.dad.playAnim(singAnims[daNote.noteData]);
			}
		}
	}
}

function onBeatHit() {
	for (array in buttons) {
		if (array[1].antialiasing) {
			switch (array[0]) { // this is for thingies that occur when the beat hits
				case "Opponent Play":
					if (game.dad.animation.finished)
						game.dad.dance();

					if (game.boyfriend.animation.finished)
						game.boyfriend.dance();
			}
		}
	}
}

function rgbRecolor(object:Dynamic) {
	var rgb = [FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE];

	rgb.remove(object.color);

	FlxTween.color(object, 1.5, object.color, rgb[FlxG.random.int(0, rgb.length - 1)], {
		onComplete: function(tween) {
			rgbRecolor(object);
		}
	});
}

function regenMenu() {
	curButton = 0;

	for (killShit in [bg, boardText, buttonL, buttonR])
		if (killShit != null)
			killShit.kill();

	bg = new FlxSprite() /*.makeGraphic(300, 400)*/;
	loadBGTheme(themes[FlxG.save.data.theme]);
	bg.cameras = [camPanel];
	add(bg);

	boardText = new FlxText(bg.x - 500, 10, FlxG.width, "504 CHEAT PANEL\nV:" + version.toUpperCase());
	boardText.setFormat(game.scoreTxt.font, 20, game.scoreTxt.color, game.scoreTxt.alignment, game.scoreTxt.borderStyle, game.scoreTxt.borderColor);
	boardText.cameras = [camPanel];
	add(boardText);

	buttonL = new FlxSprite(0, 0).makeGraphic(15, 400, 0xFF303030);
	buttonL.cameras = [camPanel];
	add(buttonL);

	buttonR = new FlxSprite(285, 0).makeGraphic(15, 400, 0xFF303030);
	buttonR.cameras = [camPanel];
	add(buttonR);

	// rgbRecolor(bg);

	for (button in buttons) {
		button[1].destroy();
		buttons.remove(button);
	}

	for (text in texts) {
		text[1].destroy();
		text[2].destroy();
		texts.remove(text);
	}

	texts = [];
	buttons = [];

	for (array in adminStrings[curPage]) {
		curButton++;

		var text = new FlxText(bg.x - 500, curButton * 50, FlxG.width, array[0]);
		var text2 = new FlxText(text.x, text.y + 17, FlxG.width, array[1]);

		var button = new FlxSprite(20, text.y).makeGraphic(250, 40, 0xFF303030);
		button.cameras = [camPanel];
		button.antialiasing = array[2];
		add(button);

		text.setFormat(game.scoreTxt.font, 20, game.scoreTxt.color, game.scoreTxt.alignment, game.scoreTxt.borderStyle, game.scoreTxt.borderColor);
		text.cameras = [camPanel];
		add(text);

		text2.setFormat(game.scoreTxt.font, 15, game.scoreTxt.color, game.scoreTxt.alignment, game.scoreTxt.borderStyle, game.scoreTxt.borderColor);
		text2.cameras = [camPanel];
		add(text2);

		buttons.push([array[0], button]);
		texts.push([array[0], text, text2]);
	}
}

function loadBGTheme(theme:String) {
	switch (theme) {
		case "white", "black", "yellow", "red", "rainbow":
			var color = 0xFFffffff;

			switch(theme) {
				case "black":
					color = 0xff000000;
				case "yellow":
					color = 0xfffbff00;
				case "red":
					color = 0xffff0000;
			}

			bg.makeGraphic(300, 400, color);

			if (theme == "rainbow")
				rgbRecolor(bg);
		default:
			BitmapData.loadFromFile("https://raw.githubusercontent.com/504brandon/504-CHEAT-PANEL/DONT-DOWNLOAD-THIS-IS-USED-FOR-HTTP-THINGS-ONLY/themes/" + theme + ".png")
				.onComplete(function(bitmap:BitmapData) {
					bg.loadGraphic(bitmap);
				});
	}
}