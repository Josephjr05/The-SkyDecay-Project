package states.stages;

import cutscenes.DialogueBoxPsych; // to use dialogue json

import objects.Note;
import backend.Song;
import shaders.Bloom;
import shaders.Chromaticab;
import shaders.Glitch;
import openfl.filters.ShaderFilter;

var bg:BGSprite;
var stage:BGSprite;
var fg:BGSprite;
var planetshaper:BGSprite;

var bloom = new Bloom();
var chromatic = new Chromaticab();
var glitch = new Glitch();
var shadertween = {chromaticass:0.002};

class Planet extends BaseStage{
	override function create(){
		bg = new BGSprite('stages/camellia/planet/background', -1400, -450);
		bg.setGraphicSize(Std.int(bg.width * 2));
		add(bg);

		planetshaper = new BGSprite('stages/camellia/planet/planetshaper', 100, -500);
		planetshaper.setGraphicSize(Std.int(bg.width * .8));
		add(planetshaper);

		stage = new BGSprite('stages/camellia/planet/stage', -600, -650);
		stage.setGraphicSize(Std.int(stage.width * 1.9));
		add(stage);

		if (ClientPrefs.data.shaders){
			bloom.size.value = [8.0];
			chromatic.iOffset.value = [0.002];
			camHUD.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic)]); //was camArrows
			camGame.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic)]);
			camGame.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic), new ShaderFilter(glitch)]);
		}

		if (!isStoryMode)
		{
			switch (songName)
			{
				case 'dreamless-wanderer': //FUCK YOU LUA WE'RE GOING SOURCE CODE!!
					if (!seenCutscene) {
						setStartCallback(function() {
							game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue')),'peacefulGalaxy');
						});
				}
			}
		}
	}
	
	override function createPost(){
		fg = new BGSprite('stages/camellia/planet/foreground', -1200, -1500);
		fg.setGraphicSize(Std.int(fg.width * 2.5));
		add(fg);
	}
}