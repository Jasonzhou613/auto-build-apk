@echo off

set errorMsg=errorMsg:unknow

rem if file not exist
if not exist %configFile% (
	set errorMsg=%configFile% file not exist.
    goto errorEnd
)

set needClean=0
set needReboot=0
set packageName=
set launcherActivity=
set projectName=
set projectPath=
set gradleFlavor=
set taskPath=
set signToolPath=
set outputPath=
set installType=
set needReboot=
set logTag=

For /F "tokens=1* delims==" %%A IN (%configFile%) DO (
	IF "%%A"=="needClean"        set needClean=%%B
	IF "%%A"=="needReboot"       set needReboot=%%B
	IF "%%A"=="packageName"      set packageName=%%B
	IF "%%A"=="launcherActivity" set launcherActivity=%%B
	IF "%%A"=="projectName"      set projectName=%%B
	IF "%%A"=="projectPath"      set projectPath=%%B
	IF "%%A"=="gradleFlavor"     set gradleFlavor=%%B
	IF "%%A"=="taskPath"         set taskPath=%%B
	IF "%%A"=="signToolPath"     set signToolPath=%%B
	IF "%%A"=="outputPath"       set outputPath=%%B
	IF "%%A"=="installType"      set installType=%%B
	IF "%%A"=="logTag"           set logTag=%%B
)

if "%needClean%"=="" (
	set needClean=1
)
if "%packageName%"=="" (
	set errorMsg=packageName is null, you should set packageName at first in %configFile%
    goto errorEnd
)
if "%projectName%"=="" (
	set errorMsg=projectName is null, you should set projectName at first in %configFile%
    goto errorEnd
)
if "%projectPath%"=="" (
	set errorMsg=projectPath is null, you should set projectPath at first in %configFile%
    goto errorEnd
)
if "%gradleFlavor%"=="" (
	set gradleFlavor=assembleRelease
)
if "%taskPath%"=="" (
	set errorMsg=taskPath is null, you should set taskPath at first in %configFile%
    goto errorEnd
)
if "%signToolPath%"=="" (
	set errorMsg=signToolPath is null, you should set signToolPath at first in %configFile%
    goto errorEnd
)
if "%outputPath%"=="" (
    set outputPath=%projectPath%\%projectName%\build\outputs\apk\signed-apks
)
if "%installType%"=="" (
	set installType=install
)

echo ---------------------------------------------
echo needClean          : %needClean%
echo needReboot         : %needReboot%
echo packageName        : %packageName%
echo launcherActivity   : %launcherActivity%
echo projectName        : %projectName%
echo projectPath        : %projectPath%
echo gradleFlavor       : %gradleFlavor%
echo taskPath           : %taskPath%
echo signToolPath       : %signToolPath%
echo outputPath         : %outputPath%
echo installType        : %installType%
echo logTag             : %logTag%

if not "%logTag%"=="" (
	echo.
	echo ---------------------------------------------
    echo ^>^>^>Execute: adb shell setprop %logTag% DEBUG
    adb shell setprop %logTag% DEBUG
)  

if "%needClean%"=="1" (
	call tasks\1.clean.bat
) else if exist %projectPath%\%projectName%\build (
	rem echo ^>^>^>delete %projectPath%\%projectName%\build folder
	rem rd /s /Q %projectPath%\%projectName%\build
)

if exist %projectPath%\%projectName%\build\outputs (
	echo ^>^>^>delete %projectPath%\%projectName%\build\outputs folder
	rd /s /Q %projectPath%\%projectName%\build\outputs
)

call tasks\2.build.bat
call tasks\3.sign.bat
if not "%installType%"=="push" (
	rem call tasks\4.uninstall.bat
)
call tasks\5.installORpush.bat
if not "%needReboot%"=="1" (
	if not "%launcherActivity%"=="" (
		call tasks\6.startApp.bat
	)
)

goto end

:errorEnd
echo Config error...
echo %errorMsg%
pause > nul

:end
if "%needReboot%"=="1" (
	echo.
	echo ^>^>^>reboot...
	echo ^>^>^>end!
	echo ^>^>^>end!
	adb reboot
) else (
	echo.
	echo ^>^>^>end!
	echo ^>^>^>end!
)
