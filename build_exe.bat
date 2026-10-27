
@echo off
setlocal
cd /d "%~dp0"

echo === MediCareHub EXE Builder ===

where javac >nul 2>nul || (echo ERROR: JDK is not installed. Please install JDK 17 or 21. & pause & exit /b 1)
where jpackage >nul 2>nul || (echo ERROR: jpackage was not found. Please install JDK 17 or 21. & pause & exit /b 1)

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
mkdir build\classes
mkdir build\input

echo [1/4] Compiling Java source files...
javac -encoding UTF-8 -sourcepath src -d build\classes src\hospital\Main.java || goto :err

echo [2/4] Creating JAR file...
jar cfe build\input\MediCareHub.jar hospital.Main -C build\classes . || goto :err

echo [3/4] Creating Windows application package...
jpackage --type app-image --name MediCareHub --input build\input --main-jar MediCareHub.jar --main-class hospital.Main --dest dist || goto :err

echo [4/4] Copying the data folder...
xcopy /e /i /y data dist\MediCareHub\data >nul

echo.
echo SUCCESS: Build completed successfully.
echo Application location: dist\MediCareHub\MediCareHub.exe
pause
exit /b 0

:err
echo.
echo ERROR: Build failed. Please review the error message above.
pause
exit /b 1
