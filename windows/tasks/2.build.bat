rem start building

echo.
echo ---------------------------------------------

@echo off

echo ^>^>^>enter project dir %projectPath%
cd /d %projectPath%

echo ^>^>^>start build...%gradleFlavor%
call gradlew %gradleFlavor% --offline

cd /d %taskPath%
echo ^>^>^>build completed... 