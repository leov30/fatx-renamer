@echo off
title FATX file renamer

REM //removes double quotes, and path, and extension
set "_folder=%~n1"

if "%_folder%"=="" (
	title ERROR
	echo DRAG AND DROP THE ROMs FOLDER TO THIS .BAT SCRIPT
	pause & exit
)


if not "%~x1"=="" (
	title ERROR
	echo INVALID FOLDER
	pause & exit

)

if not exist "%_folder%\" (
	title ERROR
	echo INVALID FOLDER
	pause & exit

)

REM ****** line counter ************
set /a "_total_lines=0"
set /a "_count_lines=0"
for /f "delims=" %%g in ('dir /b /a:-d "%_folder%\"') do set /a "_total_lines+=1"

if %_total_lines%==0 (
	title ERROR
	echo THIS FOLDER IS EMPTY
	pause & exit
)


echo -----------------------------------------------------
echo *                Choose and option                  *
echo -----------------------------------------------------
echo 1. Use short country tags *
echo 2. Save Parethesis tags *
echo 3. Remove Parenthesis tags
echo 4. Simple FATx renaming ^(Default^)
echo.
echo *** tags are no-intro parenthesis

Set /p _option0=Enter The Number: || set _option0=nul

if %_option0%==1 set "_option0=short" & goto next_menu
if %_option0%==2 set "_option0=save" & goto next_menu
if %_option0%==3 set "_option0=none" & goto next_menu
set "_option0=nul"

:next_menu
cls
echo -----------------------------------------------------
echo Choose an Option 'Enter' to use Defaults
echo -----------------------------------------------------
echo 1. Move
echo 2. Copy ^(Default^)
echo.

Set /p _option1=Enter The Number: || set _option1=2

if %_option1%==1 (set "_option1=move") else (set "_option1=copy")

cls
if not exist "%_folder%_REN" md "%_folder%_REN"
if exist "%_folder%_REN.txt" del "%_folder%_REN.txt"

REM //only files, no folders
for /f "delims=" %%g in ('dir /b /a:-d "%_folder%"') do (
	echo %%g
	set /a "_count_lines+=1"
	call :rename "%%~ng" %%~xg

) 

title FINISHED
pause & exit


:rename

REM ****** line counter ************	
set /a "_percent=(%_count_lines%*100)/%_total_lines%
title FATX RENAMER: %_count_lines% / %_total_lines% ^( %_percent% %% ^)

set "_name=%~1"


REM //do nothing option
if "%_option0%"=="nul" goto rename_loop0

REM //remove tags option
if "%_option0%"=="none" (
	for /f "tokens=1 delims=)(" %%h in ("%_name%") do set "_name=%%h"
	goto rename_loop0
)


REM //short country tag option
if not "%_option0%"=="short" goto rename_loop0

if not "%_name%"=="%_name:(USA)=%" set "_name=%_name:(USA)=(U)%" & goto rename_loop0
if not "%_name%"=="%_name:(Japan)=%" set "_name=%_name:(Japan)=(J)%" & goto rename_loop0
if not "%_name%"=="%_name:(Europe)=%" set "_name=%_name:(Europe)=(E)%" & goto rename_loop0
REM if not "%_name%"=="%_name:(World)=%" set "_name=%_name:(World)=(U)%" & goto rename_loop0

if not "%_name%"=="%_name:(USA, Europe)=%" set "_name=%_name:(USA, Europe)=(U)%" & goto rename_loop0
if not "%_name%"=="%_name:(Japan, USA)=%" set "_name=%_name:(Japan,USA)=(U)%" & goto rename_loop0
if not "%_name%"=="%_name:(Germany)=%" set "_name=%_name:(Germany)=(G)%" & goto rename_loop0
if not "%_name%"=="%_name:(France)=%" set "_name=%_name:(France)=(F)%" & goto rename_loop0
if not "%_name%"=="%_name:(Spain)=%" set "_name=%_name:(Spain)=(S)%" & goto rename_loop0
if not "%_name%"=="%_name:(Australia)=%" set "_name=%_name:(Australia)=(A)%" & goto rename_loop0
if not "%_name%"=="%_name:(Italy)=%" set "_name=%_name:(Italy)=(I)%" & goto rename_loop0
if not "%_name%"=="%_name:(China)=%" set "_name=%_name:(China)=(C)%" & goto rename_loop0
if not "%_name%"=="%_name:(Europe, Australia)=%" set "_name=%_name:(Europe, Australia)=(E)%" & goto rename_loop0


:rename_loop0

REM //remove inllegal Fatx characters
echo "%_name%"|findstr "="
if %errorlevel%==0 (
	for /f "tokens=1,* delims==" %%h in ("%_name%") do set "_name=%%h%%i"
	goto rename_loop0
)

REM //remove ', The' since comma will be removed
if not "%_name%"=="%_name:, The=%" set "_name=%_name:, The=%"

if not "%_name%"=="%_name:,=%" set "_name=%_name:,=%"
if not "%_name%"=="%_name:+=%" set "_name=%_name:+=%"
if not "%_name%"=="%_name:;=%" set "_name=%_name:;=%"

REM //remove trailing space
if "%_name:~-1,1%"==" " set "_name=%_name:~0,-1%"


REM //remove sapces
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name: =%") else (goto skip0)

REM //remove misc characters
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:-=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:_=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:.=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:'=%") else (goto skip0)


