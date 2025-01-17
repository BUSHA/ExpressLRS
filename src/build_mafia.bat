@echo off
setlocal enabledelayedexpansion

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
    Unified_ESP8285_2400_RX_via_UART

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
    
    echo Build successful for %%e
    timeout /t 2 /nobreak > nul
)

echo.
echo All builds completed!
pause