@echo off
color 0a
cd ..
@echo on
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib install lime 8.1.3
haxelib install openfl 9.4.1
haxelib install flixel 5.6.2
haxelib install flixel-addons 3.2.2
haxelib install flixel-tools 1.5.1
haxelib install hscript-iris 1.1.3
haxelib install tjson 1.4.0
haxelib install hxdiscord_rpc 1.3.0
haxelib install hxvlc 2.0.1 --skip-dependencies
haxelib install hxWindowColorMode 0.2.0
haxelib install away3d
haxelib install haxeui-core
haxelib install haxeui-flixel
haxelib install json2object
haxelib install hxgamejolt-api
haxelib set lime 8.1.3
haxelib set openfl 9.4.1
haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate 768740a56b26aa0c072720e0d1236b94afe68e3e
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 1906c4a96f6bb6df66562b3f24c62f4c5bba14a7
haxelib git funkin.vis https://github.com/MishaMishaXN/funkVis-FrequencyFixed
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666
haxelib git linc_dialogs https://github.com/snowkit/linc_dialogs.git
haxelib git moonchart https://github.com/MaybeMaru/moonchart
haxelib git FunkinModchart https://github.com/theoo-h/FunkinModchart dev
haxelib git flxsoundfilters https://github.com/TheZoroForce240/FlxSoundFilters
echo Finished!
pause
