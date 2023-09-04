package states.stages;

import states.stages.objects.*;

class ExeHill extends BaseStage
{
	var midtrees1:BGSprite;
	var treesmid:BGSprite;
	var treesoutermid:BGSprite;
	var treesoutermid2:BGSprite;
	var lefttrees:BGSprite;
	var righttrees:BGSprite;
	var outerbush:BGSprite;
	var outerbush2:BGSprite;
	var grass:BGSprite;
	var deadegg:BGSprite;
	var deadknux:BGSprite;
	var deadtailz:BGSprite;
	var deadtailz1:BGSprite;
	var deadtailz2:BGSprite;
	var fgTrees:BGSprite;
	override function create()
	{
		var sky:BGSprite = new BGSprite('stages/exeHill/BGSky', -600, -200, 1, 1);
		sky.setGraphicSize(Std.int(sky.width * 1.4));
		sky.antialiasing = ClientPrefs.data.antialiasing;
		add(sky);

		var midTrees1:BGSprite = new BGSprite('stages/exeHill/TreesMidBack', -600, -200, 0.7, 0.7);
		midTrees1.setGraphicSize(Std.int(midTrees1.width * 1.4));
		midTrees1.antialiasing = ClientPrefs.data.antialiasing;
		add(midTrees1);

		var treesmid:BGSprite = new BGSprite('stages/exeHill/TreesMid', -600, -200,  0.7, 0.7);
		treesmid.setGraphicSize(Std.int(treesmid.width * 1.4));
		treesmid.antialiasing = ClientPrefs.data.antialiasing;
		add(treesmid);

		var treesoutermid:BGSprite = new BGSprite('stages/exeHill/TreesOuterMid1', -600, -200, 0.7, 0.7);
		treesoutermid.setGraphicSize(Std.int(treesoutermid.width * 1.4));
		treesoutermid.antialiasing = ClientPrefs.data.antialiasing;
		add(treesoutermid);

		var treesoutermid2:BGSprite = new BGSprite('stages/exeHill/TreesOuterMid2', -600, -200,  0.7, 0.7);
		treesoutermid2.setGraphicSize(Std.int(treesoutermid2.width * 1.4));
		treesoutermid2.antialiasing = ClientPrefs.data.antialiasing;
		add(treesoutermid2);

		var lefttrees:BGSprite = new BGSprite('stages/exeHill/TreesLeft', -600, -200,  0.7, 0.7);
		lefttrees.setGraphicSize(Std.int(lefttrees.width * 1.4));
		lefttrees.antialiasing = ClientPrefs.data.antialiasing;
		add(lefttrees);

		var righttrees:BGSprite = new BGSprite('stages/exeHill/TreesRight', -600, -200, 0.7, 0.7);
		righttrees.setGraphicSize(Std.int(righttrees.width * 1.4));
		righttrees.antialiasing = ClientPrefs.data.antialiasing;
		add(righttrees);

		var outerbush:BGSprite = new BGSprite('stages/exeHill/OuterBush', -600, -150, 1, 1);
		outerbush.setGraphicSize(Std.int(outerbush.width * 1.4));
		outerbush.antialiasing = ClientPrefs.data.antialiasing;
		add(outerbush);

		var outerbush2:BGSprite = new BGSprite('stages/exeHill/OuterBushUp', -600, -200, 1, 1);
		outerbush2.setGraphicSize(Std.int(outerbush2.width * 1.4));
		outerbush2.antialiasing = ClientPrefs.data.antialiasing;
		add(outerbush2);

		var grass:BGSprite = new BGSprite('stages/exeHill/Grass', -600, -150, 1, 1);
		grass.setGraphicSize(Std.int(grass.width * 1.4));
		grass.antialiasing = ClientPrefs.data.antialiasing;
		add(grass);

		var deadegg:BGSprite = new BGSprite('stages/exeHill/DeadEgg', -600, -200, 1, 1);
		deadegg.setGraphicSize(Std.int(deadegg.width * 1.4));
		deadegg.antialiasing = ClientPrefs.data.antialiasing;
		add(deadegg);

		var deadknux:BGSprite = new BGSprite('stages/exeHill/DeadKnux', -600, -200, 1, 1);
		deadknux.setGraphicSize(Std.int(deadknux.width * 1.4));
		deadknux.antialiasing = ClientPrefs.data.antialiasing;
		add(deadknux);

		var deadtailz:BGSprite = new BGSprite('stages/exeHill/DeadTailz', -700, -200, 1, 1);
		deadtailz.setGraphicSize(Std.int(deadtailz.width * 1.4));
		deadtailz.antialiasing = ClientPrefs.data.antialiasing;
		add(deadtailz);

		var deadtailz1:BGSprite = new BGSprite('stages/exeHill/DeadTailz1', -600, -200, 1, 1);
		deadtailz1.setGraphicSize(Std.int(deadtailz1.width * 1.4));
		deadtailz1.antialiasing = ClientPrefs.data.antialiasing;
		add(deadtailz1);

		var deadtailz2:BGSprite = new BGSprite('stages/exeHill/DeadTailz2', -600, -400, 1, 1);
		deadtailz2.setGraphicSize(Std.int(deadtailz2.width * 1.4));
		deadtailz2.antialiasing = ClientPrefs.data.antialiasing;
		add(deadtailz2);

		var fgTrees = new BGSprite('stages/exeHill/TreesFG', -610, -200, 1.1, 1.1);
		fgTrees.setGraphicSize(Std.int(fgTrees.width * 1.45));
		fgTrees.antialiasing = ClientPrefs.data.antialiasing;
		add(fgTrees);

	}
}