rem start app

echo.
echo ---------------------------------------------

@echo off

echo ^>^>^>start app %packageName%/%launcherActivity%

adb shell am start -n %packageName%/%launcherActivity%