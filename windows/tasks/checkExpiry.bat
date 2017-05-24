rem 检测过期了的apks，如果已经过期，则删除

echo.
echo ---------------------------------------------

@echo off
setlocal enabledelayedexpansion

echo begin check expiry app...
echo outputPath:%outputPath%

for /f "tokens=* delims=" %%i in ('dir /ad/b "%outputPath%\%projectName%"') do (
	rem 这里我们使用的年月日来命名文件，所以可以直接用来进行比较
	set /a result=%yyyyMMdd%-%%i
	if !result! GTR %signedApkExpiryTime% (
		echo %projectName%\%%i is already !result! days, will delete...
		rd /s /Q %outputPath%\%projectName%\%%i
	) else (
		if "%debug%"=="1" (
			echo %projectName%\%%i just only !result! days, will not delete
		)
	)
)

echo check expiry completed...
endlocal