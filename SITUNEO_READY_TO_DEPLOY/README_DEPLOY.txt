========================================================
SITUNEO DIGITAL PLATFORM - READY TO DEPLOY
========================================================
Version: 2.0 FIXED
Date: 12 November 2025
Status: SIAP UPLOAD KE CPANEL

========================================================
ISI PACKAGE INI:
========================================================

1_DATABASE/
   ├── situneo_database_FIXED.sql  → Database yang sudah diperbaiki (130 tabel)
   ├── VERIFIKASI_QUICK.sql        → Query untuk cek database berhasil
   └── CARA_IMPORT_DATABASE.txt    → Instruksi import database

2_PROJECT_FILES/
   └── (Semua file project PHP)    → Upload ke public_html atau folder domain

README_DEPLOY.txt                  → File ini


========================================================
CARA DEPLOY KE CPANEL (STEP BY STEP)
========================================================

╔═══════════════════════════════════════════════════════╗
║  STEP 1: UPLOAD & IMPORT DATABASE                     ║
╚═══════════════════════════════════════════════════════╝

1. Login ke cPanel (https://situneo.my.id/cpanel)

2. Buka "phpMyAdmin"

3. Di sidebar kiri, klik database: nrrskfvk_situneo_digital
   (Jika belum ada, buat dulu di "MySQL Databases")

4. Klik tab "Import"

5. Klik "Choose File" → Pilih file:
   1_DATABASE/situneo_database_FIXED.sql

6. Setting import:
   ✓ Format: SQL
   ✓ Character set: utf8mb4
   ✓ Biarkan setting lain default

7. Klik tombol "Go" atau "Import"

8. TUNGGU sampai selesai (bisa 1-2 menit)

9. VERIFIKASI:
   - Cek tab "Structure" → Harus ada 130 tabel
   - Jika ada 130 tabel → SUKSES ✓


╔═══════════════════════════════════════════════════════╗
║  STEP 2: UPLOAD PROJECT FILES                         ║
╚═══════════════════════════════════════════════════════╝

1. Di cPanel, buka "File Manager"

2. Navigate ke folder domain Anda:
   - Jika domain utama: masuk ke "public_html"
   - Jika subdomain/addon: masuk ke folder domain tersebut

3. HAPUS semua file lama jika ada (backup dulu jika perlu)

4. Upload semua isi dari folder: 2_PROJECT_FILES/

   Cara upload:
   a. Klik tombol "Upload" di File Manager
   b. Drag & drop SEMUA file/folder dari 2_PROJECT_FILES/
   c. Tunggu sampai upload selesai

   ATAU gunakan FTP/SFTP (lebih cepat untuk banyak file)

5. Setelah upload, struktur folder harus seperti ini:

   public_html/ (atau folder domain Anda)
   ├── app/
   ├── config/
   ├── core/
   ├── database/
   ├── helpers/
   ├── public/
   │   ├── assets/
   │   ├── index.php
   │   └── .htaccess
   └── (file-file lain)


╔═══════════════════════════════════════════════════════╗
║  STEP 3: SET FOLDER PERMISSIONS                       ║
╚═══════════════════════════════════════════════════════╝

Di File Manager, klik kanan folder berikut → "Change Permissions":

1. Folder "storage/" → Set ke 755
   (Jika belum ada, buat foldernya dulu)

2. Folder "logs/" → Set ke 755
   (Jika belum ada, buat foldernya dulu)

3. Folder "public/assets/uploads/" → Set ke 755

Cara set permissions:
- Klik kanan folder → "Change Permissions"
- Centang: Read, Write, Execute untuk Owner
- Centang: Read, Execute untuk Group & Public
- Atau langsung ketik: 755


╔═══════════════════════════════════════════════════════╗
║  STEP 4: UBAH DOCUMENT ROOT (PENTING!)                ║
╚═══════════════════════════════════════════════════════╝

Agar website berjalan dengan benar, document root harus diarahkan
ke folder "public/"

Cara di cPanel:

1. Buka "Domains" atau "Addon Domains"

2. Cari domain "situneo.my.id"

3. Klik "Manage" atau ikon pengaturan

4. Ubah "Document Root" dari:
   /public_html

   Menjadi:
   /public_html/public

   ATAU jika struktur berbeda sesuaikan, yang penting
   document root mengarah ke folder "public/"

5. Save perubahan


╔═══════════════════════════════════════════════════════╗
║  STEP 5: CEK KONFIGURASI DATABASE                     ║
╚═══════════════════════════════════════════════════════╝

1. Di File Manager, buka file:
   config/database.php

2. Pastikan credentials benar:

   DB_HOST = 'localhost'
   DB_NAME = 'nrrskfvk_situneo_digital'
   DB_USER = 'nrrskfvk_user_situneo_digital'
   DB_PASS = 'Devin1922$'

3. Jika berbeda, edit sesuai database Anda


╔═══════════════════════════════════════════════════════╗
║  STEP 6: TEST WEBSITE                                 ║
╚═══════════════════════════════════════════════════════╝

1. Buka browser, akses: https://situneo.my.id

2. JIKA MUNCUL WEBSITE → SUKSES! ✓

3. JIKA ERROR 500:

   a. Edit file: config/app.php
   b. Ubah: define('APP_DEBUG', false);
      Jadi: define('APP_DEBUG', true);
   c. Refresh website
   d. Lihat error message yang muncul
   e. Catat errornya dan perbaiki
   f. Setelah fix, ubah kembali ke false

4. JIKA MUNCUL 404 atau "Page not found":
   - Cek document root sudah benar ke folder "public/"
   - Cek file .htaccess ada di folder public/


╔═══════════════════════════════════════════════════════╗
║  STEP 7: VERIFIKASI DATABASE                          ║
╚═══════════════════════════════════════════════════════╝

1. Buka phpMyAdmin

2. Pilih database: nrrskfvk_situneo_digital

3. Klik tab "SQL"

4. Copy & paste query dari file:
   1_DATABASE/VERIFIKASI_QUICK.sql

5. Klik "Go"

6. Cek hasil:
   ✓ Total tables: 130
   ✓ Semua tabel kunci exists
   ✓ Sample data ada


========================================================
TROUBLESHOOTING
========================================================

❌ ERROR: "Database connection failed"
   → Cek credentials di config/database.php
   → Pastikan database user punya akses ke database

❌ ERROR: "Table doesn't exist"
   → Cek phpMyAdmin, pastikan 130 tabel ada
   → Jika tidak, import ulang SQL file

❌ ERROR 500 terus muncul
   → Set APP_DEBUG = true di config/app.php
   → Lihat error spesifik yang muncul
   → Cek folder logs/ untuk error log

❌ Website tidak muncul, blank page
   → Cek document root sudah ke folder public/
   → Cek file index.php ada di folder public/

❌ CSS/JS tidak load
   → Cek folder public/assets/ sudah ada
   → Cek permissions folder assets/ (755)

❌ Upload gambar error
   → Cek folder public/assets/uploads/ ada
   → Cek permissions 755 (writeable)


========================================================
CHECKLIST SEBELUM PRODUCTION
========================================================

□ Database imported (130 tabel)
□ Project files uploaded
□ Document root diubah ke /public/
□ Folder permissions diset (storage, logs, uploads)
□ Database credentials benar
□ Website bisa diakses tanpa error
□ APP_DEBUG = false (production mode)
□ SSL certificate aktif (https)
□ Test semua fitur utama
□ Backup database & files


========================================================
INFORMASI DATABASE
========================================================

Database Name: nrrskfvk_situneo_digital
Username:      nrrskfvk_user_situneo_digital
Password:      Devin1922$
Host:          localhost
Total Tables:  130
Charset:       utf8mb4
Collation:     utf8mb4_unicode_ci


========================================================
INFORMASI APLIKASI
========================================================

App Name:      SITUNEO Digital
App URL:       https://situneo.my.id
Environment:   Production
PHP Version:   >= 7.4 (recommended 8.0+)
Framework:     Custom MVC PHP


========================================================
KONTAK & SUPPORT
========================================================

Jika ada masalah saat deployment:

1. Cek file logs/ untuk error details
2. Enable APP_DEBUG untuk lihat error
3. Verifikasi semua step sudah diikuti
4. Cek dokumentasi di PANDUAN_PERBAIKAN.md


========================================================
SELAMAT! WEBSITE ANDA SIAP ONLINE! 🎉
========================================================

Setelah semua step selesai, website Anda sudah bisa diakses
di https://situneo.my.id

Jangan lupa:
✓ Backup database & files secara berkala
✓ Update password default
✓ Set APP_DEBUG = false untuk production
✓ Monitor logs untuk error

Good luck! 🚀
