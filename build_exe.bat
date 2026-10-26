@echo off
setlocal
cd /d "%~dp0"

echo === MediCareHub EXE builder ===

where javac >nul 2>nul || (echo ERROR: JDK install nahi hai. JDK 17 ya 21 install karein. & pause & exit /b 1)
where jpackage >nul 2>nul || (echo ERROR: jpackage nahi mila. JDK 17 ya 21 install karein. & pause & exit /b 1)

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
mkdir build\classes
mkdir build\input

echo [1/4] Compiling...
javac -encoding UTF-8 -sourcepath src -d build\classes src\hospital\Main.java || goto :err

echo [2/4] Creating JAR...
jar cfe build\input\MediCareHub.jar hospital.Main -C build\classes . || goto :err

echo [3/4] Creating EXE (app-image)...
jpackage --type app-image --name MediCareHub --input build\input --main-jar MediCareHub.jar --main-class hospital.Main --dest dist || goto :err

echo [4/4] Copying data folder next to EXE...
xcopy /e /i /y data dist\MediCareHub\data >nul

echo.
echo DONE! EXE yahan hai: dist\MediCareHub\MediCareHub.exe
pause
exit /b 0

:err
echo.
echo ERROR: Build fail ho gaya. Upar wala error message dekhein.
pause
exit /b 1
