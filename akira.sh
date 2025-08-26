#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Versi script
SCRIPT_VERSION="2.1.0"

# Nama folder tersembunyi
HIDDEN_FOLDER="$HOME/.akira_tools"
CONFIG_FILE="$HOME/.akira_config"
LOG_FILE="$HOME/.akira_install.log"

LICENSE_FILE="$HOME/.lisensi_otomasi_telegram"

# URL lisensi dan update
LICENSE_URL="https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"
UPDATE_URL="https://raw.githubusercontent.com/Vendesu/AkiraTools/main/akira.sh"
CHANGELOG_URL="https://raw.githubusercontent.com/Vendesu/AkiraTools/main/UPDATE.md"

# Fungsi untuk logging
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
    echo -e "$message"
}

# Fungsi untuk animasi loading yang diperbaiki
show_loading() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    local count=0
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
        ((count++))
        if [ $count -gt 100 ]; then
            break
        fi
    done
    printf "    \b\b\b\b"
}

# Fungsi untuk membersihkan layar
clear_screen() {
    clear
}

# Fungsi untuk menampilkan header yang diperbaiki
print_header() {
    echo -e "${BLUE}"
    echo "========================================"
    echo "    Telegram Automation Tool Installer"
    echo "           Created by Akira"
    echo "           Version: $SCRIPT_VERSION"
    echo "========================================"
    echo -e "${NC}"
}

# Fungsi untuk menampilkan menu
show_menu() {
    echo -e "${CYAN}"
    echo "Pilih opsi:"
    echo "1. Instalasi Normal"
    echo "2. Instalasi dengan Update Otomatis"
    echo "3. Cek Update"
    echo "4. Uninstall"
    echo "5. Status Instalasi"
    echo "6. Lihat Changelog"
    echo "7. Keluar"
    echo -e "${NC}"
}

# Fungsi untuk cek koneksi internet
check_internet() {
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        log_message "${RED}Error: Tidak ada koneksi internet${NC}"
        return 1
    fi
    return 0
}

# Fungsi untuk cek update
check_for_updates() {
    log_message "${YELLOW}Memeriksa update...${NC}"
    
    if ! check_internet; then
        return 1
    fi
    
    local latest_version=$(wget -qO- "$UPDATE_URL" | grep "SCRIPT_VERSION=" | cut -d'"' -f2)
    
    if [[ "$latest_version" != "$SCRIPT_VERSION" ]]; then
        log_message "${GREEN}Update tersedia! Versi terbaru: $latest_version${NC}"
        return 0
    else
        log_message "${GREEN}Anda menggunakan versi terbaru.${NC}"
        return 1
    fi
}

# Fungsi untuk download changelog
show_changelog() {
    log_message "${YELLOW}Mengunduh changelog...${NC}"
    
    if ! check_internet; then
        return 1
    fi
    
    local changelog=$(wget -qO- "$CHANGELOG_URL" 2>/dev/null)
    
    if [[ -n "$changelog" ]]; then
        echo -e "${PURPLE}=== CHANGELOG ===${NC}"
        echo "$changelog"
    else
        log_message "${RED}Tidak dapat mengunduh changelog${NC}"
    fi
}

# Fungsi untuk setup environment yang diperbaiki
setup_environment() {
    log_message "${YELLOW}Menyiapkan lingkungan...${NC}"
    
    if ! check_internet; then
        return 1
    fi
    
    (
        mkdir -p "$HIDDEN_FOLDER" && cd "$HIDDEN_FOLDER" &&
        wget -q --timeout=30 https://github.com/Vendesu/AkiraTools/raw/main/akiraa.zip -O temp.zip &&
        if [ -f temp.zip ]; then
            unzip -q temp.zip &&
            rm temp.zip &&
            chmod -R 755 * &&
            echo "install_date=$(date '+%Y-%m-%d %H:%M:%S')" > "$CONFIG_FILE" &&
            echo "version=$SCRIPT_VERSION" >> "$CONFIG_FILE"
        else
            log_message "${RED}Gagal mengunduh file utama${NC}"
            return 1
        fi
    ) &
    show_loading $!
    wait $!
    
    if [ $? -eq 0 ]; then
        log_message "${GREEN}Lingkungan berhasil disiapkan.${NC}"
        return 0
    else
        log_message "${RED}Gagal menyiapkan lingkungan.${NC}"
        return 1
    fi
}

