#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# License URL and File
LICENSE_URL="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"
LICENSE_FILE="$HOME/.lisensi_otomasi_telegram"

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

# Function to install Python modules
install_python_modules() {
    echo -e "${GREEN}Installing required Python modules...${NC}"
    pip3 install --upgrade pip
    pip3 install requests telethon colorama asyncio
}

# Function to verify license
verify_license() {
    local license_key="$1"
    if curl -s "$LICENSE_URL" | grep -q "$license_key"; then
        return 0
    else
        return 1
    fi
}

# Function to get saved license
get_saved_license() {
    if [ -f "$LICENSE_FILE" ]; then
        cat "$LICENSE_FILE"
    else
        echo ""
    fi
}

# Main installation process
main() {
    print_header

    # Install requirements
    install_requirements

    # Install Python modules
    install_python_modules

    # Check for existing license
    saved_license=$(get_saved_license)
    if [ -n "$saved_license" ]; then
        echo -e "${YELLOW}Existing license found. Verifying...${NC}"
        if verify_license "$saved_license"; then
            echo -e "${GREEN}Existing license is valid. Proceeding with installation...${NC}"
            license_key="$saved_license"
        else
            echo -e "${RED}Existing license is invalid. Please enter a new license.${NC}"
            saved_license=""
        fi
    fi

    # Prompt for license key if not already verified
    if [ -z "$saved_license" ]; then
        echo -e "${YELLOW}Please enter your license key:${NC}"
        read license_key

        # Verify license
        if verify_license "$license_key"; then
            echo -e "${GREEN}License valid. Proceeding with installation...${NC}"
            echo "$license_key" > "$LICENSE_FILE"
        else
            echo -e "${RED}Invalid license. Exiting installation.${NC}"
            exit 1
        fi
    fi

    # Download AkiraTools
    echo -e "${GREEN}Downloading AkiraTools...${NC}"
    curl -L https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -o akiraa.zip

    # Unzip AkiraTools
    echo -e "${GREEN}Extracting AkiraTools...${NC}"
    unzip -q akiraa.zip -d akiratools

    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${YELLOW}You can now run AkiraTools by executing: python3 akiratools/akiratools.py${NC}"
}

# Run the main function
main