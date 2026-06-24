package states.stages;

import objects.Note;
import backend.Song;
import shaders.Bloom;
import shaders.Chromaticab;
import shaders.Glitch;
import openfl.filters.ShaderFilter;

var bg:BGSprite;
var mountainBack:BGSprite;
var mountainBackR:BGSprite;
var mountainBackL:BGSprite;
var light:BGSprite;
var fog:BGSprite;
var fog2:BGSprite;
var monolith:BGSprite;
var flameR:BGSprite;
var flameL:BGSprite;
var mountainC:BGSprite;
var mountainL:BGSprite;
var mountainR:BGSprite;

var bgLQ:BGSprite;

var bloom = new Bloom();
var chromatic = new Chromaticab();
var glitch = new Glitch();
var shadertween = {chromaticass:0.002};

class Cyphisonia extends BaseStage {
	override function create(){
		if (ClientPrefs.data.lowQuality){
			bgLQ = new BGSprite('stages/camellia/cyphisonia/cyphisoniaLQ', -900, -100);
			bgLQ.setGraphicSize(Std.int(bgLQ.width * 4));
			add(bgLQ);
			return;
		}
		bg = new BGSprite('stages/camellia/cyphisonia/bg', -1050, -450, .5, .5);
		bg.setGraphicSize(Std.int(bg.width * 2));
		add(bg);

		mountainBack = new BGSprite('stages/camellia/cyphisonia/mountain_c', -650, 200, .5, .5);
		mountainBack.setGraphicSize(Std.int(mountainBack.width * 2.2));
		add(mountainBack);

		mountainBackR = new BGSprite('stages/camellia/cyphisonia/mountain_r', 1150, 350, .7, .7);
		mountainBackR.setGraphicSize(Std.int(mountainBackR.width * 2.2));
		add(mountainBackR);

		mountainBackL = new BGSprite('stages/camellia/cyphisonia/mountain_r', -1150, 350, .7, .7);
		mountainBackL.setGraphicSize(Std.int(mountainBackL.width * 2.2));
		mountainBackL.flipX = true;
		add(mountainBackL);

		light = new BGSprite('stages/camellia/cyphisonia/light', -1100, -500, .8, .8);
		light.setGraphicSize(Std.int(light.width * 2));
		add(light);

		fog = new BGSprite('stages/camellia/cyphisonia/fog_1', -1300, -50, .8, .8);
		fog.setGraphicSize(Std.int(fog.width * 2.2));
		fog.alpha = .8;
		add(fog);

		fog2 = new BGSprite('stages/camellia/cyphisonia/fog_2', 650, -50, .8, .8);
		fog2.setGraphicSize(Std.int(fog2.width * 2.2));
		fog2.alpha = .8;
		add(fog2);

		monolith = new BGSprite('stages/camellia/cyphisonia/monolith', 100, -250, .7, .7);
		monolith.setGraphicSize(Std.int(monolith.width * 2));
		add(monolith);

		flameR = new BGSprite('stages/camellia/cyphisonia/flame_r', 1300, 350, .7, .7);
		flameR.setGraphicSize(Std.int(flameR.width * 2));
		add(flameR);

		flameL = new BGSprite('stages/camellia/cyphisonia/flame_l', -1600, -300, .7, .7);
		flameL.setGraphicSize(Std.int(flameL.width * 2.3));
		add(flameL);

		mountainC = new BGSprite('stages/camellia/cyphisonia/mountain_c', -1000, 400);
		mountainC.setGraphicSize(Std.int(mountainC.width * 2.2));
		add(mountainC);

		mountainL = new BGSprite('stages/camellia/cyphisonia/mountain_l', -1650, 1250);
		mountainL.setGraphicSize(Std.int(mountainL.width * 2));
		add(mountainL);

		mountainR = new BGSprite('stages/camellia/cyphisonia/mountain_r', 950, 1200, 1.2, 1.2);
		mountainR.setGraphicSize(Std.int(mountainR.width * 2));
		add(mountainR);

		if (ClientPrefs.data.shaders){
			bloom.size.value = [8.0];
			chromatic.iOffset.value = [0.002];
			camHUD.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic)]); //was camArrows but since skydecay/psych doesn't use extra cameras it's just camHUD for now.
			camGame.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic)]);
			// if (formattedSong == 'relic-in-letters')
			// 	camGame.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic), new ShaderFilter(glitch)]);
		}
	}
	override function createPost(){
		if (ClientPrefs.data.lowQuality)
			return;
		dad.color = 0xffd9d9d9;
		boyfriend.color = 0xffd9d9d9;
		// for (i in [PlayState.boetrail, PlayState.snailtrail]){
		// 	i.active = true;
		// 	i.visible = true;
		// }
		switch(songName){
			case 'welcome-cyphisonia':
				for (bruh in [mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR, boyfriend, dad]){
					bruh.color = 0xff000000;
				}
		}
	}
	override function eventCalled(eventName:String, value1:String, value2:String, value3:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float){
		if (ClientPrefs.data.lowQuality || !ClientPrefs.data.shaders)
			return;
		switch(eventName){
		    case 'Add Camera Zoom':
			    for(camera in [camGame, camHUD])
			    	camera.shake(0.001);
			    FlxTween.cancelTweensOf(shadertween);
			    chromatic.iOffset.value = [0.008];
			    shadertween.chromaticass = 0.008;
			    FlxTween.tween(shadertween, {chromaticass: 0.002}, 0.5, {ease: FlxEase.quadInOut, 
			    	onUpdate: flxTween->{chromatic.iOffset.value = [shadertween.chromaticass];}
			    });
		}
	}
	var alreadyHidden = false;
	override function update(elapsed) {
		if (ClientPrefs.data.lowQuality || !ClientPrefs.data.shaders)
			return;

		glitch.iTime.value = [Conductor.songPosition/1000];
		FlxTween.tween(monolith,{y: -250-40*Math.sin(((Conductor.songPosition/1000)*(PlayState.SONG.bpm/80)*0.1)*Math.PI)}, 0.001);
		FlxTween.tween(fog2,{x: 650+40*Math.sin(((Conductor.songPosition/1000)*(PlayState.SONG.bpm/80)*0.1)*Math.PI)}, 0.001);
		FlxTween.tween(fog,{x: -1300-40*Math.sin(((Conductor.songPosition/1000)*(PlayState.SONG.bpm/80)*0.1)*Math.PI)}, 0.001);

		// if (health > 1.5 && !alreadyHidden){
		// 	alreadyHidden = true;
		// 	FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
		// } else if (health < 1.5 && alreadyHidden){
		// 	alreadyHidden = false;
		// 	FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.circOut});
		// }
	}
	override function stepHit(){
		if (ClientPrefs.data.lowQuality || !ClientPrefs.data.shaders)
			return;
		switch (songName) {
		// 	case 'relic-in-letters':
		// if (curStep >= 288 && curStep % 8 == 0 && curStep <= 956){
		// 	camGame.zoom += 0.02;
		// 	camGame.shake(0.005);
		// }
		// if (curStep == 304){
		// 	camGame.setFilters([new ShaderFilter(bloom), new ShaderFilter(chromatic)]);
		// 	camGame.flash();
		// }
		// if (curStep == 832){
		// 	camGame.setFilters ([new ShaderFilter(bloom), new ShaderFilter(chromatic), new ShaderFilter(glitch)]);
		// 	camGame.flash();
		// }
		// if (curStep == 961){
		// 	for (fard in [boyfriend, mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR]){
		// 		FlxTween.color(fard, 1, 0xffffffff, 0xff000000, {ease: FlxEase.circOut});
		// 	}
		// }
		// if (curStep == 1057){
		// 	camGame.setFilters([new ShaderFilter(bloom), new ShaderFilter(chromatic)]);
		// 	FlxTween.color(dad, 1, 0xffffffff, 0xff000000, {ease: FlxEase.circOut});
		// }
		case 'welcome-cyphisonia':
			switch(curStep) {
			case 38:
				FlxTween.color(dad, 8, dad.color, 0xffd9d9d9, {ease: FlxEase.linear});
			case 144:
				FlxTween.color(boyfriend, 2.3, boyfriend.color, 0xffd9d9d9, {ease: FlxEase.quadInOut});
			case 480:
				camGame.flash();
				for (i in [mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR]){
					i.color=0xffffffff;
				}
			case 1504:
				camGame.flash();
			case 1888:
				for (i in [mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR, bg]){
					FlxTween.color(i, 0.5, i.color, 0xff000000, {ease: FlxEase.quadInOut});
				}
			case 1892:
				for (i in [mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR, bg]){
					FlxTween.color(i, 0.1, i.color, 0xffffffff, {ease: FlxEase.quadInOut});
				}
			case 2400:
				for (i in [mountainBack, mountainBackR, mountainBackL, fog, fog2, flameR, flameL, mountainC, mountainL, mountainR]){
					FlxTween.color(i, 10, i.color, 0xff000000, {ease: FlxEase.linear});
				}
			case 2408:
				camGame.setFilters([new ShaderFilter(bloom), new ShaderFilter(chromatic), new ShaderFilter(glitch)]);
			case 2465:
				for (i in [dad, boyfriend]) {
					FlxTween.color(i, 6, i.color, 0xff000000, {ease: FlxEase.quadInOut});
				}
            }
		}
	}
	//at this point i just want to finish and it isn't like the cyphisonia songs have crazy hard charts
	override function opponentNoteHit(note:Note) {
		if (ClientPrefs.data.lowQuality)
			return;
		if (!note.isSustainNote && curStep >= 1184 && curStep <= 1432 && songName == 'welcome-cyphisonia' && ClientPrefs.data.flashing) {
			camGame.stopFX();
			camGame.flash(0x38ffffff, 0.1);
		}
    }
}