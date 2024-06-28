#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub raw URL for licenses
LICENSE_URL="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"

# License file location
LICENSE_FILE="$HOME/.lisensi_otomasi_telegram"

# AkiraTools URL
AKIRA_URL="https://github.com/Vendesu/AkiraTools/raw/main/akira"

# Function to display a centered message
center_message() {
    message="$1"
    padding="$(printf '%0.1s' ={1..80})"
    printf '%*.*s %s %*.*s\n' 0 "$(((80-${#message})/2))" "$padding" "$message" 0 "$(((80-${#message})/2))" "$padding"
}

# Function to display a loading animation
loading_animation() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Clear the screen
clear

# Display welcome message
center_message "TELEGRAM AUTOMATION TOOL INSTALLER"
echo -e "${YELLOW}Created by Akira${NC}\n"

# Prompt for user's name
read -p "Enter your name: " user_name

# Fetch licenses from GitHub
echo -e "\n${BLUE}Fetching licenses...${NC}"
licenses=$(curl -s "$LICENSE_URL") &
loading_animation $!

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to fetch licenses. Please check your internet connection.${NC}"
    exit 1
fi

# Check if the user's name is in the licenses
license_info=$(echo "$licenses" | grep -i "^$user_name,")

if [ -n "$license_info" ]; then
    # Extract license details
    IFS=',' read -r name duration start_date end_date <<< "$license_info"
    
    # Calculate remaining days
    current_date=$(date +%s)
    end_date_seconds=$(date -d "$end_date" +%s)
    remaining_days=$(( (end_date_seconds - current_date) / 86400 ))

    if [ $remaining_days -le 0 ]; then
        echo -e "\n${RED}Your license has expired. Please contact the administrator for renewal.${NC}"
        exit 1
    fi
    
    # Save the license to the file
    echo "$license_info" > "$LICENSE_FILE"
    
    echo -e "\n${GREEN}License installed successfully!${NC}"
    echo -e "License details:"
    echo -e "${YELLOW}Name: $name"
    echo -e "Duration: $duration days"
    echo -e "Start Date: $start_date"
    echo -e "End Date: $end_date"
    echo -e "Remaining Days: $remaining_days${NC}"

    # Download AkiraTools
    echo -e "\n${BLUE}Downloading AkiraTools...${NC}"
    wget -q "$AKIRA_URL" &
    loading_animation $!
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to download AkiraTools. Please check your internet connection.${NC}"
        exit 1
    fi

    # Unzip the downloaded file
    echo -e "\n${BLUE}Extracting AkiraTools...${NC}"
    unzip -o akira > /dev/null 2>&1 &
    loading_animation $!

    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to extract AkiraTools.${NC}"
        exit 1
    fi

    # Give execute permissions to all extracted files
    echo -e "\n${BLUE}Setting permissions...${NC}"
    chmod +x * > /dev/null 2>&1 &
    loading_animation $!

    # Install required Python packages
    echo -e "\n${BLUE}Installing required Python packages...${NC}"
    pip install -r requirements.txt > /dev/null 2>&1 &
    loading_animation $!

    # Run akiratools.py
    echo -e "\n${GREEN}Installation complete. Starting AkiraTools...${NC}"
    sleep 2
    python akiratools.py

else
    echo -e "\n${RED}No valid license found for $user_name.${NC}"
    echo -e "Please contact the administrator to get a valid license."
    exit 1
fi