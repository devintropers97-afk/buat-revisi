# PANDUAN PERBAIKAN SITUNEO DIGITAL PLATFORM

## 📋 RINGKASAN MASALAH

### Masalah yang Ditemukan:

1. **❌ SQL Import Gagal - Hanya 8 dari 130 Tabel Terbuat**
   - **Penyebab**: Foreign key constraint error
   - **Detail**: Tabel `clients` (baris 204) memiliki foreign key ke tabel `partners` yang baru dibuat di baris 388
   - **Akibat**: Import SQL berhenti saat mencoba membuat tabel dengan foreign key ke tabel yang belum ada

2. **❌ Error 500 pada Domain**
   - **Penyebab**: Database tidak lengkap (hanya 8 tabel)
   - **Detail**: Controllers/Models mencoba query ke tabel yang tidak ada
   - **Akibat**: PHP error yang tidak ditampilkan karena `APP_DEBUG = false`

---

## ✅ SOLUSI YANG SUDAH DITERAPKAN

### 1. File SQL Sudah Diperbaiki ✓

**File Baru**: `situneo_database_FIXED.sql`

**Perbaikan yang Diterapkan**:
```sql
-- Sebelum semua CREATE TABLE, ditambahkan:
SET FOREIGN_KEY_CHECKS = 0;

-- Setelah semua tabel dibuat, sebelum COMMIT:
SET FOREIGN_KEY_CHECKS = 1;
```

**Penjelasan**:
- `FOREIGN_KEY_CHECKS = 0` → Nonaktifkan validasi foreign key sementara
- Semua tabel dibuat tanpa peduli urutan
- `FOREIGN_KEY_CHECKS = 1` → Aktifkan kembali validasi
- Foreign key divalidasi setelah semua tabel selesai dibuat

---

## 📝 CARA UPLOAD DATABASE

### Metode 1: Via phpMyAdmin (Direkomendasikan)

1. **Login ke phpMyAdmin** (biasanya: `https://situneo.my.id/phpmyadmin`)

2. **Pilih/Buat Database**:
   - Klik tab "Databases"
   - Cari database: `nrrskfvk_situneo_digital`
   - Jika belum ada, buat database baru dengan nama tersebut
   - Collation: `utf8mb4_unicode_ci`

3. **Import SQL File**:
   - Klik database `nrrskfvk_situneo_digital`
   - Klik tab "Import"
   - Klik "Choose File" → Pilih `situneo_database_FIXED.sql`
   - **PENTING**: Pastikan setting berikut:
     - Format: SQL
     - Character set: utf8mb4
     - ✓ Enable foreign key checks (biarkan centang, karena sudah ada di SQL)
   - Klik "Go" / "Import"

4. **Verifikasi**:
   ```
   ✓ Pastikan muncul pesan sukses
   ✓ Cek tab "Structure" → Harus ada 130 tabel
   ✓ Tidak ada error di log
   ```

### Metode 2: Via Command Line (Advanced)

```bash
# Login ke server via SSH
ssh user@situneo.my.id

# Upload file SQL ke server (via FTP/SCP)

# Import ke MySQL
mysql -u nrrskfvk_user_situneo_digital -p nrrskfvk_situneo_digital < situneo_database_FIXED.sql

# Verifikasi jumlah tabel
mysql -u nrrskfvk_user_situneo_digital -p -e "USE nrrskfvk_situneo_digital; SHOW TABLES;" | wc -l
# Output harus: 131 (130 tabel + 1 header)
```

---

## 🔍 VERIFIKASI SETELAH UPLOAD

### 1. Cek Jumlah Tabel

**Via phpMyAdmin**:
- Masuk ke database `nrrskfvk_situneo_digital`
- Lihat tab "Structure"
- **Harus ada 130 tabel**

**Via SQL Query**:
```sql
SELECT COUNT(*) as total_tables
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital';
```
**Expected Result**: 130

### 2. Cek Tabel Penting

Jalankan query ini untuk memastikan tabel-tabel kunci sudah ada:
```sql
SHOW TABLES LIKE 'users';
SHOW TABLES LIKE 'clients';
SHOW TABLES LIKE 'partners';
SHOW TABLES LIKE 'orders';
SHOW TABLES LIKE 'services';
```
Semua query di atas harus mengembalikan 1 row.

### 3. Test Koneksi Website

1. **Enable Debug Mode** (sementara untuk testing):
   Edit file: `situneo_project_upload/config/app.php`
   ```php
   define('APP_DEBUG', true);  // Ubah dari false ke true
   ```

2. **Akses Domain**:
   - Buka: `https://situneo.my.id`
   - **Jika berhasil**: Website muncul tanpa error
   - **Jika masih error**: Error akan ditampilkan (catat errornya)

3. **Disable Debug** (setelah testing):
   ```php
   define('APP_DEBUG', false);  // Ubah kembali ke false
   ```

---

