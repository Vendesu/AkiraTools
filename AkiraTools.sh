#!/bin/bash

set -e

# Warna
declare -A colors=(
    [MERAH]='\033[0;31m'
    [HIJAU]='\033[0;32m'
    [KUNING]='\033[1;33m'
    [BIRU]='\033[0;34m'
    [MAGENTA]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [NORMAL]='\033[0m'
)

URL_LISENSI="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"
TOOLS=(akiratools grabgrup grup spamori spamup)

animasi_loading() {
    local durasi=$1
    local pesan=$2
    local karakter=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local waktu_mulai=$(date +%s)

    while [ $(($(date +%s) - waktu_mulai)) -lt $durasi ]; do
        for i in "${karakter[@]}"; do
            echo -ne "\r${colors[CYAN]}$i ${pesan}${colors[NORMAL]}"
            sleep 0.1
        done
    done
    echo -e "\r${colors[HIJAU]}✓ ${pesan} Selesai!${colors[NORMAL]}"
}

tampilkan_banner() {
    echo -e "${colors[MAGENTA]}"
    cat << "EOF"
  ______     __      _                ______                __   
 /_  __/__  / /__   (_)___  _________/_  __/___  ____  ____/ /__ 
  / / / _ \/ / _ \ / / __ \/ ___/ __ \/ / / __ \/ __ \/ __  / _ \
 / / /  __/ /  __// / /_/ / /  / /_/ / / / /_/ / /_/ / /_/ /  __/
/_/  \___/_/\___//_/\__, /_/   \____/_/  \____/\____/\__,_/\___/ 
                   /____/                                        
EOF
    echo -e "${colors[NORMAL]}"
    echo -e "${colors[KUNING]}Selamat datang di Alat Otomasi Telegram${colors[NORMAL]}"
    echo -e "${colors[KUNING]}Dibuat oleh Akira${colors[NORMAL]}\n"
}

tampilkan_menu() {
    echo -e "${colors[CYAN]}Menu Utama:${colors[NORMAL]}"
    for i in "${!TOOLS[@]}"; do
        echo -e "${colors[KUNING]}$((i+1)). Jalankan ${TOOLS[i]}${colors[NORMAL]}"
    done
    echo -e "${colors[KUNING]}$((${#TOOLS[@]}+1)). Keluar${colors[NORMAL]}\n"
    echo -n "Pilih opsi (1-$((${#TOOLS[@]}+1))): "
}

jalankan_tool() {
    local tool=$1
    screen -S $tool -d -m python3 /usr/bin/${tool}.py
    echo -e "${colors[HIJAU]}Sesi screen '$tool' telah dimulai.${colors[NORMAL]}"
    echo -e "${colors[BIRU]}Untuk melihat sesi, ketik: ${colors[KUNING]}screen -r $tool${colors[NORMAL]}"
    echo -e "${colors[BIRU]}Untuk keluar dari sesi tanpa menghentikannya, tekan: ${colors[KUNING]}Ctrl+A kemudian D${colors[NORMAL]}"
    sleep 2
    screen -r $tool
}

menu_akira() {
    while true; do
        clear
        tampilkan_banner
        tampilkan_menu

        read -r pilihan

        if [[ $pilihan =~ ^[1-$((${#TOOLS[@]}+1))]$ ]]; then
            if [ "$pilihan" -eq $((${#TOOLS[@]}+1)) ]; then
                echo -e "${colors[HIJAU]}Terima kasih telah menggunakan Alat Otomasi Telegram!${colors[NORMAL]}"
                exit 0
            else
                jalankan_tool "${TOOLS[$((pilihan-1))]}"
            fi
        else
            echo -e "${colors[MERAH]}Pilihan tidak valid. Silakan coba lagi.${colors[NORMAL]}"
            sleep 2
        fi
    done
}

periksa_lisensi() {
    local username=$1
    local lisensi
    lisensi=$(curl -s "$URL_LISENSI")
    
    [[ $lisensi =~ ^$username, ]]
}

install_dependencies() {
    animasi_loading 3 "Menginstall dependensi"
    
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip screen
    pip3 install telethon requests beautifulsoup4
}

subproses_instalasi() {
    animasi_loading 3 "Menyiapkan lingkungan"
    animasi_loading 5 "Mengunduh komponen"
    
    for tool in "${TOOLS[@]}"; do
        sudo curl -s -o "/usr/bin/${tool}.py" "https://raw.githubusercontent.com/Vendesu/asasakaowjoaoaosks/main/${tool}.py"
    done
    
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
    sudo ln -sf /usr/bin/akiratools /usr/bin/akira
    
    animasi_loading 2 "Membersihkan"
}

main() {
    animasi_loading 3 "Memulai instalasi"
    tampilkan_banner

    while true; do
        read -p "Silakan masukkan username Anda: " username

        if periksa_lisensi "$username"; then
            echo -e "${colors[HIJAU]}Lisensi valid. Melanjutkan instalasi...${colors[NORMAL]}"
            break
        else
            echo -e "${colors[MERAH]}Lisensi tidak valid. Silakan coba lagi atau hubungi administrator.${colors[NORMAL]}"
        fi
    done
    
    echo "$username" > ~/.lisensi_otomasi_telegram
    
    install_dependencies
    
    subproses_instalasi &
    PID=$!

    while kill -0 $PID 2>/dev/null; do
        for i in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
            echo -ne "\r${colors[CYAN]}$i Instalasi sedang berlangsung...${colors[NORMAL]}"
            sleep 0.1
        done
    done

    wait $PID
    
    echo -e "\n${colors[HIJAU]}Instalasi selesai!${colors[NORMAL]}"
    echo -e "${colors[BIRU]}Anda sekarang dapat menjalankan alat ini dengan mengetik: ${colors[KUNING]}akira${colors[NORMAL]}"
}

main