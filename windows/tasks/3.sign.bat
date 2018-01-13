rem install app

echo.
echo ---------------------------------------------

@echo off
setlocal enabledelayedexpansion

set originApkPath=%projectPath%\%projectName%\build\outputs\apk

echo ^>^>^>start sign apks, dir: %originApkPath%

rem create the outputPath dir
if not exist %outputPath% mkdir %outputPath%

rem for /r %originApkPath% %%i in (*.apk) do (
for /f "delims=" %%i in ('dir /a-d /b %originApkPath%\*.apk') do (
	set temp=%%i
	
	For %%A in (!temp!) do (
		set apkName=%%~nxA
	)

	set apkName=!apkName:-unsigned=!
	set apkName=!apkName:-signed=!
	set apkName=!apkName:.apk=-signed.apk!
	set newPath=%outputPath%\!apkName!
	
	echo ^>^>^> sign apk, %%i --^> !newPath!
	java -jar %signToolPath%\signapk.jar %signToolPath%\platform.x509.pem %signToolPath%\platform.pk8 %originApkPath%\%%i !newPath!
)

echo ^>^>^>sign apks completed...