package states.stages;

import backend.window.SnailWindowUtils;
import shaders.*;
import openfl.filters.ShaderFilter;
import states.stages.objects.Speakers;

// import backend.ModChartManager.*;

class CamelliaConcert extends BaseStage {
	// Also blear why do you put the sprites ABOVE the class? Sigh whatever it's fine..
	var sky:BGSprite;
	var buildings:BGSprite;
	var jumpscare:BGSprite;
	var crowdL:BGSprite;
	var crowdR:BGSprite;
	var crowdFront:BGSprite;
	var crowdActive:Bool = false;
	var stage:BGSprite;
	
	var speakerLB:Speakers;
	var speakerLS:Speakers;
	var speakerRB:Speakers;
	var speakerRS:Speakers;
	
	//low quality stuff
	var stageLQ:BGSprite;
	
	//qyoh stuff
	var stars:BGSprite;
	
	//x week stuff
	var claw:BGSprite;
	var crystalL:BGSprite;
	var crystalR:BGSprite;
	var thornL:BGSprite;
	var thornR:BGSprite;
	var gemL:BGSprite;
	var handL:BGSprite;
	var handR:BGSprite;
	var handM:BGSprite;
	var veinL:BGSprite;
	var veinR:BGSprite;
	var vesselL:BGSprite;
	var vesselR:BGSprite;
	var webs:BGSprite;
	var wheel:BGSprite;
	
	//lights control
	var autolights:Bool = true;
	var slowlights:Bool = false;
	
	var saturation = new Saturation();
	var crt = new Crt();
	var crtNoise:Bool = false;
	var bloom = new Bloom();
	var chromaticab = new Chromaticab();
	var pixel = new Pixel();
	
	var shaderTween = {pixel:0.0, chromaticass:0.0};
	
	//moskau-remix modchart vars
	var weee:Bool = false;
	
	//extra character
	var gorl:objects.Character;

