package states.stages;

import cutscenes.DialogueBoxPsych; // to use dialogue json

import states.stages.objects.*;

class MangoPark extends BaseStage
{
    var mangoPark:FlxSprite; // mango park mango park mango park mango park police being racist!!11! IVY X SDPJ COLLAB

    override function create()
    {
        mangoPark = new FlxSprite(10, 30).loadGraphic(Paths.image('stages/IvyVsBF/ivybg'));
        mangoPark.scale.set(1, 1);
        mangoPark.antialiasing = ClientPrefs.data.antialiasing;
        add(mangoPark);

        if (!isStoryMode)
        {
            switch (songName)
            {
                case 'ivy': //FUCK YOU LUA WE'RE GOING SOURCE CODE!!
                    if (!seenCutscene) {
                        setStartCallback(function() {
                           game.startVideo('IvyVsBF/ivy cutscene');
                           game.videoCutscene.finishCallback = game.videoCutscene.onSkip = function() {
                                game.videoCutscene = null;
                                game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue')),'freakyMenuIvy'); // this plays the cutscene first then plays the dialogue in source code :D + THE MUSIC WOWW!
                            }
                        });
                    }
            }
        }
    }

}