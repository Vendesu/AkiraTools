#!/bin/bash

# Warna
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[1;33m'
BIRU='\033[0;34m'
UNGU='\033[0;35m'
CYAN='\033[0;36m'
PUTIH='\033[1;37m'
RESET='\033[0m'

# URL Lisensi dan GitHub
URL_LISENSI="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"
URL_AKIRATOOLS="https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip"

# Folder Akira Tools
AKIRA_DIR="$HOME/.akira_tools"

# Animasi keren
animasi_keren() {
    clear
    echo -e "${CYAN}"
    for i in {1..20}; do
        printf "\r%${i}s" | tr " " "="
        sleep 0.05
    done
    echo -e "${RESET}"
}

# Fungsi untuk mencetak banner keren dengan animasi
cetak_banner_animasi() {
    clear
    local banner=(
    "${CYAN}╔════════════════════════════════════════════════════════════╗"
    "║                                                            ║"
    "║                 AKIRA TOOLS INSTALLER                      ║"
    "║                Buat Hidupmu Lebih Mudah!                   ║"
    "╚════════════════════════════════════════════════════════════╝${RESET}"
    )
    for line in "${banner[@]}"; do
        echo -n "$line"
        sleep 0.1
        echo -e "\r"
    done
}

# Fungsi untuk animasi loading
animasi_loading() {
    local duration=$1
    local chars="◐◓◑◒"
    local start=$(date +%s)
    local end=$((start + duration))
    
    while [ $(date +%s) -lt $end ]; do
        for (( i=0; i<${#chars}; i++ )); do
            echo -en "${CYAN}${chars:$i:1}" $'\r'
            sleep 0.2
        done
    done
    echo -en "${RESET}"
}

# Fungsi untuk animasi teks ketik
animasi_ketik() {
    local teks="$1"
    local warna="$2"
    for (( i=0; i<${#teks}; i++ )); do
        echo -en "${warna}${teks:$i:1}"
        sleep 0.02
    done
    echo -e "${RESET}"
}

# Fungsi untuk memeriksa lisensi
periksa_lisensi() {
    local nama="$1"
    if curl -s "$URL_LISENSI" | grep -q "$nama"; then
        local durasi=$(curl -s "$URL_LISENSI" | grep "$nama" | cut -d',' -f2)
        if [ "$durasi" == "lifetime" ]; then
            echo "lifetime"
        else
            echo "$durasi"
        fi
    else
        echo "tidak valid"
    fi
}

# Fungsi untuk menampilkan progress bar
tampilkan_progress() {
    local durasi=$1
    local pesan=$2
    local lebar=40
    local karakter_progress="▓"
    local karakter_kosong="░"
    
    for ((i=0; i<=lebar; i++)); do
        local persentase=$((i * 100 / lebar))
        local progress=$(printf "%${i}s" | tr ' ' "$karakter_progress")
        local sisa=$(printf "%$((lebar - i))s" | tr ' ' "$karakter_kosong")
        printf "\r${CYAN}%s [%s%s] %d%%" "$pesan" "$progress" "$sisa" "$persentase"
        sleep $(echo "scale=2; $durasi / $lebar" | bc)
    done
    echo -e "${RESET}"
}

# Fungsi instalasi utama
instal_otomasi_telegram() {
    animasi_keren
    cetak_banner_animasi
    animasi_ketik "Yo! Selamat datang di Akira Tools Installer!" "${KUNING}"
    sleep 1

    echo -e "\n${UNGU}Oke, pertama-tama, kita perlu cek lisensimu nih:${RESET}"
    read -p "$(echo -e ${PUTIH}Coba ketik namamu disini: ${RESET})" nama_lisensi

    animasi_ketik "Bentar ya, aku cek dulu..." "${KUNING}"
    animasi_loading 2
    status_lisensi=$(periksa_lisensi "$nama_lisensi")

    if [ "$status_lisensi" == "tidak valid" ]; then
        animasi_ketik "Waduh, lisensimu nggak valid nih. Instalasi gak bisa dilanjut, sorry ya!" "${MERAH}"
        exit 1
    fi

    animasi_ketik "Mantap! Lisensimu valid. Durasinya: $status_lisensi" "${HIJAU}"
    echo "$nama_lisensi" > ~/.lisensi_otomasi_telegram

    echo
    animasi_ketik "Oke, kita mulai instalasi ya! Siap-siap..." "${KUNING}"
    sleep 1

    echo -e "\n${CYAN}[1/4]${RESET} Ngecek dan masang yang dibutuhin..."
    tampilkan_progress 5 "Lagi masang dependencies"
    sudo apt update > /dev/null 2>&1
    sudo apt install -y python3 python3-pip unzip > /dev/null 2>&1
    animasi_ketik "Sip, udah keinstall semua!" "${HIJAU}"

    echo -e "\n${CYAN}[2/4]${RESET} Sekarang kita pasang paket Python-nya..."
    tampilkan_progress 3 "Masang paket Python"
    pip3 install telethon requests > /dev/null 2>&1
    animasi_ketik "Mantap, paket Python udah siap!" "${HIJAU}"

    echo -e "\n${CYAN}[3/4]${RESET} Lagi download file-file penting nih..."
    tampilkan_progress 4 "Download file"

    # Buat folder tersembunyi di home directory
    mkdir -p "$AKIRA_DIR"

    # Download dan ekstrak file zip
    wget -q "$URL_AKIRATOOLS" -O "$AKIRA_DIR/akiraa.zip"
    unzip -q "$AKIRA_DIR/akiraa.zip" -d "$AKIRA_DIR"
    rm "$AKIRA_DIR/akiraa.zip"

    animasi_ketik "Oke, semua file udah kedownload dan diekstrak!" "${HIJAU}"

    echo -e "\n${CYAN}[4/4]${RESET} Tinggal setting dikit..."
    tampilkan_progress 2 "Setting file"
    chmod 700 "$AKIRA_DIR"/*.py
    animasi_ketik "Nah, udah beres!" "${HIJAU}"

    # Buat alias untuk menjalankan script
    echo "alias akiratools='python3 $AKIRA_DIR/akiratools.py'" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

    echo
    animasi_ketik "Instalasi selesai! Gampang kan?" "${HIJAU}"
    sleep 1

    animasi_keren
    cetak_banner_animasi
    animasi_ketik "Selamat! Akira Tools udah siap dipakai!" "${HIJAU}"
    echo -e "\n${KUNING}Aku akan menjalankan Akira Tools secara otomatis dalam 5 detik...${RESET}"
    
    for i in {5..1}; do
        echo -en "${CYAN}$i... ${RESET}"
        sleep 1
    done
    echo

    animasi_ketik "Menjalankan Akira Tools..." "${HIJAU}"
    python3 "$AKIRA_DIR/akiratools.py"
}

# Jalankan instalasi
instal_otomasi_telegram