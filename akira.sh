#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# GitHub raw URL for licenses
LICENSE_URL="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"

# License file location
LICENSE_FILE="$HOME/.lisensi_otomasi_telegram"

# Function to display a centered message
center_message() {
    message="$1"
    padding="$(printf '%0.1s' ={1..80})"
    printf '%*.*s %s %*.*s\n' 0 "$(((80-${#message})/2))" "$padding" "$message" 0 "$(((80-${#message})/2))" "$padding"
}

# Clear the screen
clear

# Display welcome message
center_message "TELEGRAM AUTOMATION TOOL LICENSE INSTALLER"
echo -e "${YELLOW}Created by Akira${NC}\n"

# Prompt for user's name
read -p "Enter your name: " user_name

# Fetch licenses from GitHub
echo -e "\n${YELLOW}Fetching licenses...${NC}"
licenses=$(curl -s "$LICENSE_URL")

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to fetch licenses. Please check your internet connection.${NC}"
    exit 1
fi

# Check if the user's name is in the licenses
if echo "$licenses" | grep -qi "$user_name"; then
    # Extract the license information
    license_info=$(echo "$licenses" | grep -i "$user_name")
    
    # Save the license to the file
    echo "$license_info" > "$LICENSE_FILE"
    
    echo -e "\n${GREEN}License installed successfully!${NC}"
    echo -e "License details:"
    echo -e "${YELLOW}$license_info${NC}"
else
    echo -e "\n${RED}No valid license found for $user_name.${NC}"
    echo -e "Please contact the administrator to get a valid license."
    exit 1
fi

echo -e "\n${GREEN}Installation complete. You can now run the Telegram Automation Tool.${NC}"