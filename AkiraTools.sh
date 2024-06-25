#!/bin/bash

MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[1;33m'
BIRU='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NORMAL='\033[0m'

URL_LISENSI="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"

animasi_loading() {
    local durasi=$1
    local karakter=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local pesan=$2
    local waktu_mulai=$(date +%s)

    while [ $(($(date +%s) - waktu_mulai)) -lt $durasi ]; do
        for i in "${karakter[@]}"; do
            echo -ne "\r${CYAN}$i ${pesan}${NORMAL}"
            sleep 0.1
        done
    done
    echo -ne "\r${HIJAU}✓ ${pesan} Selesai!${NORMAL}\n"
}

tampilkan_banner() {
    echo -e "${MAGENTA}"
    echo "  ______     __      _                ______                __   "
    echo " /_  __/__  / /__   (_)___  _________/_  __/___  ____  ____/ /__ "
    echo "  / / / _ \/ / _ \ / / __ \/ ___/ __ \/ / / __ \/ __ \/ __  / _ \\"
    echo " / / /  __/ /  __// / /_/ / /  / /_/ / / / /_/ / /_/ / /_/ /  __/"
    echo "/_/  \___/_/\___//_/\__, /_/   \____/_/  \____/\____/\__,_/\___/ "
    echo "                   /____/                                        "
    echo -e "${NORMAL}"
    echo -e "${KUNING}Selamat datang di Installer Alat Otomasi Telegram${NORMAL}"
    echo -e "${KUNING}Dibuat oleh Akira${NORMAL}"
    echo
}

periksa_lisensi() {
    local username="$1"
    local lisensi
    lisensi=$(wget -qO- "$URL_LISENSI")
    
    if echo "$lisensi" | grep -qi "^$username,"; then
        return 0
    else
        return 1
    fi
}

install_dependencies() {
    animasi_loading 3 "Menginstall dependensi"
    
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip screen wget unzip
    pip3 install telethon requests beautifulsoup4
}

subproses_instalasi() {
    animasi_loading 3 "Menyiapkan lingkungan"
    animasi_loading 5 "Mengunduh komponen"
    
    wget -q https://github.com/Vendesu/AkiraTools/raw/main/akira.zip
    unzip -q akira.zip
    rm akira.zip
    
    animasi_loading 3 "Mengkonfigurasi sistem"
    
    chmod +x akiratools.py
    
    animasi_loading 2 "Membersihkan"
}

jalankan_dalam_screen() {
    screen -S akiratools -d -m ./akiratools.py
    echo -e "${HIJAU}Sesi screen 'akiratools' telah dimulai.${NORMAL}"
    echo -e "${BIRU}Untuk melihat sesi, ketik: ${KUNING}screen -r akiratools${NORMAL}"
    echo -e "${BIRU}Untuk keluar dari sesi tanpa menghentikannya, tekan: ${KUNING}Ctrl+A kemudian D${NORMAL}"
}

utama() {
    animasi_loading 3 "Memulai instalasi"

    tampilkan_banner

    while true; do
        read -p "Silakan masukkan username Anda: " username

        if periksa_lisensi "$username"; then
            echo -e "${HIJAU}Lisensi valid. Melanjutkan instalasi...${NORMAL}"
            break
        else
            echo -e "${MERAH}Lisensi tidak valid. Silakan coba lagi atau hubungi administrator.${NORMAL}"
        fi
    done
    
    echo "$username" > ~/.lisensi_otomasi_telegram
    
    install_dependencies
    
    subproses_instalasi &
    PID=$!

    while kill -0 $PID 2>/dev/null; do
        for i in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
            echo -ne "\r${CYAN}$i Instalasi sedang berlangsung...${NORMAL}"
            sleep 0.1
        done
    done

    wait $PID
    
    echo -e "\n${HIJAU}Instalasi selesai!${NORMAL}"
    echo -e "${BIRU}Menjalankan akiratools dalam screen...${NORMAL}"
    
    jalankan_dalam_screen
}

utama