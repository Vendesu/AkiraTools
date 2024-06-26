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
    lisensi=$(curl -s "$URL_LISENSI")
    
    if echo "$lisensi" | grep -qi "^$username,"; then
        return 0
    else
        return 1
    fi
}

install_dependencies() {
    animasi_loading 3 "Menginstall dependensi"
    
    # Update package list
    sudo apt-get update

    # Install Python, pip, screen, and unzip
    sudo apt-get install -y python3 python3-pip screen unzip

    # Install modul Python yang dibutuhkan
    pip3 install telethon requests beautifulsoup4

    # Tambahkan modul lain yang mungkin dibutuhkan di sini
}

subproses_instalasi() {
    animasi_loading 3 "Menyiapkan lingkungan"
    animasi_loading 5 "Mengunduh komponen"
    
    # Download and unzip akira.zip
    animasi_loading 3 "Mengunduh dan mengekstrak akira.zip"
    curl -L -o /tmp/akira.zip https://github.com/Vendesu/AkiraTools/raw/main/akira.zip
    sudo unzip -o /tmp/akira.zip -d /usr/bin/
    sudo rm /tmp/akira.zip
    
    animasi_loading 3 "Mengkonfigurasi sistem"
    
    cat > /usr/local/bin/akiratools << EOL
#!/bin/bash

HIJAU='\033[0;32m'
KUNING='\033[1;33m'
BIRU='\033[0;34m'
NORMAL='\033[0m'

# Fungsi untuk menjalankan akiratools dalam screen
run_akiratools() {
    # Periksa apakah sesi screen sudah ada
    if ! screen -list | grep -q "akiratools"; then
        # Jika tidak ada, buat sesi baru
        screen -dmS akiratools python3 /usr/bin/akiratools.py
        echo -e "${HIJAU}Sesi screen 'akiratools' telah dimulai.${NORMAL}"
    else
        echo -e "${KUNING}Sesi screen 'akiratools' sudah berjalan.${NORMAL}"
    fi

    echo -e "${BIRU}Untuk melihat sesi, ketik: ${KUNING}screen -r akiratools${NORMAL}"
    echo -e "${BIRU}Untuk keluar dari sesi tanpa menghentikannya, tekan: ${KUNING}Ctrl+A kemudian D${NORMAL}"
}

# Jalankan fungsi
run_akiratools

# Tanya pengguna apakah ingin langsung masuk ke sesi screen
read -p "Apakah Anda ingin masuk ke sesi screen sekarang? (y/n): " answer
if [[ $answer == "y" || $answer == "Y" ]]; then
    screen -r akiratools
else
    echo -e "${BIRU}Anda dapat masuk ke sesi nanti dengan mengetik: ${KUNING}screen -r akiratools${NORMAL}"
fi
EOL

    chmod +x /usr/local/bin/akiratools
    
    animasi_loading 2 "Membersihkan"
}

utama() {
    # Animasi loading di awal script
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
    
    # Install dependencies
    install_dependencies
    
    # Menjalankan subproses instalasi
    subproses_instalasi &
    PID=$!

    # Menampilkan animasi loading selama subproses berjalan
    while kill -0 $PID 2>/dev/null; do
        for i in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
            echo -ne "\r${CYAN}$i Instalasi sedang berlangsung...${NORMAL}"
            sleep 0.1
        done
    done

    # Menunggu subproses selesai
    wait $PID
    
    echo -e "\n${HIJAU}Instalasi selesai!${NORMAL}"
    echo -e "${BIRU}Anda sekarang dapat menjalankan alat ini dengan mengetik: ${KUNING}akiratools${NORMAL}"
    echo -e "${BIRU}Saat Anda menjalankan akiratools, sesi screen akan dibuat secara otomatis.${NORMAL}"
}

utama