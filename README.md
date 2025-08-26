# AkiraTools

## 📋 Deskripsi

AkiraTools adalah alat otomasi Telegram yang dikembangkan oleh Akira. Tool ini menyediakan berbagai fitur otomasi untuk Telegram dengan antarmuka yang mudah digunakan melalui command line.

## ✨ Fitur Utama

- **Instalasi Otomatis**: Script instalasi yang mudah dan otomatis
- **Validasi Lisensi**: Sistem lisensi untuk mengontrol akses
- **Dependensi Otomatis**: Menginstal semua dependensi yang diperlukan secara otomatis
- **Antarmuka Berwarna**: Output yang informatif dengan warna-warna yang menarik
- **Integrasi Terminal**: Terintegrasi langsung dengan terminal Linux

## 🚀 Cara Instalasi

### Persyaratan Sistem
- Sistem operasi Linux
- Akses internet
- Hak akses sudo (untuk instalasi dependensi)

### Langkah Instalasi

1. **Clone atau download repository ini**
   ```bash
   git clone <repository-url>
   cd AkiraTools
   ```

2. **Jalankan script instalasi**
   ```bash
   chmod +x akira.sh
   ./akira.sh
   ```

3. **Ikuti instruksi yang muncul**
   - Masukkan nama Anda untuk validasi lisensi
   - Tunggu proses instalasi selesai

4. **Restart terminal atau jalankan**
   ```bash
   source ~/.bashrc
   ```

## 📦 Dependensi yang Diinstal

Script instalasi akan menginstal dependensi berikut secara otomatis:

- **Python 3**: Bahasa pemrograman utama
- **Telethon**: Library Python untuk Telegram API
- **aiogram**: Framework untuk bot Telegram
- **colorama**: Library untuk output berwarna
- **requests**: Library untuk HTTP requests
- **wget & unzip**: Tools untuk download dan ekstraksi file

## 🎯 Cara Penggunaan

Setelah instalasi selesai, Anda dapat menggunakan tool dengan cara:

```bash
akira
```

Tool akan otomatis terbuka saat Anda membuka terminal baru, atau Anda dapat menjalankannya secara manual dengan perintah di atas.

## 📁 Struktur File

```
AkiraTools/
├── README.md          # Dokumentasi proyek
├── akira.sh           # Script instalasi utama
└── akiraa.zip         # File kompresi berisi tool utama
```

## 🔧 Konfigurasi

Tool akan membuat folder tersembunyi di `~/.akira_tools` yang berisi semua file yang diperlukan. File lisensi disimpan di `~/.lisensi_otomasi_telegram`.

## ⚠️ Catatan Penting

- Pastikan Anda memiliki lisensi yang valid sebelum menggunakan tool
- Tool memerlukan koneksi internet untuk validasi lisensi dan download dependensi
- Beberapa fitur mungkin memerlukan konfigurasi API Telegram tambahan

## 🛠️ Troubleshooting

### Masalah Umum

1. **Error lisensi tidak valid**
   - Pastikan nama yang dimasukkan sesuai dengan lisensi yang terdaftar
   - Periksa koneksi internet

2. **Dependensi gagal terinstal**
   - Jalankan `sudo apt-get update` terlebih dahulu
   - Pastikan Anda memiliki hak akses sudo

3. **Command 'akira' tidak ditemukan**
   - Restart terminal atau jalankan `source ~/.bashrc`
   - Periksa apakah `~/.local/bin` ada di PATH

## 📞 Dukungan

Untuk bantuan dan dukungan, silakan hubungi developer atau buat issue di repository ini.

## 📄 Lisensi

Tool ini menggunakan sistem lisensi khusus. Pastikan Anda memiliki lisensi yang valid sebelum menggunakan.

---

**Dikembangkan dengan ❤️ oleh Akira**