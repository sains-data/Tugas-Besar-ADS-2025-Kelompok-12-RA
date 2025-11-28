# codeR_12_RA.R
# Kelompok 12 - Eksplorasi Data Kategorik: IPK & Jam Belajar
# File input (lokal): /mnt/data/SPS kel 12 ADS.xlsx

# ---------------------------
# 1) Persiapan environment
# ---------------------------
# install.packages(c("readxl","dplyr","ggplot2","tidyr"))
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# ---------------------------
# 2) Load data
# ---------------------------
input_path <- "/Users/hazelmahesahandhaka/Downloads/SPS kel 12 ADS.xlsx"
raw <- read_excel(input_path)

# lihat struktur singkat
print("Preview awal data:")
print(head(raw))

# ---------------------------
# 3) Cleaning & pra-proses
# ---------------------------


raw_clean <- raw %>% select(-starts_with("Unnamed"), everything())


# Asumsi: kolom pertama = IPK, kolom kedua = Jam Belajar
colnames(raw_clean)[1:2] <- c("IPK", "JamBelajar")

# Replace koma decimal di JamBelajar (misal "17,5") -> "17.5", lalu ke numeric
raw_clean <- raw_clean %>%
  mutate(
    JamBelajar = as.character(JamBelajar),
    JamBelajar = gsub(",", ".", JamBelajar),
    JamBelajar = as.numeric(JamBelajar),
    IPK = as.numeric(as.character(IPK))
  )

# Cek berapa missing setelah konversi
cat("Jumlah NA IPK:", sum(is.na(raw_clean$IPK)), "\n")
cat("Jumlah NA JamBelajar:", sum(is.na(raw_clean$JamBelajar)), "\n")

# Optional: jika ada baris dengan kedua variabel NA, buang
df <- raw_clean %>% filter(!(is.na(IPK) & is.na(JamBelajar)))

# ---------------------------
# 4) Kategorisasi (sesuai diskusi)
# ---------------------------
# Kategori IPK: Kurang (<2.5), Cukup [2.5-3.0), Baik [3.0-3.5), Sangat Baik [3.5-4.0]
df <- df %>%
  mutate(
    Kategori_IPK = cut(IPK,
                       breaks = c(-Inf, 2.5, 3.0, 3.5, 4.1),
                       labels = c("Kurang", "Cukup", "Baik", "Sangat Baik"),
                       right = FALSE),
    # JamBelajar dikategorikan per minggu:
    # Kurang: 0-7; Cukup: 7-14; Rajin: 14-28; Sangat Rajin: >28
    Kategori_Jam = cut(JamBelajar,
                       breaks = c(-Inf, 7, 14, 28, Inf),
                       labels = c("Kurang", "Cukup", "Rajin", "Sangat Rajin"),
                       right = FALSE)
  )

# Pastikan faktor tersusun sesuai urutan yang diinginkan
df$Kategori_IPK <- factor(df$Kategori_IPK, levels = c("Kurang","Cukup","Baik","Sangat Baik"))
df$Kategori_Jam <- factor(df$Kategori_Jam, levels = c("Kurang","Cukup","Rajin","Sangat Rajin"))

# ---------------------------
# 5) Tabel frekuensi & crosstab
# ---------------------------
freq_ipk <- df %>% count(Kategori_IPK) %>% arrange(Kategori_IPK)
freq_jam <- df %>% count(Kategori_Jam) %>% arrange(Kategori_Jam)
crosstab <- table(df$Kategori_IPK, df$Kategori_Jam)

prop_ipk <- prop.table(table(df$Kategori_IPK)) * 100
prop_jam <- prop.table(table(df$Kategori_Jam)) * 100
prop_crosstab_by_ipk <- prop.table(crosstab, margin = 1) * 100  # persentase baris

# Print ringkasan
cat("\nFrekuensi Kategori IPK:\n"); print(freq_ipk)
cat("\nFrekuensi Kategori Jam Belajar:\n"); print(freq_jam)
cat("\nCrosstab (IPK x JamBelajar):\n"); print(crosstab)
cat("\nPersentase per Kategori IPK (%):\n"); print(round(prop_ipk,2))
cat("\nPersentase per Kategori Jam (%):\n"); print(round(prop_jam,2))
cat("\nPersentase crosstab per baris IPK (%):\n"); print(round(prop_crosstab_by_ipk,2))

