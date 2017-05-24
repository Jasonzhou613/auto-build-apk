@echo off

set year=%DATE:~0,4%
set month=%DATE:~5,2%
set month=%month: =0%
set day=%DATE:~8,2%
set day=%day: =0%
set hh=%TIME:~0,2%
set hh=%hh: =0%
set mm=%TIME:~3,2%
set mm=%mm: =0%
set ss=%TIME:~6,2%
set ss=%ss: =0%
rem 得到年月日 yyyyMMdd
set yyyyMMdd=%year%%month%%day%
rem 得到小时与分 HHmm
set HHmm=%hh%%mm%

set configErrorLogsPath=..\configErrorLogs
set errorLogFile=%configErrorLogsPath%\log-%yyyyMMdd%_%HHmm%.log
set errorMsg=errorMsg:unknow

rem 配置文件路径
set configFile=config.properties

rem 如果有需要，则创建存放错误日志文件夹
if not exist %configErrorLogsPath% mkdir %configErrorLogsPath%

rem 判读配置文件是否存在，不存在则直接退出
if not exist %configFile% (
	set errorMsg=%configFile% file not exist.
    goto errorEnd
)

set debug=0
set projectName=
set projectPath=
set taskPath=
set outputPath=
set signedApkDir=
set mappingDir=
set logDir=
set signedApkExpiryTime=
set gradleFlavor=
set keystorePath=
set keystoreAlias=
set keystorePwd=

For /F "tokens=1* delims==" %%A IN (%configFile%) DO (
	IF "%%A"=="debug" set debug=%%B
	IF "%%A"=="projectName" set projectName=%%B
    IF "%%A"=="projectPath" set projectPath=%%B
    IF "%%A"=="taskPath" set taskPath=%%B
    IF "%%A"=="outputPath" set outputPath=%%B
    IF "%%A"=="signedApkDir" set signedApkDir=%%B
    IF "%%A"=="mappingDir" set mappingDir=%%B
    IF "%%A"=="logDir" set logDir=%%B
    IF "%%A"=="signedApkExpiryTime" set signedApkExpiryTime=%%B
    IF "%%A"=="gradleFlavor" set gradleFlavor=%%B
    IF "%%A"=="keystorePath" set keystorePath=%%B
    IF "%%A"=="keystoreAlias" set keystoreAlias=%%B
    IF "%%A"=="keystorePwd" set keystorePwd=%%B
)

if "%debug%"=="" (
	set debug=0
)
if "%projectName%"=="" (
	set errorMsg=projectName is null, you should set projectName at first in %configFile%
    goto errorEnd
)
if "%projectPath%"=="" (
	set errorMsg=projectPath is null, you should set projectPath at first in %configFile%
    goto errorEnd
)
if "%taskPath%"=="" (
	set errorMsg=taskPath is null, you should set taskPath at first in %configFile%
    goto errorEnd
)

if "%outputPath%"=="" (
	set outputPath=%projectPath%\..\output
)
if not exist %outputPath% mkdir %outputPath%

if "%signedApkDir%"=="" (
	set signedApkDir=%outputPath%\%projectName%\%yyyyMMdd%\apks
) else (
   set signedApkDir=%outputPath%\%projectName%\%yyyyMMdd%\%signedApkDir%
)
if not exist %signedApkDir% mkdir %signedApkDir%

if "%mappingDir%"=="" (
	set mappingDir=%outputPath%\%projectName%\%yyyyMMdd%\mapping
) else (
   set mappingDir=%outputPath%\%projectName%\%yyyyMMdd%\%mappingDir%
)
if not exist %mappingDir% mkdir %mappingDir%

if "%logDir%"=="" (
	set logDir=%outputPath%\%projectName%\%yyyyMMdd%\log
) else (
   set logDir=%outputPath%\%projectName%\%yyyyMMdd%\%logDir%
)
if not exist %logDir% mkdir %logDir%

if "%signedApkExpiryTime%"=="" (
	set signedApkExpiryTime=10
)

if "%gradleFlavor%"=="" (
	set gradleFlavor=assembleRelease
)

if "%keystorePath%"=="" (
	set errorMsg=keystorePath is null, you should set keystorePath at first in %configFile%
    goto errorEnd
)
if "%keystoreAlias%"=="" (
	set errorMsg=keystoreAlias is null, you should set keystoreAlias at first in %configFile%
    goto errorEnd
)
if "%keystorePwd%"=="" (
	set errorMsg=keystorePwd is null, you should set keystorePwd at first in %configFile%
    goto errorEnd
)

set logFile=%logDir%/build-%yyyyMMdd%_%HHmm%.log
echo --------------------------------------------- > %logFile%

if %debug%==1 (
    echo ---------------------------------------------
	echo debug: %debug%
    echo projectName        : %projectName%
    echo projectPath        : %projectPath%
	echo taskPath           : %taskPath%
	echo outputPath         : %outputPath%
	echo signedApkDir       : %signedApkDir%
	echo mappingDir         : %mappingDir%
	echo logDir             : %logDir%
	echo signedApkExpiryTime: %signedApkExpiryTime%
	echo gradleFlavor       : %gradleFlavor%
	echo keystorePath       : %keystorePath%
	echo keystoreAlias      : %keystoreAlias%
	echo keystorePwd        : %keystorePwd%
) else (
	echo debug: %debug% >> %logFile%
    echo projectName        : %projectName% >> %logFile%
    echo projectPath        : %projectPath% >> %logFile%
	echo taskPath           : %taskPath% >> %logFile%
	echo outputPath         : %outputPath% >> %logFile%
	echo signedApkDir       : %signedApkDir% >> %logFile%
	echo mappingDir         : %mappingDir% >> %logFile%
	echo logDir             : %logDir% >> %logFile%
	echo signedApkExpiryTime: %signedApkExpiryTime% >> %logFile%
	echo gradleFlavor       : %gradleFlavor% >> %logFile%
    echo keystorePath       : %keystorePath% >> %logFile%
	echo keystoreAlias      : %keystoreAlias% >> %logFile%
	echo keystorePwd        : %keystorePwd% >> %logFile%
)

if %debug%==1 (
	call tasks\checkExpiry.bat
	call tasks\clean.bat
    call tasks\build.bat
	call tasks\signeApks.bat
) else (
	call tasks\checkExpiry.bat >> %logFile%
	call tasks\clean.bat >> %logFile%
    call tasks\build.bat >> %logFile%
	call tasks\signeApks.bat >> %logFile%
)

goto end

:errorEnd
echo Config error...
echo %errorMsg%
echo %errorMsg% > %errorLogFile%
pause > nul

:end