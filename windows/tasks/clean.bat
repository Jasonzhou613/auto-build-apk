rem 编译之前先clean整个项目

echo.
echo ---------------------------------------------

@echo off

echo enter project dir %projectPath%

cd /d %projectPath%
echo start clean...

call gradlew clean

echo clean completed...
cd /d %taskPath%