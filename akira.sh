#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Nama folder tersembunyi
HIDDEN_FOLDER=".akira_tools"

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

# Fungsi untuk membuat folder tersembunyi dan mengunduh serta mengekstrak file
download_and_extract() {
    echo -e "${YELLOW}Membuat folder tersembunyi...${NC}"
    mkdir -p "$HIDDEN_FOLDER"
    cd "$HIDDEN_FOLDER"

    echo -e "${YELLOW}Mengunduh file...${NC}"
    wget https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -O akiraa.zip

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Unduhan berhasil.${NC}"
        echo -e "${YELLOW}Mengekstrak file...${NC}"
        unzip -o akiraa.zip
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Ekstraksi berhasil.${NC}"
            echo -e "${YELLOW}Memberikan akses penuh ke semua file...${NC}"
            chmod -R 777 *
            echo -e "${GREEN}Akses diberikan.${NC}"

            # Memberikan izin eksekusi ke file-file Python
            chmod +x *.py

            echo -e "${GREEN}Izin eksekusi diberikan ke semua file Python.${NC}"
            rm akiraa.zip
        else
            echo -e "${RED}Gagal mengekstrak file.${NC}"
            cd ..
            exit 1
        fi
    else
        echo -e "${RED}Gagal mengunduh file.${NC}"
        cd ..
        exit 1
    fi
    cd ..
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
    echo -e "${YELLOW}Menjalankan Telegram Automation Tool...${NC}"

    # Menjalankan akiratools.py dari folder tersembunyi
    python "$HIDDEN_FOLDER/akiratools.py"
}

# Jalankan fungsi utama
main