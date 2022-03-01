@echo OFF

set ROOT_DIR=%cd%
set SOURCE_DIR=%ROOT_DIR%\src
set BUILD_DIR=%ROOT_DIR%\build

if exist "%BUILD_DIR%" (
	>nul 2>nul dir /a-d "%BUILD_DIR%\*" && (
		
		echo.
		echo *** Recompiling ***
		cd %SOURCE_DIR%
		for /f %%i in ('dir') do set LOG=%%i
		echo %LOG%
	
	)
) else (

	mkdir "%BUILD_DIR%"
	
)

pause