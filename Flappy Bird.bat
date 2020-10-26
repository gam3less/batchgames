:: Unable to find original Creator
:: Editted by Gam3less:
:: Added colour
:: Fixed sizing
:: Added title page
:: Goes back to title page when you lose\
:: Added instructions
@echo off
setlocal EnableDelayedExpansion

:start
Echo&color 0e&mode con cols=60 lines=19
cls
:::  ______ _                           ____  _         _ 
::: |  ____| |                         |  _ \(_)       | |
::: | |__  | | __ _ _ __  _ __  _   _  | |_) |_ _ __ __| |
::: |  __| | |/ _` | '_ \| '_ \| | | | |  _ <| | '__/ _` |
::: | |    | | (_| | |_) | |_) | |_| | | |_) | | | | (_| |
::: |_|    |_|\__,_| .__/| .__/ \__, | |____/|_|_|  \__,_|
:::                | |   | |     __/ |                    
:::                |_|   |_|    |___/                     

for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo.
echo.
echo.

Echo By Unknown, Edit by Gameless
Echo.
Echo.
Echo 1)Play Game
Echo 2)Instructions
Echo.
Echo.
set /p choice=
If %choice% EQU 1 goto setup
If %choice% EQU 2 goto Instruct

:Instruct
cls
Echo&setlocal&color 03&mode con cols=55 lines=10
Echo.
Echo The goal of this game is to get through each pipe.
Echo Use the '1' key to go up.
Echo your fall speed increases the longer you fall.
Echo You have to go for as long as you can
Echo Enjoy, By the way, I do not claim to own Flappy Bird,
Echo this is just my representation of it.
Echo.
Echo.
pause
goto start

::creating a new line variable for multi line strings
:setup
set NLM=^


:: Two empty lines are required here
::set up initial grid
Echo&setlocal&color 03&mode con cols=20 lines=13

for /l %%a in (0,1,9) do (
	for /l %%d in (0,1,14) do (
		set arr[%%a][%%d]=.
	)
)

::create some vars at an initial value
set falling=0
set row=5
set turns=0

:turn
set arr[%row%][8]=^>

::display current grid
set "grid="
for /l %%a in (0,1,9) do (
	set line=!arr[%%a][0]!
	for /l %%d in (1,1,14) do (
		set line=!line!!arr[%%a][%%d]!
	)
	set grid=!grid! !NLM! !line!
)
cls
echo !grid!

::slide the screen
set next=0
set arr[%row%][8]=.
for /l %%a in (0,1,9) do (
	for /l %%d in (0,1,14) do (
		set /a next=%%d-1
		set arr[%%a][!next!]=!arr[%%a][%%d]!
	)
)

::create a new row for the right side of the screen, adds obstacle every 7 columns
set /a addCol=%turns% %% 7
if %addCol%==0 (
	::top of column
	set /a topL=%random%*7/32768
	for /l %%a in (0,1,!topL!) do set arr[%%a][14]=#
		
	::hole
	set /a topL+=1
	set /a whiteEnd=!topL!+1
	for /l %%a in (!topL!,1,!whiteEnd!) do set arr[%%a][14]=.
	
	::bottom
	set /a topL+=2
	for /l %%a in (!topL!,1,9) do set arr[%%a][14]=#
) else (
	::fill with dots
	for /l %%a in (0,1,9) do set arr[%%a][14]=.
)

::prompt and make move
choice /c:01 /n /m "" /t:1 /d:0
set /a move=%errorlevel%-1

::falling!
set /a row-=%move%
if %move%==0 (
	set /a falling+=1
) else (
	set falling=0
)
set /a row+=%falling%

::loss conditions
if !arr[%row%][8]!==# call :gameOver %turns% 
if %row% LSS 0 call :gameOver %turns% 
if %row% GTR 9 call :gameOver %turns% 

::increment turns, return to top
set /a turns+=1
goto :turn

::sequence for game over. displays game over and score
:gameOver
cls
Echo&color 0e&mode con cols=38 lines=8
Echo GAME OVER
set /a score=%1/7
Echo Score: %score%
Echo.
Echo Press a key to go back to the title.
pause > NUL
goto start