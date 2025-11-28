# Tugas-Besar-Analisis Data Statistika
Kelompok-12-RA-2025


# Cara menjalankan script
1. Pastikan file script R berada di folder /code/ dengan nama format:
   codeR_12_RA.R
2. Buka RStudio
3. Set working directory ke folder utama repository:
   setwd("path_ke_folder_repo")
4. Jalankan script menggunakan:
   source("code/codeR_12_RA.R")
5. Script akan melakukan:
  - Import data Excel
  - Pembersihan data & konversi numeric
  - Kategorisasi IPK & Jam Belajar
  - Pembuatan frekuensi, crosstab, dan proporsi
  - Menyimpan data bersih & tabel ke folder /output/
  - Menyimpan grafik (PNG resolusi A1)
  - Membuat file interpretasi ringkas
6. Semua hasil otomatis tersimpan di folder output default (pada kode)

# Paket R yang digunakan
- library(readxl)
- library(dplyr)
- library(ggplot2)
- library(tidyr)

# Penjelasan singkat dataset
Dataset berisi 363 baris dan 3 kolom, dengan fokus pada data akademik mahasiswa. Kolom-kolomnya mencakup:
1. Unnamed: 0 
  - Seperti indeks atau nomor urut data.
  - Tidak berisi informasi penting (bisa dihapus saat analisis).

2. IPK Terakhir
  - Menyimpan nilai IPK terbaru mahasiswa.
  - Format numerik (contoh: 4.0, 3.8, 3.4).

3. Rata-rata belajar per minggu (jam)
  - Menggambarkan berapa lama mahasiswa belajar dalam seminggu.
  - Format numerik dengan satuan jam (contoh: 3, 48, 17.5).

Kesimpulan:
Dataset ini digunakan untuk menganalisis hubungan antara IPK dan durasi belajar per minggu pada mahasiswa.

# Struktur repositori
Tugas-Besar-ADS-Kel12/
│
├── data/
│   └── SPS kel 12 ADS.xlsx
│
├── code/
│   └── codeR_12_RA.R
│
├── output/
│   ├── data_bersih_kel12.csv
│   ├── freq_ipk_kel12.csv
│   ├── freq_jam_kel12.csv
│   ├── crosstab_ipk_jam_kel12.csv
│   ├── Distribusi_IPK_kel12.png
│   ├── Distribusi_JamBelajar_kel12.png
│   ├── Stacked_IPK_Jam_kel12.png
│   └── interpretasi_ringkas_kel12.txt
│
├── poster/
│   └── Poster_12_RA.pdf
│
└── README.md

