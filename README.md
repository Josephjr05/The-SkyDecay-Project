### Welcome to YOUR ultimate Friday Night Funkin' engine. Yes, seriously. Because no other engine does/has these so some noobie has to do it instead. (With some help that has experience :D)

# SkyDecay Engine 
![1000036631](https://github.com/user-attachments/assets/bcd2da72-1bb8-419c-b68f-321fa9ee0f5b)

A very heavy fork and overhaul of FNF - Psych Engine. Aiming to actually, and LITERALLY have everything an engine should have/need. That uses other rhythm games's systems and settings to make FNF a completely different, and original ideal game! As of now, SkyDecay Engine is only used for The SkyDecay Project (https://gamebanana.com/wips/68022) by Josephjr05 (Creator of the engine).

## Psych Engine LUA API:

Refer to [the Lua API Documentation](https://shadowmario.github.io/psychengine.lua/) IF you're gonna mod on this engine!

## Psych Engine Installation:

Refer to [the Build Instructions](./BUILDING.md)

## Psych Engine Information:

if you wish to disable things like *Lua Scripts* or *Video Cutscenes*, you can read over to `Project.xml`

inside `Project.xml`, you will find several variables to customize Psych Engine to your liking

to start you off, disabling Videos should be simple, simply Delete the line `"VIDEOS_ALLOWED"` or comment it out by wrapping the line in XML-like comments, like this `<!-- YOUR_LINE_HERE -->`

same goes for *Lua Scripts*, comment out or delete the line with `LUA_ALLOWED`, this and other customization options are all available within the `Project.xml` file

_____________________________________

# Features (SkyDecay Engine)

## Ver:
* Psych Engine mixed with VSlice, Codename, and Restructure Engine features.
(To have Osu Mania, Etterna, Quaver, and NotITG features in FNF!)

## UNIVERSAL CHARTS SUPPORT!
* Convert universally using the chart editor as you can now convert from Osu, Qua, SM, or Guitar Hero charts to Psych engine!
* Thanks to Moonchart and how simple it is to actually use, this engine is the first to support universal chart files!
* This is included in The SkyDecay Project FNF mod FOR Mania difficulty.

* Do expect bugs with BPM changing!

* Reverse Scroll is finally here. Mania mappers can now enjoy charting on FNF. I love y'all :D
  
## Optimization:
* No matter how many notes there are in a chart (or on Botplay), it won't ever lagspike or drain some fps! But do make sure it's working well for your device.
* Notes are easier to read and faster computing.

## New languages:
* A load of new languages come out of the box with this engine by different people! (Contributors of SkyDecay Project)

## New OD and HP system:

* Hit Windows and Health Drain can simply be customized specifically within a chart's file data! 
* You can edit values to determine the hit windows specifically on that song's difficulty to ensure a very fair playthrough.
* Health Drain multipliers won't be a player option anymore.

## Results Screen:
![](https://github.com/user-attachments/assets/fce40633-e095-4f6b-a96a-d95bdb86e3fd)
* Along with the new Accuracy system, a Results Screen (toggable) can show your real and accurate stats!
* This means Psych Engine's awful input system is gone.
* It's better and heavily more accurate to your inputs and judgements.

## Sustain Release (WIP):
* You are now forced to let go of the sustains!
* Let go at the end of the sustain tail to gain extra combo and extra score.

## Screenshot function:
* A new Screenshot Function is available! Simply press F12 key and take a screenshot of your game.
* It's meant for ease of use.

## XML Editor (WIP):
* Simply, help adjust xml files with this editor.
* Shows the sprites and you can edit nodes + more!

## Modchart Editor (WIP):
* Make modcharts with a built in editor ofcourse! 
* It takes json files of the modchart and simply brings it to life.

## More lua, more freedom!:
* You love lua? Well you'll love the extensive freedom of Lua scripting with a whole lot of new variables and more!

## Death Screen on stage:
* When you get blueballed now, you die right where you stand! No more black screen.
* Don't embarrass yourself infront of your girlfriend now.

## PlayState Changes (WIP)
* The playfield strums are now in it's own cam, go crazy in Lua!
* CamHUD doesn't bop anymore. Events now trigger only CamHUD camera events if yes to value 3 on some camera events. (To make it very cool)
* The playfield strums have also been repositioned (and on downscroll) to help read notes easier.
* A Playfield editor can help reposition the area to your liking!
* Multi Key up to 18 keys is supported!

## EVENTS!
* A whole lot of built in events are here! Including the most wanted one: Change Stages!
* Instead of using Lua for most of your events, you have them in the palm of your hands. Mess around with them with more than 10 event text fields for each function that event does dependent on it.
* Ofcourse if you don't see an event you want, make it yourself in Lua OR request it!

* This engine will also include other mod events from Voiid Chronicles shader events with ease of power, VS QT dodge mechanics, Sonic.exe notetypes, poison, health drain/gain notetypes. Camera manipulation events, Split Screen control, play on opponent side and back with events, Flip hud or strums, and a whole lot more!

## Other Stuff:
* Disabled unnecessary options (Like score txt zoom and combo stacking)
* Disabled Base Game code (for optimization)
* A brand new game you've never experienced before EVER.

# Extras:
* Improved camera movement
* Improved asset loading (with possibly no Loading Screen softlock)
* Improved options with more customization (Including Note Quantization colors)
* Improved note spawning and lag-free
* Improved Psych 1.0 chart editor (With references from MMPE, and VSlice)
* Improved systems (Accuracy, judgements, consistency of fps)
* Improved general aspects of fnf that mixes with other rhythm games.
* Will always update Psych Engine.

## Other Credits:
* P-Slice: For giving us some references to use/put into this engine (no code was taken besides imports that are left behind)
* OS Engine: For underlay transparency code under notes playfield.
* Sick Coders + Slushi Engine: For NotITG(Modchart editor), Gamejolt, and Voiid Chronicles additions code/features.
* Moon's Modded Psych Engine: For characters showing in the chart editor.
* Fps Plus: For lil buddies in the chart editor. (We made them work with sustain notes!)
* Js Engine (sadly): For extra options in chart editor like clearing player or opponent sides (but for Psych 1.0).
* Psych Engine: For the amazing Pull Requests that ShadowMario ignores or doesn't want to add that is missing on Psych Engine itself!