set _flag=0
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:[=%" & set _flag=1) else (goto skip0)
if "%_flag%"=="1" set "_name=%_name:]=%"

REM //good tools verified ROM
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:!=%") else (goto skip0)

REM //II -2, III-3
REM if not "%_name%"=="%_name:~0,38%" (set "_name=%_name: III = 3 %") else (goto skip0)
REM if not "%_name%"=="%_name:~0,38%" (set "_name=%_name: II = 2 %") else (goto skip0)



REM // ********* save nointro tag option *************
if "%_option0%"=="save" goto save_tag
if "%_option0%"=="short" goto save_tag

set _flag=0
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:(=%" & set _flag=1) else (goto skip0)
if "%_flag%"=="1" set "_name=%_name:)=%"

REM //force 38 characters
if not "%_name%"=="%_name:~0,38%" set "_name=%_name:~0,38%" & goto skip0


:save_tag

REM // only continue if name still is over 38
if "%_name%"=="%_name:~0,38%" goto skip0

set "_tag0=" & set "_tag1=" & set "_tag2=" & set "_tag3="

if not "%_name%"=="%_name:(Rev1)=%" set "_tag1=(Rev1)" & goto save_tag0
if not "%_name%"=="%_name:(Rev2)=%" set "_tag1=(Rev2)" & goto save_tag0
if not "%_name%"=="%_name:(Rev3)=%" set "_tag1=(Rev3)" & goto save_tag0
if not "%_name%"=="%_name:(Rev4)=%" set "_tag1=(Rev4)" & goto save_tag0
if not "%_name%"=="%_name:(Rev5)=%" set "_tag1=(Rev5)" & goto save_tag0

:save_tag0

if not "%_name%"=="%_name:VirtualConsole=%" set "_tag3=(VC)" & goto save_tag1
if not "%_name%"=="%_name:(Beta=%" set "_tag3=(Beta)" & goto save_tag1
if not "%_name%"=="%_name:(Proto=%" set "_tag3=(Proto)" & goto save_tag1
if not "%_name%"=="%_name:GameCube=%" set "_tag3=(GC)" & goto save_tag1
if not "%_name%"=="%_name:Wii=%" set "_tag3=(VC)" & goto save_tag1
if not "%_name%"=="%_name:(Unl)=%" set "_tag3=(Unl)" & goto save_tag1
if not "%_name%"=="%_name:Aftermarket=%" set "_tag3=(Unl)" & goto save_tag1
if not "%_name%"=="%_name:(Sample)=%" set "_tag3=(Sample)" & goto save_tag1
if not "%_name%"=="%_name:(Demo)=%" set "_tag3=(Demo)" & goto save_tag1
if not "%_name%"=="%_name:(Pirate)=%" set "_tag3=(Unl)" & goto save_tag1
if not "%_name%"=="%_name:Switch=%" set "_tag3=(VC)" & goto save_tag1

:save_tag1


REM // - subtilte
REM //no spaces at this point, ja, en??
for /f "tokens=1,2 delims=)(" %%h in ("%_name%") do (
	set "_name=%%h"
	if not "%%i"=="" set "_tag0=(%%i)"
	REM if not "%%j"=="" set "_tag1=(%%j)"
	REM if not "%%k"=="" set "_tag2=(%%k)"
	REM if not "%%l"=="" set "_tag3=(%%l)"

) 


REM // can just test for Rev 1,2,3

REM //only keep Revision #
REM if "%_tag1%"=="%_tag1:Rev=%" (
	REM if not "%_tag2%"=="%_tag2:Rev=%" (
		REM set "_tag1=%_tag2%"
	REM ) else (
		REM set "_tag1="
	REM )
REM )

REM //chop to 38 characters, enable delay expression. [!] already was removed
SETLOCAL EnableDelayedExpansion
for /l %%h in (38,-1,15) do (
	set "_name0=!_name!%_tag0%%_tag1%%_tag3%"
	
	if not "!_name0!"=="!_name0:~0,38!" (
		set "_name=!_name:~0,%%h!"
	) else (
		set "_name=!_name!%_tag0%%_tag1%%_tag3%"
		goto skip0
	)
	
)

REM //remove tags if reached the end limit...
for /l %%h in (38,-1,12) do (
	set "_name0=!_name!%_tag0%%_tag1%"
	
	if not "!_name0!"=="!_name0:~0,38!" (
		set "_name=!_name:~0,%%h!"
	) else (
		set "_name=!_name!%_tag0%%_tag1%"
		goto skip0
	)
	
)
for /l %%h in (38,-1,12) do (
	set "_name0=!_name!%_tag0%"
	
	if not "!_name0!"=="!_name0:~0,38!" (
		set "_name=!_name:~0,%%h!"
	) else (
		set "_name=!_name!%_tag0%"
		goto skip0
	)
	
)

REM //in case it reaches 0?
set "_name=%_name:~0,38%"

:skip0

REM // handles duplicated files. move renamed files to know which ones are dup.
set /a "_count=0"
set _limit=0

:rename_loop1
if %_count% GEQ 10 set _limit=1
if %_count% GEQ 100 set _limit=2

if exist "%_folder%_REN\%_name%%2" (
	if "%_limit%"=="0" set "_name=%_name:~0,36%_%_count%"
	if "%_limit%"=="1" set "_name=%_name:~0,35%_%_count%"
	if "%_limit%"=="2" set "_name=%_name:~0,34%_%_count%"
	
	set /a "_count+=1"
	goto rename_loop1
)

%_option1% "%_folder%\%~1%2" "%_folder%_REN\%_name%%2" >nul

(echo "%~1%2 ---> %_name%%2") >>"%_folder%_REN.txt"

exit /b

