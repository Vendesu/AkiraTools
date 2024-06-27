#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display a styled header
print_header() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗"
    echo -e "║              AKIRATOOLS AUTO INSTALLER                ║"
    echo -e "╚══════════════════════════════════════════════════════════╝${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install required packages
install_requirements() {
    echo -e "${GREEN}Installing required packages...${NC}"
    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip unzip curl
    elif command_exists yum; then
        sudo yum update
        sudo yum install -y python3 python3-pip unzip curl
    else
        echo -e "${RED}Unsupported package manager. Please install Python 3, pip, unzip, and curl manually.${NC}"
        exit 1
    fi
}

# Main installation process
main() {
    print_header

    # Install requirements
    install_requirements

    # Download license file
    echo -e "${GREEN}Downloading license file...${NC}"
    curl -s https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt -o licenses.txt

    # Prompt for license key
    echo -e "${YELLOW}Please enter your license key:${NC}"
    read license_key

    # Verify license
    if grep -q "$license_key" licenses.txt; then
        echo -e "${GREEN}License valid. Proceeding with installation...${NC}"
    else
        echo -e "${RED}Invalid license. Exiting installation.${NC}"
        exit 1
    fi

    # Download AkiraTools
    echo -e "${GREEN}Downloading AkiraTools...${NC}"
    curl -L https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -o akiraa.zip

    # Unzip AkiraTools
    echo -e "${GREEN}Extracting AkiraTools...${NC}"
    unzip -q akiraa.zip -d akiratools

    # Install Python requirements
    echo -e "${GREEN}Installing Python requirements...${NC}"
    pip3 install -r akiratools/requirements.txt

    # Save license key
    echo "$license_key" > ~/.lisensi_otomasi_telegram

    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${YELLOW}You can now run AkiraTools by executing: python3 akiratools/akiratools.py${NC}"
}

# Run the main function
main