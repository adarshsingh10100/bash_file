@echo off
setlocal enabledelayedexpansion

REM Get the public IP address of the user
for /f "delims=" %%i in ('curl -s http://api.ipify.org') do set USER_IP=%%i

REM Get the OS information
set OS_INFO=%OS%

REM Get the current date and time
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime ^| find "."') do (
    set CURRENT_TIME=%%i
    set CURRENT_TIME=!CURRENT_TIME:~0,4!-!CURRENT_TIME:~4,2!-!CURRENT_TIME:~6,2! !CURRENT_TIME:~8,2!:!CURRENT_TIME:~10,2!:!CURRENT_TIME:~12,2!
)

REM Get user details
set /p NAME="Enter your name: "
set /p PHONE_NUMBER="Enter your phone number: "

REM Send the details using curl
curl -X POST -d "name=%NAME%&ip_address=%USER_IP%&os_info=%OS_INFO%&timestamp=%CURRENT_TIME%&phone_number=%PHONE_NUMBER%" "https://gagandevraj.com/dbcall/db1.php"

REM Check the exit status of curl command
if %errorlevel% equ 0 (
    echo Data sent successfully! 😊
) else (
    echo Something went wrong! 😢
)

endlocal
