rem 开始编译

echo.
echo ---------------------------------------------

@echo off

echo enter project dir %projectPath%
cd /d %projectPath%

echo start build...%gradleFlavor%
call gradlew %gradleFlavor%

cd /d %taskPath%
echo build completed... 