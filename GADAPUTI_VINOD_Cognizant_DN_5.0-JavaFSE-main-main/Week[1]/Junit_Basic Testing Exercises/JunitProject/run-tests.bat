@echo off
REM Batch script to compile and run JUnit tests

setlocal enabledelayedexpansion

set "projectDir=%CD%"
set "libDir=%projectDir%\lib"
set "binDir=%projectDir%\bin"
set "srcMainDir=%projectDir%\src\main\java"
set "srcTestDir=%projectDir%\src\test\java"

REM Create directories
if not exist "%libDir%" mkdir "%libDir%"
if not exist "%binDir%" mkdir "%binDir%"

echo.
echo [*] Downloading JUnit dependencies...

REM Download JUnit 4.13.2
if not exist "%libDir%\junit-4.13.2.jar" (
    echo [*] Downloading junit-4.13.2.jar...
    powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar' -OutFile '%libDir%\junit-4.13.2.jar' } catch { Write-Error $_ }"
)

REM Download Hamcrest Core 1.3
if not exist "%libDir%\hamcrest-core-1.3.jar" (
    echo [*] Downloading hamcrest-core-1.3.jar...
    powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar' -OutFile '%libDir%\hamcrest-core-1.3.jar' } catch { Write-Error $_ }"
)

set "classpath=%libDir%\junit-4.13.2.jar;%libDir%\hamcrest-core-1.3.jar;%binDir%"

echo.
echo [*] Compiling main classes...
for /r "%srcMainDir%" %%F in (*.java) do (
    echo Compiling %%~nF...
    javac -d "%binDir%" -cp "%classpath%" "%%F"
    if errorlevel 1 (
        echo ERROR: Failed to compile %%~nF
        exit /b 1
    )
)

echo.
echo [*] Compiling test classes...
for /r "%srcTestDir%" %%F in (*.java) do (
    echo Compiling %%~nF...
    javac -d "%binDir%" -cp "%classpath%" "%%F"
    if errorlevel 1 (
        echo ERROR: Failed to compile %%~nF
        exit /b 1
    )
)

echo.
echo ================================
echo [*] Running JUnit tests...
echo ================================
echo.

java -cp "%classpath%" org.junit.runner.JUnitCore com.example.CalculatorTest

if errorlevel 1 (
    echo.
    echo ================================
    echo [!] Some tests failed!
    echo ================================
    exit /b 1
) else (
    echo.
    echo ================================
    echo [+] All tests passed!
    echo ================================
)

endlocal
