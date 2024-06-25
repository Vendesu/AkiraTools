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
    echo -e "${KUNING}Selamat datang di Alat Otomasi Telegram${NORMAL}"
    echo -e "${KUNING}Dibuat oleh Akira${NORMAL}"
    echo
}

tampilkan_menu() {
    echo -e "${CYAN}Menu Utama:${NORMAL}"
    echo -e "${KUNING}1. Jalankan AkiraTools${NORMAL}"
    echo -e "${KUNING}2. Jalankan GrabGrup${NORMAL}"
    echo -e "${KUNING}3. Jalankan Grup${NORMAL}"
    echo -e "${KUNING}4. Jalankan SpamOri${NORMAL}"
    echo -e "${KUNING}5. Jalankan SpamUp${NORMAL}"
    echo -e "${KUNING}6. Keluar${NORMAL}"
    echo
    echo -n "Pilih opsi (1-6): "
}

jalankan_tool() {
    local tool=$1
    screen -S $tool -d -m python3 /usr/bin/${tool}.py
    echo -e "${HIJAU}Sesi screen '$tool' telah dimulai.${NORMAL}"
    echo -e "${BIRU}Untuk melihat sesi, ketik: ${KUNING}screen -r $tool${NORMAL}"
    echo -e "${BIRU}Untuk keluar dari sesi tanpa menghentikannya, tekan: ${KUNING}Ctrl+A kemudian D${NORMAL}"
    sleep 2
    screen -r $tool
}

menu_akira() {
    while true; do
        clear
        tampilkan_banner
        tampilkan_menu

        read pilihan

        case $pilihan in
            1) jalankan_tool "akiratools" ;;
            2) jalankan_tool "grabgrup" ;;
            3) jalankan_tool "grup" ;;
            4) jalankan_tool "spamori" ;;
            5) jalankan_tool "spamup" ;;
            6) echo -e "${HIJAU}Terima kasih telah menggunakan Alat Otomasi Telegram!${NORMAL}"; exit 0 ;;
            *) echo -e "${MERAH}Pilihan tidak valid. Silakan coba lagi.${NORMAL}"; sleep 2 ;;
        esac
    done
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

    # Install Python dan pip jika belum ada
    sudo apt-get install -y python3 python3-pip

    # Install screen
    sudo apt-get install -y screen

    # Install modul Python yang dibutuhkan
    pip3 install telethon requests beautifulsoup4

    # Tambahkan modul lain yang mungkin dibutuhkan di sini
}

subproses_instalasi() {
    animasi_loading 3 "Menyiapkan lingkungan"
    animasi_loading 5 "Mengunduh komponen"
    
    sudo curl -s -o /usr/bin/akiratools.py https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/akiratools.py
    sudo curl -s -o /usr/bin/grabgrup.py https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/grabgrup.py
    sudo curl -s -o /usr/bin/grup.py https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/grup.py
    sudo curl -s -o /usr/bin/spamori.py https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/spamori.py
    sudo curl -s -o /usr/bin/spamup.py https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/spamup.py
    
    animasi_loading 3 "Mengkonfigurasi sistem"
    
    sudo tee /usr/bin/akiratools << EOL
#!/bin/bash

$(declare -f tampilkan_banner)
$(declare -f tampilkan_menu)
$(declare -f jalankan_tool)
$(declare -f menu_akira)

# Jalankan menu
menu_akira
EOL

    sudo chmod +x /usr/bin/akiratools
    
    # Buat symlink untuk perintah 'akira'
    sudo ln -sf /usr/bin/akiratools /usr/bin/akira
    
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
    echo -e "${BIRU}Anda sekarang dapat menjalankan alat ini dengan mengetik: ${KUNING}akira${NORMAL}"
}

utama