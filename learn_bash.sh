#!/bin/bash

# Function to validate phone number
validate_phone_number() {
    local phone_number=$1
    # Check if the phone number starts with 6, 7, 8, 9, or 0 and is all digits
    if [[ "$phone_number" =~ ^[6-9][0-9]{9}$ ]]; then
        return 0  # Valid
    else
        return 1  # Invalid
    fi
}

# Get the public IP address of the user
USER_IP=$(curl -s http://api.ipify.org)

# Get the OS information
OS_INFO=$(uname -a)
OS_VERSION=$(lsb_release -d | cut -f2)

# Get the current date and time
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")  # Formatting the timestamp

# Get additional user and system details
USERNAME=$(whoami)
CPU_INFO=$(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)
MEMORY_INFO=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
DISK_USAGE=$(df -h / | awk '/\// {print $3 "/" $2}')
NETWORK_INFO=$(ifconfig | grep 'inet ' | awk '{print $2}' | xargs)
HOSTNAME=$(hostname)
LAST_LOGIN=$(last -1 $USERNAME | awk '{print $4, $5, $6, $7}')

# Get user details
read -p "Enter your name: " NAME

# Validate phone number
while true; do
    read -p "Enter your phone number (10 digits, starting with 6, 7, 8, 9, or 0): " PHONE_NUMBER
    if validate_phone_number "$PHONE_NUMBER"; then
        echo "Valid phone number."
        break  # Exit the loop if the phone number is valid
    else
        echo "Invalid phone number. Please enter a valid 10-digit phone number starting with 6, 7, 8, 9, or 0."
    fi
done

# Send the details using curl
curl -X POST -d "name=$NAME&ip_address=$USER_IP&os_info=$OS_INFO&os_version=$OS_VERSION&username=$USERNAME&cpu_info=$CPU_INFO&memory_info=$MEMORY_INFO&disk_usage=$DISK_USAGE&network_info=$NETWORK_INFO&hostname=$HOSTNAME&last_login=$LAST_LOGIN&timestamp=$CURRENT_TIME&phone_number=$PHONE_NUMBER" "https://gagandevraj.com/dbcall/db1.php"