	override function create() {
		if (ClientPrefs.data.lowQuality){
			stageLQ = new BGSprite('stages/camellia/concert/stageLQ', 75, 0);
			stageLQ.setGraphicSize(Std.int(stageLQ.width*2));
			add(stageLQ);
			return;
		}

		sky = new BGSprite('stages/camellia/concert/sky', -230,-80);
		sky.setGraphicSize(Std.int(sky.width*1.75));
		add(sky);

		buildings = new BGSprite('stages/camellia/concert/light', -220,-80);
		buildings.setGraphicSize(Std.int(buildings.width*1.75));
		add(buildings);

		jumpscare = new BGSprite('stages/camellia/concert/camelliaJumpscare', 250,-50);
		jumpscare.setGraphicSize(Std.int(jumpscare.width*1.5));
		jumpscare.visible = FlxG.random.bool(10);
		add(jumpscare);

		crowdL = new BGSprite('stages/camellia/concert/backcrowdleft', -850,400);
		crowdL.setGraphicSize(Std.int(crowdL.width*1.75));
		add(crowdL);

		crowdR = new BGSprite('stages/camellia/concert/backcrowdright', 2050,400);
		crowdR.setGraphicSize(Std.int(crowdR.width*1.75));
		add(crowdR);

		//qyoh stuff
		//The reason why i use "this" is because apparently flixel's (v6.1.1) tweens are different when it considers using sprites. So without "this" it'll make the strums invisible and notes.
		switch (songName) {
			case 'qyoh-(nine-stars)':
			this.stars = new BGSprite('stages/camellia/concert/qyoh/ninestars', 600,-100);
			this.stars.setGraphicSize(Std.int(stars.width*3));
			this.stars.antialiasing = ClientPrefs.data.antialiasing;
			add(this.stars);

			FlxTween.num(0, 360, 5, {ease: FlxEase.backInOut, type: LOOPING}, function(v:Float) {
				if (this.stars != null && this.stars.exists) {
					this.stars.angle = v;
				}
			});
		}

		stage = new BGSprite('stages/camellia/concert/stage', -1250,-620);
		stage.setGraphicSize(Std.int(stage.width*0.85));
		add(stage);

		speakerRS = new Speakers(1350,150,false,true,ClientPrefs.data.shaders);
		add(speakerRS);
		speakerLB = new Speakers(-450,50,true,false,ClientPrefs.data.shaders);
		add(speakerLB);
		speakerLS = new Speakers(-150,150,false,false,ClientPrefs.data.shaders);
		add(speakerLS);
		speakerRB = new Speakers(1050,50,true,true,ClientPrefs.data.shaders);
		add(speakerRB);

		if (ClientPrefs.data.shaders){
			//reset the shaders only in case
			crt.distortionOn.value = [false];
			crt.perspectiveOn.value = [false];
			crt.scanlinesOn.value = [false];
			crt.vignetteOn.value = [false];
			crtNoise = false;
			crt.iTime.value = [0];
			shaderTween.chromaticass = 0.0;
			shaderTween.pixel = 1.0;
			pixel.intensity.value = [1.0];
			saturation.enableEffects.value = [false];
			chromaticab.iOffset.value = [0.0];

			// switch(formattedSong){
			// 	case 'moskau-remix':
			// 		prepareWindowModchart();
			// 	case 'racemization':
			// 		camGame.setFilters([new ShaderFilter(saturation), new ShaderFilter(chromaticab)]);
			// 		camArrows.setFilters([new ShaderFilter(chromaticab)]);
			// 		camHUD.setFilters([new ShaderFilter(chromaticab)]);
			// 	case 'satellite':
			// 		camGame.setFilters([new ShaderFilter(crt), new ShaderFilter(pixel)]);
			// 		camArrows.setFilters([new ShaderFilter(crt), new ShaderFilter(pixel)]);
			// 		camHUD.setFilters([new ShaderFilter(crt), new ShaderFilter(pixel)]);
			// 	case 'first-video-game':
			// 		crtNoise = true;
			// 		crt.distortionOn.value = [true];
			// 		crt.perspectiveOn.value = [true];
			// 		crt.scanlinesOn.value = [true];
			// 		crt.vignetteOn.value = [true];
			// 		pixel.intensity.value = [3.0];
			// 		camGame.setFilters([new ShaderFilter(pixel), new ShaderFilter(crt)]);
			// 		camArrows.setFilters([new ShaderFilter(pixel), new ShaderFilter(crt)]);
			// 		camHUD.setFilters([new ShaderFilter(pixel), new ShaderFilter(crt)]);
			// 	case 'galaxy-burst':
			// 		camGame.setFilters([new ShaderFilter(chromaticab)]);
			// 		camArrows.setFilters([new ShaderFilter(chromaticab)]);
			// 		camHUD.setFilters([new ShaderFilter(chromaticab)]);
			// 	case 'brace-for-fricking-impact'|'tera-io'|'memoryleak':
			// 		gorl = new objects.Character(400,110, 'gf', !ClientPrefs.lowQuality);
			// 		gorl.scrollFactor.set(0.95, 0.95);
			// 		////PlayState.instance.startCharacterPos(gorl, true);
			// 		add(gorl);
			// }
		}
	}
	override function createPost() {
		if (ClientPrefs.data.lowQuality)
			return;
		crowdFront = new BGSprite('stages/camellia/concert/frontcrowd', -220,1500);
		crowdFront.setGraphicSize(Std.int(crowdFront.width*1.75));
		add(crowdFront);

		switch(songName){
		case 'qyoh-(nine-stars)':
			sky.color = 0xff353536;
			buildings.color = 0xff353536;
			stage.color = 0xff353536;
			speakerRS.color = 0xff474747;
			speakerLB.color = 0xff474747;
			speakerLS.color = 0xff474747;
			speakerRB.color = 0xff474747;
			boyfriend.color = 0xff474747;
			gf.color = 0xff474747;
			dad.color = 0xff474747;
			crowdL.color = 0xff474747;
			crowdR.color = 0xff474747;
			crowdFront.color = 0xff474747;
		// 	case 'galaxy-burst':
		// 		for (i in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront])
		// 			i.color = 0xff252525;
		// 		autolights = false;
		// 		buildings.color = 0x00000000;
		// 		camHUD.alpha = 0;
		}
	}

	override function update(t:Float){
		if (crtNoise)
		crt.iTime.value = [t];

		// if (formattedSong == 'moskau-remix' && weee)
		// 	{
		// 		var currentBeat:Float = (backend.Conductor.songPosition / 1000) * (backend.Conductor.bpm/60);
		// 		//windowPosTween(0, 50-50*Math.sin((currentBeat)*Math.PI), 0.5);
		// 		for (i in 0...4){
		// 			playerArrowTween('webos$i', i, -40*Math.sin((currentBeat)*Math.PI), 0, 0, 1, 0.5);
		// 			opponentArrowTween('frijol$i', i, -40*Math.sin((currentBeat)*Math.PI), 0, 0, 1, 0.5);
		// 		}
		// 	}
		var lerp:Float = CoolUtil.boundTo(1 - (t*9*1), 0, 1);
		crowdL.scale.x = crowdL.scale.y = FlxMath.lerp(1.75, crowdL.scale.x, lerp);
		crowdR.scale.x = crowdR.scale.y = FlxMath.lerp(1.75, crowdR.scale.x, lerp);
		crowdFront.scale.x = crowdFront.scale.y = FlxMath.lerp(1.75, crowdFront.scale.x, lerp);
	}
	
