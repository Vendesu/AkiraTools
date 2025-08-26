#!/bin/bash

# Test script untuk AkiraTools
# Digunakan untuk testing dan debugging

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== AkiraTools Test Script ===${NC}"
echo "Testing berbagai komponen AkiraTools..."

# Test 1: Cek koneksi internet
echo -e "\n${YELLOW}Test 1: Koneksi Internet${NC}"
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}✓ Koneksi internet OK${NC}"
else
    echo -e "${RED}✗ Tidak ada koneksi internet${NC}"
fi

# Test 2: Cek dependensi sistem
echo -e "\n${YELLOW}Test 2: Dependensi Sistem${NC}"
deps=("wget" "curl" "unzip" "python3" "pip3")
for dep in "${deps[@]}"; do
    if command -v $dep &> /dev/null; then
        echo -e "${GREEN}✓ $dep tersedia${NC}"
    else
        echo -e "${RED}✗ $dep tidak tersedia${NC}"
    fi
done

# Test 3: Cek file instalasi
echo -e "\n${YELLOW}Test 3: File Instalasi${NC}"
files=("akira.sh" "README.md" "UPDATE.md")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file ada${NC}"
    else
        echo -e "${RED}✗ $file tidak ada${NC}"
    fi
done

# Test 4: Cek permission
echo -e "\n${YELLOW}Test 4: Permission File${NC}"
if [ -x "akira.sh" ]; then
    echo -e "${GREEN}✓ akira.sh dapat dieksekusi${NC}"
else
    echo -e "${RED}✗ akira.sh tidak dapat dieksekusi${NC}"
    echo -e "${YELLOW}Menjalankan: chmod +x akira.sh${NC}"
    chmod +x akira.sh
fi

# Test 5: Cek URL repository
echo -e "\n${YELLOW}Test 5: URL Repository${NC}"
urls=(
    "https://raw.githubusercontent.com/Vendesu/AkiraTools/main/akira.sh"
    "https://raw.githubusercontent.com/Vendesu/AkiraTools/main/UPDATE.md"
    "https://raw.githubusercontent.com/Vendesu/ijin/main/licenses.txt"
)

for url in "${urls[@]}"; do
    if wget --spider -q "$url"; then
        echo -e "${GREEN}✓ $url dapat diakses${NC}"
    else
        echo -e "${RED}✗ $url tidak dapat diakses${NC}"
    fi
done

# Test 6: Cek instalasi AkiraTools (jika ada)
echo -e "\n${YELLOW}Test 6: Status Instalasi AkiraTools${NC}"
if [ -d "$HOME/.akira_tools" ]; then
    echo -e "${GREEN}✓ AkiraTools terinstal${NC}"
    if [ -f "$HOME/.akira_config" ]; then
        echo -e "${GREEN}✓ File konfigurasi ada${NC}"
        cat "$HOME/.akira_config"
    fi
else
    echo -e "${YELLOW}⚠ AkiraTools belum terinstal${NC}"
fi

# Test 7: Cek command akira
echo -e "\n${YELLOW}Test 7: Command Akira${NC}"
if command -v akira &> /dev/null; then
    echo -e "${GREEN}✓ Command 'akira' tersedia${NC}"
else
    echo -e "${YELLOW}⚠ Command 'akira' tidak tersedia${NC}"
fi

# Test 8: Cek Python modules
echo -e "\n${YELLOW}Test 8: Python Modules${NC}"
modules=("telethon" "aiogram" "colorama" "requests" "asyncio")
for module in "${modules[@]}"; do
    if python3 -c "import $module" 2>/dev/null; then
        echo -e "${GREEN}✓ $module terinstal${NC}"
    else
        echo -e "${RED}✗ $module tidak terinstal${NC}"
    fi
done

echo -e "\n${BLUE}=== Test Selesai ===${NC}"
echo -e "${YELLOW}Jika ada error, silakan periksa dan perbaiki sebelum menjalankan instalasi.${NC}"