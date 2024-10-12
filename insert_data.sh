#!/bin/bash

# Get the public IP address of the user
USER_IP=$(curl -s http://api.ipify.org)

# Get the OS information
OS_INFO=$(uname -a)

# Get the current date and time
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")  # Formatting the timestamp

# Get user details
read -p "Enter your name: " NAME
read -p "Enter your phone number: " PHONE_NUMBER

# Send the details using curl
curl -X POST -d "name=$NAME&ip_address=$USER_IP&os_info=$OS_INFO&timestamp=$CURRENT_TIME&"phone_number=$PHONE_NUMBER "https://gagandevraj.com/dbcall/db1.php"
