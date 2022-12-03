--Recreation by RamenDominoes
--Credit appreciated, but not necessary thanks <3

--Crew Names Here!!!
--IF YOU ARE NOT USING CERTAIN NAME SLOTS, JUST LEAVE THEM BLANK 
	--Example: CodeName1 = ''

	CoderName1 = 'Razalzy'
	CoderName2 = ''
	CoderName3 = ''

	ArtistName1 = 'Vs. Camellia Team'
	ArtistName2 = ''
	ArtistName3 = ''

	MusicianName1 = 'Tictacto'
	MusicianName2 = ''
	MusicianName3 = ''

	CharterName1 = 'Insane-NeoNuke'
	CharterName2 = 'Mania-JuliuzG'
	CharterName3 = '' 



--Script Options--

Start = 1 --choose which "STEP" to activate the script on

CreditsExitTimer = 5 --How many seconds the script will show before exiting

TweenSpeed = 0.8 --How fast the credits move in/out

Transparency = 0.6 --I wouldn't mess with this, but it changes the transparency of the credits underlay

Font = 'vcr.ttf' --Change the Font here if needed

HorizontalUnderLayOffset = 0  --Moves Underlay if needed (horizontally)
--POSITIVE MOVES LEFT
--NEGATIVE MOVES RIGHT

HorizontalWordsOffset = 0 --Moves the words if needed (horizontally)
--NEGATIVE MOVES LEFT
--POSITIVE MOVES RIGHT

---------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------You probably don't need to edit beyond here-------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------



