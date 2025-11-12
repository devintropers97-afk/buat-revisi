-- =====================================================
-- QUICK VERIFICATION QUERIES
-- Jalankan query ini setelah import SQL untuk memverifikasi
-- =====================================================

-- 1. Cek jumlah total tabel (harus 130)
SELECT COUNT(*) as total_tables, 'Expected: 130' as expected
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital';

-- 2. Cek tabel-tabel kunci ada atau tidak
SELECT 'users' as table_name,
       IF(COUNT(*) > 0, '✓ EXISTS', '✗ MISSING') as status
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital' AND table_name = 'users'

UNION ALL

SELECT 'clients' as table_name,
       IF(COUNT(*) > 0, '✓ EXISTS', '✗ MISSING') as status
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital' AND table_name = 'clients'

UNION ALL

SELECT 'partners' as table_name,
       IF(COUNT(*) > 0, '✓ EXISTS', '✗ MISSING') as status
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital' AND table_name = 'partners'

UNION ALL

SELECT 'orders' as table_name,
       IF(COUNT(*) > 0, '✓ EXISTS', '✗ MISSING') as status
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital' AND table_name = 'orders'

UNION ALL

SELECT 'services' as table_name,
       IF(COUNT(*) > 0, '✓ EXISTS', '✗ MISSING') as status
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital' AND table_name = 'services';

-- 3. List semua tabel yang ada
SELECT table_name,
       ROUND((data_length + index_length) / 1024, 2) as size_kb
FROM information_schema.tables
WHERE table_schema = 'nrrskfvk_situneo_digital'
ORDER BY table_name;

-- 4. Cek foreign key constraints (harus ada banyak)
SELECT COUNT(*) as total_foreign_keys, 'Should be > 50' as note
FROM information_schema.table_constraints
WHERE constraint_schema = 'nrrskfvk_situneo_digital'
  AND constraint_type = 'FOREIGN KEY';

-- 5. Cek data sample sudah ada
SELECT 'partner_tiers' as table_name, COUNT(*) as row_count
FROM partner_tiers

UNION ALL

SELECT 'payment_methods_config' as table_name, COUNT(*) as row_count
FROM payment_methods_config

UNION ALL

SELECT 'service_categories' as table_name, COUNT(*) as row_count
FROM service_categories;
