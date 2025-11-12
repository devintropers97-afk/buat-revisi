<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $title ?? 'SITUNEO Digital' ?></title>
    <meta name="description" content="<?= $description ?? SEO_DEFAULT_DESCRIPTION ?>">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<?= asset('css/main.css') ?>">
    <link rel="stylesheet" href="<?= asset('css/animations.css') ?>">
    <link rel="stylesheet" href="<?= asset('css/responsive.css') ?>">
    
    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
</head>
<body>
    <!-- Preloader -->
    <div id="preloader">
        <div class="spinner"></div>
    </div>
    
    <!-- Header -->
    <?php include VIEWS_PATH . '/partials/header.php'; ?>
    
    <!-- Main Content -->
    <main>
        <?= $content ?? '' ?>
    </main>
    
    <!-- Footer -->
    <?php include VIEWS_PATH . '/partials/footer.php'; ?>
    
    <!-- WhatsApp Float -->
    <a href="https://wa.me/<?= COMPANY_WHATSAPP ?>?text=Halo%20SITUNEO" class="whatsapp-float" target="_blank">
        <i class="bi bi-whatsapp"></i>
    </a>
    
    <!-- Back to Top -->
    <button id="back-to-top" class="back-to-top">
        <i class="bi bi-arrow-up"></i>
    </button>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- AOS -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <!-- Custom JS -->
    <script src="<?= asset('js/main.js') ?>"></script>
    <script src="<?= asset('js/animations.js') ?>"></script>
    <script src="<?= asset('js/validation.js') ?>"></script>
    <script src="<?= asset('js/smooth-scroll.js') ?>"></script>
    
    <script>
        AOS.init({ duration: 800, once: true });
    </script>
</body>
</html>
