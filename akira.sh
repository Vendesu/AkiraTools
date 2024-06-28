#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Nama folder tersembunyi (tidak ditampilkan ke pengguna)
HIDDEN_FOLDER=".akira_tools"

# Fungsi untuk animasi loading
show_loading() {
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

# Fungsi untuk membersihkan layar
clear_screen() {
    clear
}

# Fungsi untuk menampilkan header
print_header() {
    echo -e "${BLUE}"
    echo "========================================"
    echo "    Telegram Automation Tool Installer"
    echo "           Created by Akira"
    echo "========================================"
    echo -e "${NC}"
}

# Fungsi untuk menyiapkan lingkungan
setup_environment() {
    echo -e "${YELLOW}Menyiapkan lingkungan...${NC}"
    (
        mkdir -p "$HIDDEN_FOLDER" && cd "$HIDDEN_FOLDER" &&
        wget -q https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -O temp.zip &&
        unzip -q temp.zip && chmod -R 777 * && rm temp.zip
    ) &
    show_loading $!
    echo -e "${GREEN}Lingkungan berhasil disiapkan.${NC}"
}

# Fungsi untuk menyiapkan lisensi
setup_license() {
    echo -e "${YELLOW}Menyiapkan lisensi...${NC}"
    read -p "Masukkan nama Anda: " name
    echo "$name" > "$HIDDEN_FOLDER/.lisensi_otomasi_telegram"
    echo -e "${GREEN}Lisensi berhasil disiapkan.${NC}"
}

# Fungsi untuk menginstal dependensi
install_dependencies() {
    echo -e "${YELLOW}Memeriksa dan menginstal dependensi...${NC}"
    
    # Memeriksa dan menginstal Python 3
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}Menginstal Python 3...${NC}"
        sudo apt-get update && sudo apt-get install -y python3 python3-pip
    fi

    # Menginstal atau memperbarui Telethon dan dependensi lainnya
    echo -e "${YELLOW}Menginstal modul Python yang diperlukan...${NC}"
    (python3 -m pip install --upgrade pip telethon colorama requests) &
    show_loading $!
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Semua dependensi berhasil diinstal.${NC}"
    else
        echo -e "${RED}Gagal menginstal beberapa dependensi. Silakan coba install manual.${NC}"
        exit 1
    fi
}

# Fungsi untuk membuat alias "akira"
create_alias() {
    echo -e "${YELLOW}Menyiapkan perintah 'akira'...${NC}"
    echo "alias akira='python3 $HOME/$HIDDEN_FOLDER/akiratools.py'" >> ~/.bashrc
    echo -e "${GREEN}Perintah 'akira' berhasil disiapkan.${NC}"
}

# Fungsi utama
main() {
    clear_screen
    print_header

    # Periksa ketersediaan tools
    if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null; then
        echo -e "${RED}Error: wget atau unzip tidak tersedia. Menginstal...${NC}"
        sudo apt-get update && sudo apt-get install -y wget unzip
    fi

    setup_environment
    setup_license
    install_dependencies
    create_alias

    echo -e "${GREEN}Instalasi selesai!${NC}"
    echo -e "${YELLOW}Memuat konfigurasi baru...${NC}"
    
    # Memuat .bashrc secara otomatis
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    fi
    
    echo -e "${GREEN}Konfigurasi baru berhasil dimuat.${NC}"
    echo -e "${YELLOW}Anda dapat menjalankan Telegram Automation Tool dengan perintah 'akira'.${NC}"
    echo -e "${BLUE}Modul yang digunakan: Python 3, Telethon, Colorama, Requests${NC}"
}

# Jalankan fungsi utama
main