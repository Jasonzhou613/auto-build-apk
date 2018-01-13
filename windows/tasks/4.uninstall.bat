rem uninstall app if need

echo.
echo ---------------------------------------------

@echo off

echo ^>^>^>start uninstall %packageName%

adb uninstall %packageName%
