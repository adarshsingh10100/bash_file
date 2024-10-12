@echo off
setlocal enabledelayedexpansion

REM Change color of the command prompt to green
color a

REM Get the public IP address of the user
for /f "delims=" %%i in ('curl -s http://api.ipify.org') do set "USER_IP=%%i"

REM Get the OS information
set "OS_INFO=%OS%"

REM Get the current date and time
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime ^| find "."') do (
    set "CURRENT_TIME=%%i"
    set "CURRENT_TIME=!CURRENT_TIME:~0,4!-!CURRENT_TIME:~4,2!-!CURRENT_TIME:~6,2! !CURRENT_TIME:~8,2!:!CURRENT_TIME:~10,2!:!CURRENT_TIME:~12,2!"
)

REM Get user details
set /p NAME="Enter your name: "
set /p PHONE_NUMBER="Enter your phone number: "

REM Validate phone number format (10 digits starting with 6, 7, 8, 9, or 0)
call :validate_phone_number "%PHONE_NUMBER%"
if errorlevel 1 (
    echo Invalid phone number! Please enter a valid 10-digit phone number.
    pause
    exit /b
)

REM Send the details using curl
curl -X POST -d "name=%NAME%&ip_address=%USER_IP%&os_info=%OS_INFO%&timestamp=%CURRENT_TIME%&phone_number=%PHONE_NUMBER%" "https://gagandevraj.com/dbcall/db1.php"

REM Check the exit status of curl command
if %errorlevel% equ 0 (
    echo Data sent successfully! 😊
) else (
    echo Something went wrong! 😢
)

echo Press any key to exit...
pause
endlocal

REM Function to validate phone number
:validate_phone_number
set "phone_number=%~1"
set "valid=0"

REM Check if the phone number starts with 6, 7, 8, 9, or 0 and has 10 digits
if "!phone_number:~0,1!"=="6" set "valid=1"
if "!phone_number:~0,1!"=="7" set "valid=1"
if "!phone_number:~0,1!"=="8" set "valid=1"
if "!phone_number:~0,1!"=="9" set "valid=1"
if "!phone_number:~0,1!"=="0" set "valid=1"

REM Check if the phone number has 10 digits
set "len=0"
for /l %%i in (0,1,9) do (
    if "!phone_number:~%%i,1!"=="" goto check_end
    set /a len+=1
)

:check_end
if "!len!"=="10" (
    exit /b 0  :: Valid
) else (
    exit /b 1  :: Invalid
)