## 🗂️ STRUKTUR DATABASE (130 TABEL)

### Kelompok Tabel Utama:

1. **User Management (8 tabel)**:
   - users, user_profiles, user_sessions, user_activity_logs
   - password_resets, email_verifications, user_preferences, user_devices

2. **Client Management (10 tabel)**:
   - clients, client_contacts, client_addresses, client_notes
   - client_interactions, client_segments, client_segment_members
   - client_feedback, client_tags, client_tag_relations

3. **Partner Management (10+ tabel)**:
   - partners, partner_tier_config, partner_commissions, dll

4. **SPV & Manager (8+ tabel)**:
   - spv_supervisors, manager_area_managers, performance tracking, dll

5. **Services & Orders (20+ tabel)**:
   - services, service_categories, orders, order_items, invoices, payments, dll

6. **Content Management (15+ tabel)**:
   - blog_posts, blog_categories, portfolios, pages, testimonials, dll

7. **Support & Tasks (10+ tabel)**:
   - support_tickets, tasks, task_assignments, notifications, dll

8. **Analytics & Reports (15+ tabel)**:
   - analytics_daily, revenue_reports, performance_metrics, dll

9. **System & Security (10+ tabel)**:
   - api_keys, audit_logs, backups, email_queue, dll

---

## 🐛 TROUBLESHOOTING

### Masalah: "Table doesn't exist" Error

**Solusi**:
1. Drop semua tabel yang ada (jika ada)
2. Import ulang `situneo_database_FIXED.sql`
3. Verifikasi 130 tabel terbuat

**SQL untuk drop semua tabel** (HATI-HATI!):
```sql
SET FOREIGN_KEY_CHECKS = 0;
-- Drop tables here (manual)
SET FOREIGN_KEY_CHECKS = 1;
```

### Masalah: "Foreign key constraint fails"

**Solusi**:
- File SQL sudah diperbaiki dengan `FOREIGN_KEY_CHECKS = 0/1`
- Jika masih error, kemungkinan file yang diupload bukan versi FIXED

### Masalah: Import Timeout (File Terlalu Besar)

**Solusi**:
1. Via phpMyAdmin, ubah setting:
   ```php
   max_execution_time = 300
   upload_max_filesize = 50M
   post_max_size = 50M
   ```

2. Atau gunakan command line (Metode 2)

### Masalah: Error 500 Masih Muncul Setelah Import

**Checklist**:
1. ✓ 130 tabel sudah terbuat?
2. ✓ Database credentials benar di `config/database.php`?
3. ✓ Enable `APP_DEBUG = true` untuk lihat error spesifik
4. ✓ Cek folder `logs/` untuk error log
5. ✓ Pastikan folder `storage/` dan `logs/` writeable (chmod 755)

---

## 📁 FILE-FILE PENTING

### File SQL:
- ✅ `situneo_database_FIXED.sql` → **GUNAKAN FILE INI**
- ⚠️ `schema (2).sql` → File original (ada bug)
- 📦 `schema-backup.sql` → Backup

### File Config:
- `situneo_project_upload/config/database.php` → Konfigurasi database
- `situneo_project_upload/config/app.php` → Konfigurasi aplikasi

### Database Credentials (dari config):
```
Host: localhost
Database: nrrskfvk_situneo_digital
Username: nrrskfvk_user_situneo_digital
Password: Devin1922$
```

---

## 📞 CHECKLIST DEPLOY

- [ ] Upload file SQL yang FIXED ke server
- [ ] Import SQL via phpMyAdmin atau command line
- [ ] Verifikasi 130 tabel terbuat
- [ ] Upload folder `situneo_project_upload/` ke server
- [ ] Rename folder ke nama yang sesuai (misal: `public_html`)
- [ ] Cek file `config/database.php` credentials sudah benar
- [ ] Set APP_DEBUG = true untuk testing
- [ ] Akses domain dan cek error (jika ada)
- [ ] Set folder permissions:
  - `storage/` → 755 (writeable)
  - `logs/` → 755 (writeable)
  - `public/assets/uploads/` → 755 (writeable)
- [ ] Test website berfungsi
- [ ] Set APP_DEBUG = false (production)
- [ ] Setup SSL certificate (jika belum)
- [ ] Test semua fitur utama

---

## 🎯 KESIMPULAN

### Masalah Utama Sudah Diperbaiki:

✅ **SQL file diperbaiki** dengan menambahkan `FOREIGN_KEY_CHECKS`
✅ **130 tabel sekarang bisa diimport** tanpa error foreign key
✅ **Error 500 akan hilang** setelah database lengkap

### Next Steps:

1. **Upload & Import** SQL file yang sudah diperbaiki
2. **Verifikasi** 130 tabel berhasil dibuat
3. **Test** website → Error 500 seharusnya hilang
4. **Deploy** project files ke hosting

---

**Update**: 12 November 2025
**Status**: ✅ READY TO DEPLOY