# ---------------------------
# 6) Save cleaned data & tables (CSV)
# ---------------------------
out_dir <- "/Users/hazelmahesahandhaka/Downloads"
if(!dir.exists(out_dir)) dir.create(out_dir)

write.csv(df, file = file.path(out_dir, "data_bersih_kel12.csv"), row.names = FALSE)
write.csv(as.data.frame(freq_ipk), file = file.path(out_dir, "freq_ipk_kel12.csv"), row.names = FALSE)
write.csv(as.data.frame(freq_jam), file = file.path(out_dir, "freq_jam_kel12.csv"), row.names = FALSE)
write.csv(as.data.frame.matrix(crosstab), file = file.path(out_dir, "crosstab_ipk_jam_kel12.csv"), row.names = FALSE)


# ---------------------------
# 7) Visualisasi (ggplot2)
# ---------------------------

# Theme dasar untuk poster (besar, minimal)
my_theme <- theme_minimal() +
  theme(
    text = element_text(family = "sans", size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    plot.title = element_text(size = 26, hjust = 0.5),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14)
  )

# Plot 1: Distribusi IPK (bar)
p_ipk <- ggplot(df, aes(x = Kategori_IPK)) +
  geom_bar(fill = "#d78b00", color = "black", width = 0.6) +
  labs(title = "Distribusi Kategori IPK",
       x = "Kategori IPK",
       y = "Frekuensi") +
  my_theme

# Plot 2: Distribusi Jam Belajar (bar)
p_jam <- ggplot(df, aes(x = Kategori_Jam)) +
  geom_bar(fill = "#d78b00", color = "black", width = 0.6) +
  labs(title = "Distribusi Kategori Jam Belajar per Minggu",
       x = "Kategori Jam Belajar",
       y = "Frekuensi") +
  my_theme

# Plot 3: Stacked bar (Hubungan IPK vs JamBelajar)
# Buat data frame ringkas untuk stacked bar
stack_df <- as.data.frame(crosstab) %>%
  rename(Kategori_IPK = Var1, Kategori_Jam = Var2, Frekuensi = Freq)

p_stack <- ggplot(stack_df, aes(x = Kategori_IPK, y = Frekuensi, fill = Kategori_Jam)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Hubungan IPK dan Jam Belajar",
       x = "Kategori IPK",
       y = "Frekuensi",
       fill = "Kategori Jam") +
  my_theme +
  scale_fill_brewer(palette = "Set2")

# Tampilkan di RStudio
print(p_ipk)
print(p_jam)
print(p_stack)

# ---------------------------
# 8) Save plots (resolusi tinggi untuk poster)
# ---------------------------
# Untuk poster A1, kita simpan dalam ukuran besar (misal 5000x3500 pixels, dpi 300)
ggsave(filename = file.path(out_dir, "Distribusi_IPK_kel12.png"),
       plot = p_ipk, width = 16, height = 10, dpi = 300, units = "in")  # 4800x3000 px

ggsave(filename = file.path(out_dir, "Distribusi_JamBelajar_kel12.png"),
       plot = p_jam, width = 16, height = 10, dpi = 300, units = "in")

ggsave(filename = file.path(out_dir, "Stacked_IPK_Jam_kel12.png"),
       plot = p_stack, width = 18, height = 10, dpi = 300, units = "in")

cat("\nSemua grafik dan tabel disimpan di:", out_dir, "\n")

# ---------------------------
# 9) (Optional) Export ringkasan interpretasi ke text
# ---------------------------
summary_txt <- file.path(out_dir, "interpretasi_ringkas_kel12.txt")
sink(summary_txt)
cat("Ringkasan Interpretasi - Kelompok 12\n")
cat("----------------------------------\n\n")
cat("Frekuensi Kategori IPK:\n"); print(freq_ipk); cat("\n")
cat("Frekuensi Kategori Jam Belajar:\n"); print(freq_jam); cat("\n")
cat("Crosstab (IPK x JamBelajar):\n"); print(crosstab); cat("\n\n")
cat("Kesimpulan singkat:\n")
cat("- Mayoritas mahasiswa berada pada kategori IPK 'Baik' dan 'Sangat Baik'.\n")
cat("- Mayoritas mahasiswa termasuk kategori jam belajar 'Kurang' (<=7 jam/minggu).\n")
cat("- Terdapat kecenderungan positif: mahasiswa dengan jam belajar lebih tinggi cenderung memiliki IPK yang lebih tinggi.\n")
sink()
cat("Interpretasi ringkas juga disimpan di:", summary_txt, "\n")