# Fungsi untuk validasi lisensi yang diperbaiki
validate_license() {
    local name="$1"
    log_message "${YELLOW}Memvalidasi lisensi...${NC}"

    if ! check_internet; then
        return 1
    fi

    # Mengunduh file lisensi dengan timeout
    local licenses=$(wget -qO- --timeout=30 "$LICENSE_URL" 2>/dev/null)

    if [[ -n "$licenses" && $licenses == *"$name"* ]]; then
        log_message "${GREEN}Lisensi valid.${NC}"
        return 0
    else
        log_message "${RED}Lisensi tidak valid atau tidak dapat terhubung ke server.${NC}"
        return 1
    fi
}

# Fungsi untuk menyiapkan lisensi yang diperbaiki
setup_license() {
    log_message "${YELLOW}Menyiapkan lisensi...${NC}"
    
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        read -p "Masukkan nama Anda (Percobaan $attempt/$max_attempts): " name
        
        if [[ -z "$name" ]]; then
            log_message "${RED}Nama tidak boleh kosong.${NC}"
            ((attempt++))
            continue
        fi
        
        if validate_license "$name"; then
            echo "$name" > "$LICENSE_FILE"
            log_message "${GREEN}Lisensi berhasil disiapkan.${NC}"
            return 0
        else
            ((attempt++))
            if [ $attempt -le $max_attempts ]; then
                log_message "${YELLOW}Coba lagi...${NC}"
            fi
        fi
    done
    
    log_message "${RED}Gagal menyiapkan lisensi setelah $max_attempts percobaan. Instalasi dibatalkan.${NC}"
    return 1
}

# Fungsi untuk menginstal dependensi yang diperbaiki
install_dependencies() {
    log_message "${YELLOW}Memeriksa dan menginstal dependensi...${NC}"

    # Memeriksa dan menginstal Python 3
    if ! command -v python3 &> /dev/null; then
        log_message "${YELLOW}Menginstal Python 3...${NC}"
        if ! sudo apt-get update && sudo apt-get install -y python3 python3-pip; then
            log_message "${RED}Gagal menginstal Python 3${NC}"
            return 1
        fi
    fi

    # Menginstal atau memperbarui dependensi Python
    log_message "${YELLOW}Menginstal modul Python yang diperlukan...${NC}"
    (
        python3 -m pip install --user --upgrade pip &&
        python3 -m pip install --user --upgrade telethon colorama requests aiogram asyncio
    ) &
    show_loading $!
    wait $!

    if [ $? -eq 0 ]; then
        log_message "${GREEN}Semua dependensi berhasil diinstal.${NC}"
        return 0
    else
        log_message "${RED}Gagal menginstal beberapa dependensi. Silakan coba install manual.${NC}"
        return 1
    fi
}

# Fungsi untuk membuat skrip akira yang diperbaiki
create_akira_script() {
    log_message "${YELLOW}Membuat skrip akira...${NC}"
    mkdir -p "$HOME/.local/bin"
    
    cat > "$HOME/.local/bin/akira" << EOL
#!/bin/bash
cd "$HIDDEN_FOLDER"
if [ -f akiratools.py ]; then
    python3 akiratools.py "\$@"
else
    echo "Error: File akiratools.py tidak ditemukan"
    echo "Silakan jalankan instalasi ulang"
    exit 1
fi
EOL
    chmod +x "$HOME/.local/bin/akira"

    # Menambahkan $HOME/.local/bin ke PATH jika belum ada
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        export PATH="$HOME/.local/bin:$PATH"
    fi

    log_message "${GREEN}Skrip akira berhasil dibuat.${NC}"
}

# Fungsi untuk menambahkan akira ke .bashrc yang diperbaiki
add_akira_to_bashrc() {
    log_message "${YELLOW}Menambahkan akira ke .bashrc...${NC}"
    
    # Cek apakah sudah ada di .bashrc
    if ! grep -q "akira" "$HOME/.bashrc"; then
        echo 'akira' >> "$HOME/.bashrc"
        log_message "${GREEN}akira berhasil ditambahkan ke .bashrc${NC}"
    else
        log_message "${YELLOW}akira sudah ada di .bashrc${NC}"
    fi
}

# Fungsi untuk uninstall
uninstall_akira() {
    log_message "${YELLOW}Menghapus AkiraTools...${NC}"
    
    # Hapus folder tersembunyi
    if [ -d "$HIDDEN_FOLDER" ]; then
        rm -rf "$HIDDEN_FOLDER"
        log_message "${GREEN}Folder $HIDDEN_FOLDER dihapus${NC}"
    fi
    
    # Hapus file konfigurasi
    if [ -f "$CONFIG_FILE" ]; then
        rm "$CONFIG_FILE"
        log_message "${GREEN}File konfigurasi dihapus${NC}"
    fi
    
    # Hapus file lisensi
    if [ -f "$LICENSE_FILE" ]; then
        rm "$LICENSE_FILE"
        log_message "${GREEN}File lisensi dihapus${NC}"
    fi
    
    # Hapus script dari .local/bin
    if [ -f "$HOME/.local/bin/akira" ]; then
        rm "$HOME/.local/bin/akira"
        log_message "${GREEN}Script akira dihapus${NC}"
    fi
    
    # Hapus dari .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/akira/d' "$HOME/.bashrc"
        log_message "${GREEN}akira dihapus dari .bashrc${NC}"
    fi
    
    log_message "${GREEN}Uninstall selesai!${NC}"
}