	override function stepHit(){
		if (ClientPrefs.data.lowQuality)
			return;
		switch(songName){
		// 	case 'moskau-remix':
		// 		if (curStep == 1)
		// 			weee = true;
		// 		if (curStep == 650 || curStep == 1521 || curStep == 2337){
		// 			weee = false;
		// 			for (i in 0...4){
		// 				playerArrowTween('webos$i', i, -320, 0, -360, 1, 1, 'quadinout');
		// 			}
		// 			opponentArrowTween('frijol0', 0, -10, 0, -360, 1, 1, 'quadinout');
		// 			opponentArrowTween('frijol1', 1, 30, 0, -360, 1, 1, 'quadinout');
		// 			opponentArrowTween('frijol2', 2, 600, 0, 360, 1, 1, 'quadinout');
		// 			opponentArrowTween('frijol3', 3, 640, 0, 360, 1, 1, 'quadinout');
		// 		}
		// 		if (curStep == 904 || curStep == 1776 || curStep == 2592)
		// 			weee = true;
		// 	case 'racemization':
		// 		switch(curStep){
		// 			case 1726:
		// 				slowlights = true;
		// 			case 2223:
		// 				slowlights = false;
		// 			case 2228:
		// 				autolights = false;
		// 				FlxTween.tween(shaderTween, {chromaticass:1}, 1, {ease:FlxEase.quadInOut,
		// 					onUpdate: tween->chromaticab.iOffset.value = [shaderTween.chromaticass]
		// 				});
		// 			case 2238:
		// 				FlxTween.cancelTweensOf(shaderTween);
		// 				for (i in [PlayState.boetrail,PlayState.girltrail, PlayState.snailtrail]){
		// 					i.active = true;
		// 					i.visible = true;
		// 				}
		// 				autolights = false;
		// 				shaderTween.chromaticass = 0.004;
		// 				saturation.enableEffects.value = [true];
		// 				chromaticab.iOffset.value = [0.004];
		// 				camHUD.flash();
		// 				//slow drop
		// 				concertDropRS();
		// 			case 2250 | 2274 | 2282 | 2288 | 2302 | 2314 | 2338 | 2346 | 2352 | 2366 | 2376
		// 			| 2402 | 2410 | 2416 | 2430 | 2442 | 2466:
		// 				concertDropRS();
		// 			//fast drop
		// 			case 2500 | 2506 | 2512 | 2518 | 2532 | 2538 | 2544 | 2550 | 2564 | 2570 | 2576
		// 			| 2582 | 2596 | 2602 | 2608 | 2614:
		// 				concertDropRF();
		// 			case 2622:
		// 				camGame.setFilters([]);
		// 				camArrows.setFilters([]);
		// 				camHUD.setFilters([]);
		// 				for (i in [PlayState.boetrail,PlayState.girltrail, PlayState.snailtrail]){
		// 					i.active = false;
		// 					i.visible = false;
		// 				}
		// 				stage.color = 0xffffffff;
		// 				autolights = true;
		// 				camHUD.flash();
		// 		}
		// 	case 'satellite':
		// 		switch (curStep){
		// 			case 1821:
		// 				camHUD.flash(FlxColor.WHITE, 0.5);
		// 				crt.distortionOn.value = [true];
		// 				crt.perspectiveOn.value = [true];
		// 				crt.scanlinesOn.value = [true];
		// 				crt.vignetteOn.value = [true];
		// 				crtNoise = true;
		// 				pixel.intensity.value = [3.0]; //means 1/2 of the og resolution
		// 			case 1951:
		// 				camHUD.flash(FlxColor.WHITE, 0.5);
		// 				crt.distortionOn.value = [false];
		// 				crt.perspectiveOn.value = [false];
		// 				crt.scanlinesOn.value = [false];
		// 				crt.vignetteOn.value = [false];
		// 				crtNoise = false;
		// 				crt.iTime.value = [0];
		// 				pixel.intensity.value = [1.0];
		// 		}
		case 'qyoh-(nine-stars)':
			switch(curStep){
				case 363:
					for (neo in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront])
						FlxTween.color(neo, 10, neo.color, 0xff777216);
				case 6720:
					for (dazzy in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront])
						FlxTween.color(dazzy, 10, dazzy.color, 0xff474747);
				case 6800:
					camHUD.fade(FlxColor.BLACK, 2);
			}
		// 	case 'galaxy-burst':
		// 		switch(curStep){
		// 			case 5:
		// 				FlxTween.tween(camHUD, {alpha: 1}, 1, {ease:FlxEase.quadInOut});
		// 			case 26:
		// 				FlxTween.color(dad, 10, dad.color, 0xff9999dd, {ease: FlxEase.quadInOut});
		// 			case 152:
		// 				FlxTween.color(boyfriend, 3, boyfriend.color, 0xff9999dd, {ease: FlxEase.quadInOut});
		// 			case 224:
		// 				new FlxTimer().start(0.5, function(ass:FlxTimer):Void{
		// 					FlxTween.color(sky, 0.5, sky.color, 0xffaaaaaa, {ease: FlxEase.quadInOut, 
		// 						onComplete: tween->{
		// 							autolights =true;
		// 							slowlights = true;
		// 						}});
		// 				});
		// 			case 352:
		// 				camHUD.flash();
		// 				slowlights = false;
		// 				for (bruh in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront, buildings, sky])
		// 					bruh.color = 0xffffffff;
		// 			case 1568:
		// 				slowlights = true;
		// 				for (bart in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront]){
		// 					bart.color = 0xff252525;
		// 					FlxTween.color(bart, 15, bart.color, 0xffffffff, {ease: FlxEase.quadInOut, onComplete:tween -> {slowlights = false;}});
		// 				}
		// 			case 3120:
		// 				for (rats in [stage, boyfriend, dad, gf, speakerRS, speakerRB, speakerLB, speakerLS, crowdL, crowdR, crowdFront]){
		// 					slowlights = true;
		// 					rats.color = 0xff252525;
		// 					FlxTween.color(rats, 1, rats.color, 0xff444444, {ease: FlxEase.quadInOut});
		// 				}
		// 			case 384|400|448|512|752|784|880|1312|1440|1512|1520|1528|1536
		// 			|1856|1872|1920|1936|1984|2000:
		// 			chromaticab.iOffset.value = [0.004];
		// 			case 394|416|480|536|780|872|1006|1425|1507|1517|1525|1532|1568
		// 			|1868|1884|1932|1949|1996|2009|2010:
		// 			chromaticab.iOffset.value = [0.0];
		// 		}
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, value3:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float){
		if (ClientPrefs.data.lowQuality)
			return;
		switch(eventName){
			case 'camelliazoom':
				PlayState.instance.camZooming = false;
				var zoom:Int = Std.parseInt(value1);
				var duration:Float = Std.parseFloat(value2);
				var easing:String = value3;
				if (Math.isNaN(zoom))
					zoom = 2;
				if (Math.isNaN(duration))
					duration = 1;
				concertZoom(zoom, duration, easing);
		}
	}
	var citycycle:Int = 1;
	function concertLights(bruh:Bool){
		if(bruh)
			return;
		switch(citycycle){
			case 1:
				buildings.color = 0xff00b1ff;
				SnailWindowUtils.changeWindowColor(0x00, 0xb1, 0xff);
				citycycle = 2;
				return;
			case 2:
				buildings.color = 0xffff432c;
				SnailWindowUtils.changeWindowColor(0xff, 0x43, 0x2c);
				citycycle = 3;
				return;
			case 3:
				buildings.color = 0xffff30fa;
				SnailWindowUtils.changeWindowColor(0xff, 0x30, 0xfa);
				citycycle = 4;
				return;
			case 4:
				buildings.color = 0xff00fd86;
				SnailWindowUtils.changeWindowColor(0x00, 0xfd, 0x86);
				citycycle = 5;
				return;
			case 5:
				buildings.color = 0xffffa71f;
				SnailWindowUtils.changeWindowColor(0xff, 0xa7, 0x1f);
				citycycle = 1;
				return;
		}
	}
	function slowLights(bruh:Bool){
		if(!bruh)
			return;
		FlxTween.cancelTweensOf(buildings);
		switch(citycycle){
			case 1:
				FlxTween.color(buildings, 0.5, buildings.color, 0xff00b1ff);
				citycycle = 2;
				return;
			case 2:
				FlxTween.color(buildings, 0.5, buildings.color, 0xffff432c);
				citycycle = 3;
				return;
			case 3:
				FlxTween.color(buildings, 0.5, buildings.color, 0xffff30fa);
				citycycle = 4;
				return;
			case 4:
				FlxTween.color(buildings, 0.5, buildings.color, 0xff00fd86);
				citycycle = 5;
				return;
			case 5:
				FlxTween.color(buildings, 0.5, buildings.color, 0xffffa71f);
				citycycle = 1;
				return;
		}
	}
	var drop:Int = 1;
	function concertDropRS(){
		camGame.zoom += 0.1;
		camHUD.zoom += 0.03;
		// camArrows.zoom += 0.03;
		switch(drop){
			case 1:
				buildings.color = 0xff00ffff;
				stage.color = 0xff00ffff;
				drop = 2;
			case 2:
				buildings.color = 0xff12fa05;
				stage.color = 0xff12fa05;
				drop = 3;
			case 3:
				buildings.color = 0xff8b78bc;
				stage.color = 0xff8b78bc;
				drop = 1;
		}
	}
	function concertDropRF(){
		camGame.zoom += 0.1;
		camHUD.zoom += 0.03;
		// camArrows.zoom += 0.03;
		switch(drop){
			case 1:
				buildings.color = 0xff8b78bc;
				stage.color = 0xff8b78bc;
				drop = 2;
			case 2:
				buildings.color = 0xff00ffff;
				stage.color = 0xff00ffff;
				drop = 3;
			case 3:
				buildings.color = 0xff12fa05;
				stage.color = 0xff12fa05;
				drop = 1;
			case 4:
				buildings.color = 0xfff9393f;
				stage.color = 0xfff9393f;
				drop = 5;
		}
	}
	function concertZoom(zoomType:Int = 2, time:Float = 1, easing:String){
		var zoomgame:Float;
		var zoomhud:Float;
		switch(zoomType) {
			case 1:
				zoomgame = 0.41;
				zoomhud = 0.8;
				crowdActive = true;
			case 2:
				zoomgame = 0.59;
				zoomhud = 1;
				crowdActive = false;
			case 3:
				zoomgame = 0.47;
				zoomhud = 0.9;
				crowdActive = true;
			default:
				zoomgame = 0.59;
				zoomhud = 1;
				crowdActive = false;
		}

		FlxTween.tween(camGame, {zoom: zoomgame}, time, {
			ease: CoolUtil.getFlxEaseByString(easing),
			onComplete: function(twn:FlxTween) {
				defaultCamZoom = zoomgame;
				PlayState.instance.camZooming = true;
			}
		});
	
		if (ClientPrefs.data.camHUDOption) {
			FlxTween.tween(camHUD, {zoom: zoomhud}, time, {
				ease: CoolUtil.getFlxEaseByString(easing),
				onComplete: function(twn:FlxTween) {
					camHUD.zoom = zoomhud;
				}
			});
		}
		//crowd tween
		//if (ClientPrefs.data.lowQuality)
		//	return; not necessary since we already check it before...
		if (crowdActive)
			FlxTween.tween(crowdFront, {y: 690}, time, {ease:FlxEase.quadInOut});
		else
			FlxTween.tween(crowdFront, {y: 1500}, time, {ease:FlxEase.quadInOut});
	}
	override function beatHit() {
		if (ClientPrefs.data.lowQuality)
			return;
		if (curBeat % 2 == 0){
		for(fart in [speakerLB, speakerLS, speakerRB, speakerRS])
		fart.playMe();
			//crowdBumpin
			// if (crowdActive){
			// 	for (jaldabo in  [crowdL, crowdR, crowdFront]){
			// 		FlxTween.cancelTweensOf(jaldabo.scale);
			// 		jaldabo.scale.x = 1.85;
			// 		jaldabo.scale.y = 1.85;
			// 		FlxTween.tween(jaldabo.scale, {x:1.75, y:1.75}, 0.5, {ease: FlxEase.quartOut});
			// 	}
			// }
			crowdL.scale.x = crowdL.scale.y = 1.85;
			crowdR.scale.x = crowdR.scale.y = 1.85;
			crowdFront.scale.x = crowdFront.scale.y = 1.85;
		}

		if (curBeat % 3 == 0 && autolights){
			concertLights(slowlights);
			slowLights(slowlights);
		}

		// if (formattedSong == 'brace-for-fricking-impact' || formattedSong == 'tera-io'|| formattedSong == 'memoryleak')
		// 	if (gorl != null&& curBeat % 2 == 0)
		// 		gorl.dance();
	}

	override function destroy()
	{
		SnailWindowUtils.changeWindowColor();
		#if windows
		backend.window.CppAPI.darkMode();
		#end
	}
}