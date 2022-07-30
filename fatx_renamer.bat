@echo off
title FATX file renamer

REM //removes double quotes, and path
set "_folder=%~n1"

if "%_folder%"=="" (
	echo DRAG AND DROP THE ROMs FOLDER TO THIS .BAT SCRIPT
	pause & exit
)

type "%~1" >nul 2>&1
if %errorlevel%==0 (
	echo ONLY FOLDERS NO FILES
	pause & exit
)

echo -----------------------------------------------------
echo Use short country codes? 'Enter' to use Default
echo -----------------------------------------------------
echo 1. Yes
echo 2. No ^(Default^)
echo.

Set /p _option0=Enter The Number: || set _option0=2

if %_option0%==1 (set "_option0=yes") else (set "_option0=no")


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


REM for /f tokens^=2^ delims^=^" %%g in ("%CMDCMDLINE%") do set "_path=%%g"
REM set "_path=%_path:\fatx_renamer.bat=%"

REM if exist "%_path%\7z.exe" echo 7z was found


REM ****** line counter ************
set /a "_total_lines=0"
set /a "_count_lines=0"
for /f "delims=" %%g in ('dir /b /a:-d "%_folder%"') do set /a "_total_lines+=1"

if %_total_lines%==0 (
	echo THIS FOLDER IS EMPTY
	pause & exit

)

if not exist "%_folder%_REN" md "%_folder%_REN"
if exist "%_folder%_REN.txt" del "%_folder%_REN.txt"


REM //only files, no folders
for /f "delims=" %%g in ('dir /b /a:-d "%_folder%"') do (
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

if "%_option0%"=="no" goto rename_loop0

if not "%_name%"=="%_name:(USA)=%" set "_name=%_name:(USA)=(U)%" & goto rename_loop0
if not "%_name%"=="%_name:(Japan)=%" set "_name=%_name:(Japan)=(J)%" & goto rename_loop0
if not "%_name%"=="%_name:(Europe)=%" set "_name=%_name:(Europe)=(E)%" & goto rename_loop0
if not "%_name%"=="%_name:(Japan,USA)=%" set "_name=%_name:(Japan,USA)=(JU)%" & goto rename_loop0
if not "%_name%"=="%_name:(Germany)=%" set "_name=%_name:(Germany)=(G)%" & goto rename_loop0
if not "%_name%"=="%_name:(France)=%" set "_name=%_name:(France)=(F)%" & goto rename_loop0
if not "%_name%"=="%_name:(Spain)=%" set "_name=%_name:(Spain)=(S)%" & goto rename_loop0
if not "%_name%"=="%_name:(Australia)=%" set "_name=%_name:(Australia)=(A)%" & goto rename_loop0
if not "%_name%"=="%_name:(Italy)=%" set "_name=%_name:(Italy)=(I)%" & goto rename_loop0
if not "%_name%"=="%_name:(China)=%" set "_name=%_name:(China)=(C)%" & goto rename_loop0

:rename_loop0
echo "%_name%"|findstr "="
if %errorlevel%==0 (
	for /f "tokens=1,* delims==" %%h in ("%_name%") do set "_name=%%h%%i"
	goto rename_loop0
)

if not "%_name%"=="%_name:,=%" set "_name=%_name:,=%"
if not "%_name%"=="%_name:+=%" set "_name=%_name:+=%"
if not "%_name%"=="%_name:;=%" set "_name=%_name:;=%"

REM //remove spaces first? other characters
REM //test file name without extension, with 3 character extension
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name: =%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:-=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:_=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:.=%") else (goto skip0)
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:'=%") else (goto skip0)

set _flag=0
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:(=%" & set _flag=1) else (goto skip0)
if "%_flag%"=="1" set "_name=%_name:)=%"

set _flag=0
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:[=%" & set _flag=1) else (goto skip0)
if "%_flag%"=="1" set "_name=%_name:]=%"

REM //good tools verified ROM
if not "%_name%"=="%_name:~0,38%" (set "_name=%_name:!=%") else (goto skip0)

if not "%_name%"=="%_name:~0,38%" set "_name=%_name:~0,38%"


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
echo "%~1%2 ---> %_name%%2"

exit /b