# Fungsi untuk cek status instalasi
check_installation_status() {
    log_message "${CYAN}=== Status Instalasi AkiraTools ===${NC}"
    
    if [ -d "$HIDDEN_FOLDER" ]; then
        log_message "${GREEN}✓ Folder instalasi: $HIDDEN_FOLDER${NC}"
    else
        log_message "${RED}✗ Folder instalasi tidak ditemukan${NC}"
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        log_message "${GREEN}✓ File konfigurasi ditemukan${NC}"
        cat "$CONFIG_FILE"
    else
        log_message "${RED}✗ File konfigurasi tidak ditemukan${NC}"
    fi
    
    if [ -f "$LICENSE_FILE" ]; then
        log_message "${GREEN}✓ File lisensi ditemukan${NC}"
        log_message "Lisensi: $(cat "$LICENSE_FILE")"
    else
        log_message "${RED}✗ File lisensi tidak ditemukan${NC}"
    fi
    
    if [ -f "$HOME/.local/bin/akira" ]; then
        log_message "${GREEN}✓ Script akira ditemukan${NC}"
    else
        log_message "${RED}✗ Script akira tidak ditemukan${NC}"
    fi
    
    if command -v akira &> /dev/null; then
        log_message "${GREEN}✓ Command 'akira' tersedia${NC}"
    else
        log_message "${RED}✗ Command 'akira' tidak tersedia${NC}"
    fi
}

# Fungsi instalasi normal
install_normal() {
    clear_screen
    print_header
    
    # Periksa ketersediaan tools
    if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null; then
        log_message "${RED}Error: wget atau unzip tidak tersedia. Menginstal...${NC}"
        if ! sudo apt-get update && sudo apt-get install -y wget unzip; then
            log_message "${RED}Gagal menginstal wget/unzip${NC}"
            return 1
        fi
    fi

    if setup_environment && setup_license && install_dependencies && create_akira_script && add_akira_to_bashrc; then
        log_message "${GREEN}Instalasi selesai!${NC}"
        log_message "${YELLOW}Telegram Automation Tool akan otomatis terbuka saat Anda membuka terminal baru.${NC}"
        log_message "${YELLOW}Untuk menjalankannya secara manual, gunakan perintah 'akira'.${NC}"
        log_message "${BLUE}Modul yang digunakan: Python 3, Telethon, Colorama, Requests, aiogram, asyncio${NC}"
        log_message "${YELLOW}Catatan: Perubahan akan berlaku setelah Anda membuka terminal baru atau menjalankan 'source ~/.bashrc'.${NC}"
        return 0
    else
        log_message "${RED}Instalasi gagal!${NC}"
        return 1
    fi
}

# Fungsi instalasi dengan update otomatis
install_with_auto_update() {
    log_message "${YELLOW}Mengaktifkan update otomatis...${NC}"
    
    # Tambahkan cron job untuk update otomatis
    (crontab -l 2>/dev/null; echo "0 2 * * * $HOME/.local/bin/akira --check-update") | crontab -
    log_message "${GREEN}Update otomatis diaktifkan (setiap hari jam 2 pagi)${NC}"
    
    install_normal
}

# Fungsi utama yang diperbaiki
main() {
    # Inisialisasi log file
    echo "=== AkiraTools Installation Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    
    clear_screen
    print_header
    
    while true; do
        show_menu
        read -p "Pilih opsi (1-7): " choice
        
        case $choice in
            1)
                install_normal
                break
                ;;
            2)
                install_with_auto_update
                break
                ;;
            3)
                check_for_updates
                ;;
            4)
                uninstall_akira
                break
                ;;
            5)
                check_installation_status
                ;;
            6)
                show_changelog
                ;;
            7)
                log_message "${YELLOW}Keluar dari installer...${NC}"
                exit 0
                ;;
            *)
                log_message "${RED}Pilihan tidak valid. Silakan pilih 1-7.${NC}"
                ;;
        esac
        
        if [ $choice -eq 1 ] || [ $choice -eq 2 ] || [ $choice -eq 4 ]; then
            break
        fi
        
        echo
        read -p "Tekan Enter untuk melanjutkan..."
        clear_screen
        print_header
    done
}

# Jalankan fungsi utama
main