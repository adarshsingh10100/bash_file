@echo off
setlocal enabledelayedexpansion

:: Function to validate phone number
:validate_phone_number
set "phone_number=%~1"
set "valid=0"

:: Check if the phone number starts with 6, 7, 8, 9, or 0 and is 10 digits
if "!phone_number:~0,1!"=="6" set "valid=1"
if "!phone_number:~0,1!"=="7" set "valid=1"
if "!phone_number:~0,1!"=="8" set "valid=1"
if "!phone_number:~0,1!"=="9" set "valid=1"
if "!phone_number:~0,1!"=="0" set "valid=1"

:: Check if the phone number has 10 digits
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

:: Get the public IP address of the user
for /f "delims=" %%i in ('curl -s http://api.ipify.org') do set "USER_IP=%%i"
if not defined USER_IP (
    echo Error: Failed to retrieve public IP address. Please check your internet connection.
    pause
    exit /b
)

:: Get current date and time
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "CURRENT_TIME=%%a"
set "CURRENT_TIME=!CURRENT_TIME:~0,4!-!CURRENT_TIME:~4,2!-!CURRENT_TIME:~6,2! !CURRENT_TIME:~8,2!:!CURRENT_TIME:~10,2!:!CURRENT_TIME:~12,2!"

:: Get user details
set /p NAME="Enter your name: "

:: Validate phone number
:phone_input
set /p PHONE_NUMBER="Enter your phone number (10 digits, starting with 6, 7, 8, 9, or 0): "
call :validate_phone_number "%PHONE_NUMBER%"
if errorlevel 1 (
    echo Invalid phone number. Please enter a valid 10-digit phone number starting with 6, 7, 8, 9, or 0.
    goto phone_input
)

echo Valid phone number.

:: Prepare data for POST request
set "POST_DATA=name=%NAME%&ip_address=%USER_IP%&timestamp=%CURRENT_TIME%&phone_number=%PHONE_NUMBER%"

:: Send the details using curl
curl -X POST -d "!POST_DATA!" "https://gagandevraj.com/dbcall/db1.php"
if errorlevel 1 (
    echo Error: Failed to send data. Please check your network connection or the URL.
) else (
    echo Data has been sent successfully.
)

:: Add a final pause to keep the window open
echo Press any key to exit...
pause

endlocal
