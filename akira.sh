#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fungsi untuk membersihkan layar
clear_screen() {
    clear
}

# Fungsi untuk menampilkan header
print_header() {
    echo "=========================================="
    echo "    Telegram Automation Tool Installer"
    echo "           Created by Akira"
    echo "=========================================="
}

# Fungsi untuk mengunduh dan mengekstrak file
download_and_extract() {
    echo -e "${YELLOW}Mengunduh file...${NC}"
    wget https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -O akiraa.zip
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Unduhan berhasil.${NC}"
        echo -e "${YELLOW}Mengekstrak file...${NC}"
        unzip -o akiraa.zip
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Ekstraksi berhasil.${NC}"
            rm akiraa.zip
        else
            echo -e "${RED}Gagal mengekstrak file.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Gagal mengunduh file.${NC}"
        exit 1
    fi
}

# Fungsi untuk menyiapkan lisensi
setup_license() {
    echo -e "${YELLOW}Menyiapkan lisensi...${NC}"
    read -p "Masukkan nama Anda: " name
    echo "$name" > ~/.lisensi_otomasi_telegram
    echo -e "${GREEN}Lisensi berhasil disiapkan.${NC}"
}

# Fungsi untuk menginstal dependensi
install_dependencies() {
    echo -e "${YELLOW}Menginstal dependensi...${NC}"
    pip install telethon colorama requests
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Dependensi berhasil diinstal.${NC}"
    else
        echo -e "${RED}Gagal menginstal dependensi.${NC}"
        exit 1
    fi
}

# Fungsi utama
main() {
    clear_screen
    print_header
    
    # Periksa apakah wget, unzip, dan pip tersedia
    if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null || ! command -v pip &> /dev/null; then
        echo -e "${RED}Error: wget, unzip, atau pip tidak tersedia. Silakan instal terlebih dahulu.${NC}"
        exit 1
    fi
    
    download_and_extract
    setup_license
    install_dependencies
    
    echo -e "${GREEN}Instalasi selesai!${NC}"
    echo -e "${YELLOW}Anda sekarang dapat menjalankan script main.py untuk memulai Telegram Automation Tool.${NC}"
}

# Jalankan fungsi utama
main