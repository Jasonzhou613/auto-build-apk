rem install app

echo.
echo ---------------------------------------------

@echo off

if "%installType%"=="push" (
	echo ^>^>^>get root permission
	adb root
	adb remount
)

for /r %outputPath% %%i in (*.apk) do (
	echo ^>^>^>start %installType% apk: %%i
	if "%installType%"=="push" (
		adb push %%i system/app/
	) else (
		adb install -r %%i
	)
)

echo ^>^>^>%installType% complete