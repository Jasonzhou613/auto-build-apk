rem 开始签名

echo.
echo ---------------------------------------------

@echo off
setlocal enabledelayedexpansion

set appSourceDir=%projectPath%\%projectName%\build\outputs\apk
set appDesDir=%signedApkDir%
set mapSourcesDir=%projectPath%\%projectName%\build\outputs\mapping
set mapDesDir=%mappingDir%

rem 如果编译有生成mapping文件则复制到指定地方
if exist %mapSourcesDir% (
	echo copy mapping: %mapSourcesDir% --^>^> %mapDesDir%
	xcopy %mapSourcesDir%\*.* %mapDesDir% /s /e /y
)

cd  /d %appSourceDir%
for /f "delims=" %%i in ('dir /b/s *.apk') do (
	rem 签名后将文件重命名为signed
	set newName=%%~ni
	set newName=!newName:-unsigned=!
	set newName=!newName!-signed.apk
	set newName=%appDesDir%\!newName!
	
	echo signed app %%i to !newName!
	rem 开始签名
	jarsigner -verbose -keystore %keystorePath% -signedjar !newName! %%i %keystoreAlias% -storepass %keystorePwd%
)
cd /d %taskPath%

endlocal