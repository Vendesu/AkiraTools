#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

LICENSE_FILE = os.path.expanduser("~/.lisensi_otomasi_telegram")

# Nama folder tersembunyi
HIDDEN_FOLDER="$HOME/.akira_tools"

# URL lisensi
LICENSE_URL="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"

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
        unzip -q temp.zip && rm temp.zip &&
        chmod -R 755 *.py  # Memberikan akses eksekusi ke semua file Python
    ) &
    show_loading $!
    echo -e "${GREEN}Lingkungan berhasil disiapkan.${NC}"
}

# Fungsi untuk validasi lisensi
validate_license() {
    local name="$1"
    echo -e "${YELLOW}Memvalidasi lisensi...${NC}"

    # Mengunduh file lisensi
    local licenses=$(wget -qO- "$LICENSE_URL")

    if [[ $licenses == *"$name"* ]]; then
        echo -e "${GREEN}Lisensi valid.${NC}"
        return 0
    else
        echo -e "${RED}Lisensi tidak valid.${NC}"
        return 1
    fi
}

# Fungsi untuk menyiapkan lisensi
setup_license() {
    echo -e "${YELLOW}Menyiapkan lisensi...${NC}"
    read -p "Masukkan nama Anda: " name

    if validate_license "$name"; then
        echo "$name" > "$HIDDEN_FOLDER/.lisensi_otomasi_telegram"
        echo -e "${GREEN}Lisensi berhasil disiapkan.${NC}"
    else
        echo -e "${RED}Gagal menyiapkan lisensi. Instalasi dibatalkan.${NC}"
        exit 1
    fi
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
    (python3 -m pip install --user --upgrade pip telethon colorama requests) &
    show_loading $!

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Semua dependensi berhasil diinstal.${NC}"
    else
        echo -e "${RED}Gagal menginstal beberapa dependensi. Silakan coba install manual.${NC}"
        exit 1
    fi
}

# Fungsi untuk membuat skrip akira
create_akira_script() {
    echo -e "${YELLOW}Membuat skrip akira...${NC}"
    mkdir -p "$HOME/.local/bin"
    cat > "$HOME/.local/bin/akira" << EOL
#!/bin/bash
python3 $HIDDEN_FOLDER/akiratools.py "\$@"
EOL
    chmod +x "$HOME/.local/bin/akira"

    # Menambahkan $HOME/.local/bin ke PATH jika belum ada
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        export PATH="$HOME/.local/bin:$PATH"
    fi

    echo -e "${GREEN}Skrip akira berhasil dibuat.${NC}"
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
    create_akira_script

    echo -e "${GREEN}Instalasi selesai!${NC}"
    echo -e "${YELLOW}Memuat konfigurasi baru...${NC}"

    # Memuat .bashrc secara otomatis
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi

    echo -e "${GREEN}Konfigurasi baru berhasil dimuat.${NC}"
    echo -e "${YELLOW}Anda dapat menjalankan Telegram Automation Tool dengan perintah 'akira'.${NC}"
    echo -e "${BLUE}Modul yang digunakan: Python 3, Telethon, Colorama, Requests${NC}"
    echo -e "${YELLOW}Catatan: Jika perintah 'akira' tidak berfungsi, coba keluar dan masuk kembali ke terminal atau jalankan 'source ~/.bashrc'.${NC}"
}

# Jalankan fungsi utama
main