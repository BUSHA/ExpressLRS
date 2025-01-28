@echo off
setlocal enabledelayedexpansion

set START_TIME=%TIME%

:: Set path to PlatformIO executable
set PIO_PATH=%USERPROFILE%\.platformio\penv\Scripts\platformio.exe

:: Check if PlatformIO exists
if not exist "%PIO_PATH%" (
    echo Error: PlatformIO not found at %PIO_PATH%
    echo Please make sure PlatformIO is installed correctly
    pause
    exit /b 1
)

:: List of environments to build
set ENVIRONMENTS=^
    Unified_ESP8285_900_RX_via_UART^
    Unified_ESP32_900_RX_via_UART^
    Unified_ESP8285_LR1121_900_RX_via_UART^
    Unified_ESP32_LR1121_RX_via_UART^
    Unified_ESP8285_2400_RX_via_UART^
    Unified_ESP32_LR1121_TX_via_UART^
    Unified_ESP32_900_TX_via_UART^
    Unified_ESP32_2400_TX_via_UART

:: Path to release directory
set RELEASE_DIR=C:\mafia_built

:: Create release directory if it doesn't exist
if not exist "%RELEASE_DIR%" (
    mkdir "%RELEASE_DIR%"
)

:: Build each environment
for %%e in (%ENVIRONMENTS%) do (
    echo.
    echo ====================================
    echo Building environment: %%e
    echo ====================================
    echo.

    :: Build this environment and automatically send Enter for bare firmware
    echo Building %%e...
    echo.| "%PIO_PATH%" run -e %%e
    if !errorlevel! neq 0 (
        echo Failed to build %%e
        pause
        exit /b 1
    )
    
    :: Define source and destination paths
    set SOURCE_PATH=.pio\build\%%e\firmware.bin
    set DEST_NAME=%%e
    set DEST_NAME=!DEST_NAME:_via_UART=!
    set DEST_PATH=%RELEASE_DIR%\!DEST_NAME!.bin

    :: Copy and rename the built firmware
    if exist "!SOURCE_PATH!" (
        copy "!SOURCE_PATH!" "!DEST_PATH!"
        echo Copied firmware to !DEST_PATH!
    ) else (
        echo Error: Built firmware not found at !SOURCE_PATH!
        pause
        exit /b 1
    )
    
    echo Build successful for %%e
    timeout /t 2 /nobreak > nul
)

set END_TIME=%TIME%

for /f "tokens=1-4 delims=:.," %%a in ("%START_TIME%") do (
    set /a "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
for /f "tokens=1-4 delims=:.," %%a in ("%END_TIME%") do (
    set /a "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
set /a elapsed=end-start

set /a hh=elapsed/(60*60*100)
set /a rest=elapsed%%(60*60*100)
set /a mm=rest/(60*100)
set /a rest%%=60*100
set /a ss=rest/100
set /a cc=rest%%100

echo.
echo All builds completed!
echo Total time elapsed: %mm% minutes %ss% seconds
pause