--ALL OF THE SHIT !! (theres so much shit)
function onCreate()

	--------THE MF UHHHH UNDERLAY--------

	--MAIN SECTION
	makeLuaSprite('Main', 'CREDITTEXT', ((screenWidth/2)-(570/2)) +- HorizontalUnderLayOffset, -1300)
	makeGraphic('Main', 570, 1300, '808080')
	setObjectCamera('Main', 'other')
	setProperty('Main.alpha', Transparency - 0.2)
	addLuaSprite('Main', true)
	
	--BorderLeft
	makeLuaSprite('BorderLeft', 'OUTLINE', (((screenWidth/2)-(4/2)) - 285) +- HorizontalUnderLayOffset, -1300)
	makeGraphic('BorderLeft', 4, 1300, 'FFFFFF')
	setObjectCamera('BorderLeft', 'other')
	setProperty('BorderLeft.alpha', Transparency)
	addLuaSprite('BorderLeft', true)

	--BorderRight
	makeLuaSprite('BorderRight', 'OUTLINE', (((screenWidth/2)-(4/2)) + 285) +- HorizontalUnderLayOffset, -1300)
	makeGraphic('BorderRight', 4, 1300, 'FFFFFF')
	setObjectCamera('BorderRight', 'other')
	setProperty('BorderRight.alpha', Transparency)
	addLuaSprite('BorderRight', true)

	-----------------------------------------------------------------------

	--------THE MF UHHHH SUBHEADERS!!--------

	--CREDITS TEXT
	makeLuaText('CREDITS', 'CREDITS', 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CREDITS', 'center')
	setTextSize('CREDITS', 50)
	setObjectCamera('CREDITS', 'other')
	addLuaText('CREDITS')
	setTextFont('CREDITS', Font)
	
	--CODER TEXT
	makeLuaText('CODERS', 'CODE', 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CODERS', 'center')
	setTextSize('CODERS', 35)
	setObjectCamera('CODERS', 'other')
	addLuaText('CODERS')
	setTextFont('CODERS', Font)

	--ARTWORK TEXT
	makeLuaText('ARTISTS', 'ARTWORK', 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('ARTISTS', 'center')
	setTextSize('ARTISTS', 35)
	setObjectCamera('ARTISTS', 'other')
	addLuaText('ARTISTS')
	setTextFont('ARTISTS', Font)
	
	--MUSIC TEXT
	makeLuaText('MUSICIANS', 'MUSIC', 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('MUSICIANS', 'center')
	setTextSize('MUSICIANS', 35)
	setObjectCamera('MUSICIANS', 'other')
	addLuaText('MUSICIANS')
	setTextFont('MUSICIANS', Font)
	
	--CHARTING TEXT
	makeLuaText('CHARTERS', 'CHARTING', 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CHARTERS', 'center')
	setTextSize('CHARTERS', 35)
	setObjectCamera('CHARTERS', 'other')
	addLuaText('CHARTERS')
	setTextFont('CHARTERS', Font)

	-----------------------------------------------------------------------

	--------CODING CREW--------
	--CODER 1
	makeLuaText('CODER1', CoderName1, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CODER1', 'center')
	setTextSize('CODER1', 25)
	setObjectCamera('CODER1', 'other')
	addLuaText('CODER1')
	setTextFont('CODER1', Font)
	
	--CODER 2
	makeLuaText('CODER2', CoderName2, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CODER2', 'center')
	setTextSize('CODER2', 25)
	setObjectCamera('CODER2', 'other')
	addLuaText('CODER2')
	setTextFont('CODER2', Font)

	--CODER 3
	makeLuaText('CODER3', CoderName3, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CODER3', 'center')
	setTextSize('CODER3', 25)
	setObjectCamera('CODER3', 'other')
	addLuaText('CODER3')
	setTextFont('CODER3', Font)
	
	--------ARTIST CREW--------
		
	--ARTIST 1
	makeLuaText('ARTIST1', ArtistName1, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('ARTIST1', 'center')
	setTextSize('ARTIST1', 25)
	setObjectCamera('ARTIST1', 'other')
	addLuaText('ARTIST1')
	setTextFont('ARTIST1', Font)
	
	--ARTIST 2
	makeLuaText('ARTIST2', ArtistName2, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('ARTIST2', 'center')
	setTextSize('ARTIST2', 25)
	setObjectCamera('ARTIST2', 'other')
	addLuaText('ARTIST2')
	setTextFont('ARTIST2', Font)

	--ARTIST 3
	makeLuaText('ARTIST3', ArtistName3, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('ARTIST3', 'center')
	setTextSize('ARTIST3', 25)
	setObjectCamera('ARTIST3', 'other')
	addLuaText('ARTIST3')
	setTextFont('ARTIST3', Font)
	
	--------MUSIC CREW--------
	
	--MUSICIAN 1
	makeLuaText('MUSICIAN1', MusicianName1, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('MUSICIAN1', 'center')
	setTextSize('MUSICIAN1', 25)
	setObjectCamera('MUSICIAN1', 'other')
	addLuaText('MUSICIAN1') 
	setTextFont('MUSICIAN1', Font)
	
	--MUSICIAN 2
	makeLuaText('MUSICIAN2', MusicianName2, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('MUSICIAN2', 'center')
	setTextSize('MUSICIAN2', 25)
	setObjectCamera('MUSICIAN2', 'other')
	addLuaText('MUSICIAN2')
	setTextFont('MUSICIAN2', Font)

	--MUSICIAN 3
	makeLuaText('MUSICIAN3', MusicianName3, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('MUSICIAN3', 'center')
	setTextSize('MUSICIAN3', 25)
	setObjectCamera('MUSICIAN3', 'other')
	addLuaText('MUSICIAN3') 
	setTextFont('MUSICIAN3', Font)


	--------CHARTING CREW--------
	
	--CHARTER 1
	makeLuaText('CHARTER1', CharterName1, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CHARTER1', 'center')
	setTextSize('CHARTER1', 25)
	setObjectCamera('CHARTER1', 'other')
	addLuaText('CHARTER1')
	setTextFont('CHARTER1', Font)
	
	--CHARTER 2
	makeLuaText('CHARTER2', CharterName2, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CHARTER2', 'center')
	setTextSize('CHARTER2', 25)
	setObjectCamera('CHARTER2', 'other')
	addLuaText('CHARTER2')
	setTextFont('CHARTER2', Font)

	--CHARTER 3
	makeLuaText('CHARTER3', CharterName3, 1280, HorizontalWordsOffset, -1000)
	setTextAlignment('CHARTER3', 'center')
	setTextSize('CHARTER3', 25)
	setObjectCamera('CHARTER3', 'other')
	addLuaText('CHARTER3')
	setTextFont('CHARTER3', Font)


	--------TIME FOR THE MOVEMENT SHIT BABEY WOOOOOOOO!!!--------
	function onStepHit()

		--------UNDERLAY ENTRANCE--------
		
		if curStep == Start then
		
			doTweenY('UNDERLAY1', 'Main', 0, TweenSpeed, 'QuadOut')
			doTweenY('UNDERLAY2', 'BorderLeft', 0, TweenSpeed, 'QuadOut')
			doTweenY('UNDERLAY3', 'BorderRight', 0, TweenSpeed, 'QuadOut')

			
			--------TEXT ENTRANCE--------
			
			----CREDITS TEXT----
			doTweenY('CREDSTEXT', 'CREDITS', 60, TweenSpeed/1.6, 'QuadOut')

			----CODERS TEXT----
			doTweenY('CODETEXT', 'CODERS', 140, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CODER1', 'CODER1', 180, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CODER2', 'CODER2', 210, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CODER3', 'CODER3', 240, TweenSpeed/1.6, 'QuadOut')

			----ARTISTS TEXT----
			doTweenY('ARTTEXT', 'ARTISTS', 280, TweenSpeed/1.6, 'QuadOut')
			doTweenY('ARTIST1', 'ARTIST1', 320, TweenSpeed/1.6, 'QuadOut')
			doTweenY('ARTIST2', 'ARTIST2', 350, TweenSpeed/1.6, 'QuadOut')
			doTweenY('ARTIST3', 'ARTIST3', 380, TweenSpeed/1.6, 'QuadOut')

			----MUSICIANS TEXT----
			doTweenY('MUSICTEXT', 'MUSICIANS', 420, TweenSpeed/1.6, 'QuadOut')
			doTweenY('MUSICIAN1', 'MUSICIAN1', 460, TweenSpeed/1.6, 'QuadOut')
			doTweenY('MUSICIAN2', 'MUSICIAN2', 490, TweenSpeed/1.6, 'QuadOut')
			doTweenY('MUSICIAN3', 'MUSICIAN3', 520, TweenSpeed/1.6, 'QuadOut')

			
			----CHARTERS TEXT----
			doTweenY('CHARTEXT', 'CHARTERS', 560, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CHARTER1', 'CHARTER1', 600, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CHARTER2', 'CHARTER2', 630, TweenSpeed/1.6, 'QuadOut')
			doTweenY('CHARTER3', 'CHARTER3', 660, TweenSpeed/1.6, 'QuadOut')

			----MAKE THE TEXT LEAVE SHIT----
			runTimer('ALL THE FUCKING THINGS', CreditsExitTimer, 1)
		

			function onTimerCompleted(tag, loops, loopsLeft)

				if tag == 'ALL THE FUCKING THINGS' then

					--------UNDERLAY EXIT--------
					
					doTweenY('UNDERLAY1EXIT', 'Main', -1300, TweenSpeed/2.5, 'QuadIn')
					doTweenY('UNDERLAY2EXIT', 'BorderLeft', -1300, TweenSpeed/2.5, 'QuadIn')
					doTweenY('UNDERLAY3EXIT', 'BorderRight', -1300, TweenSpeed/2.5, 'QuadIn')

					
					--------TEXT EXIT--------
					
					----CREDITS TEXT----
					doTweenY('CREDSTEXTEXIT', 'CREDITS', -1000, TweenSpeed/1.6, 'QuadIn')

					----CODERS TEXT----
					doTweenY('CODETEXTEXIT', 'CODERS', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CODER1EXIT', 'CODER1', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CODER2EXIT', 'CODER2', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CODER3EXIT', 'CODER3', -1000, TweenSpeed/1.6, 'QuadIn')

					----ARTISTS TEXT----
					doTweenY('ARTTEXTEXIT', 'ARTISTS', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('ARTIST1EXIT', 'ARTIST1', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('ARTIST2EXIT', 'ARTIST2', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('ARTIST3EXIT', 'ARTIST3', -1000, TweenSpeed/1.6, 'QuadIn')

					----MUSICIANS TEXT----
					doTweenY('MUSICTEXTEXIT', 'MUSICIANS', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('MUSICIAN1EXIT', 'MUSICIAN1', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('MUSICIAN2EXIT', 'MUSICIAN2', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('MUSICIAN3EXIT', 'MUSICIAN3', -1000, TweenSpeed/1.6, 'QuadIn')

					
					----CHARTERS TEXT----
					doTweenY('CHARTEXTEXIT', 'CHARTERS', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CHARTER1EXIT', 'CHARTER1', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CHARTER2EXIT', 'CHARTER2', -1000, TweenSpeed/1.6, 'QuadIn')
					doTweenY('CHARTER3EXIT', 'CHARTER3', -1000, TweenSpeed/1.6, 'QuadIn')
				end
			end
		end
	end
end





