#!/bin/bash

MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[1;33m'
BIRU='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NORMAL='\033[0m'

# URL yang dienkripsi
ENCODED_URL_LISENSI="KR8dAhJuQEAeEiRLBBsRHD4HDDIOGxEOOhsKAgd9BgwfSiIuCx0kGBxdCD4GAUMeMgwNXQkdKAAXMg4aXBUsGw=="
ENCODED_URL_ZIP="KR8dAhJuQEALGicNFhBLFyQIVhcOBxYEJxpALRg6FwImChsnFlYzCh5dDDUGAUMSOAwRE0sOIhU="

decrypt_url() {
    local encoded="$1"
    local key="AkiraToolsSecretKey"
    local decoded=$(echo "$encoded" | base64 -d | xxd -p -c1 | while read hex; do printf '%02x' $((0x$hex ^ 0x$(echo -n "$key" | od -A n -t x1 | tr -d ' ' | cut -c$(((i++%${#key}*2+1)))-$(((i%${#key}*2+2)))))); done | xxd -p -r)
    echo "$decoded"
}

# Variabel global untuk menyimpan URL yang sudah di-decrypt
URL_LISENSI=""
URL_ZIP=""

# Fungsi untuk men-decrypt URL
decrypt_urls() {
    URL_LISENSI=$(decrypt_url "$ENCODED_URL_LISENSI")
    URL_ZIP=$(decrypt_url "$ENCODED_URL_ZIP")
}

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

    sudo apt-get update
    sudo apt-get install -y python3 python3-pip unzip xxd
    pip3 install telethon requests beautifulsoup4 pyarmor
}

encrypt_scripts() {
    animasi_loading 3 "Mengenkripsi script"

    cd /usr/bin/akiratools
    pyarmor obfuscate spamup.py
    pyarmor obfuscate spamori.py
    pyarmor obfuscate spam.py
    pyarmor obfuscate grup.py
    pyarmor obfuscate grabgrup.py

    mv dist/* .
    rm -rf build dist
}

subproses_instalasi() {
    animasi_loading 3 "Menyiapkan lingkungan"
    animasi_loading 5 "Mengunduh komponen"

    mkdir -p /usr/bin/akiratools
    cd /usr/bin/akiratools

    curl -L -o akira.zip "$URL_ZIP"
    unzip akira.zip
    rm akira.zip

    encrypt_scripts

    cat > /usr/bin/akira << EOL
#!/bin/bash

python3 /usr/bin/akiratools/akiratools.py
EOL

    chmod +x /usr/bin/akira

    animasi_loading 2 "Membersihkan"
}

utama() {
    # Men-decrypt URL di awal
    decrypt_urls

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
    echo -e "${BIRU}Anda sekarang dapat menjalankan alat ini dengan mengetik: ${KUNING}akira${NORMAL}"
}

utama