<!-- Hero Section -->
<section class="hero bg-primary text-white py-5" id="particles-js">
    <div class="container text-center py-5">
        <h1 class="display-3 fw-bold" data-aos="fade-up">Digital Agency Profesional</h1>
        <p class="lead mb-4" data-aos="fade-up" data-aos-delay="100">Solusi Digital Terpadu untuk Bisnis Anda</p>
        <a href="<?= url('contact') ?>" class="btn btn-light btn-lg" data-aos="fade-up" data-aos-delay="200">
            Konsultasi Gratis
        </a>
    </div>
</section>

<!-- Stats Section -->
<section class="stats py-5">
    <div class="container">
        <div class="row text-center">
            <div class="col-md-3" data-aos="fade-up">
                <h2 class="display-4 text-primary"><?= $stats['clients'] ?>+</h2>
                <p>Happy Clients</p>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                <h2 class="display-4 text-primary"><?= $stats['projects'] ?>+</h2>
                <p>Projects Done</p>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                <h2 class="display-4 text-primary"><?= $stats['partners'] ?>+</h2>
                <p>Partners</p>
            </div>
            <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                <h2 class="display-4 text-primary"><?= $stats['services'] ?>+</h2>
                <p>Services</p>
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section class="services py-5 bg-light">
    <div class="container">
        <h2 class="text-center mb-5">Our Services</h2>
        <div class="row g-4">
            <?php
            $services = [
                ['icon' => 'bi-code-slash', 'title' => 'Website Development', 'desc' => 'Custom website profesional'],
                ['icon' => 'bi-graph-up', 'title' => 'SEO & Marketing', 'desc' => 'Optimasi mesin pencari'],
                ['icon' => 'bi-palette', 'title' => 'Graphic Design', 'desc' => 'Desain visual menarik'],
                ['icon' => 'bi-megaphone', 'title' => 'Digital Ads', 'desc' => 'Iklan digital efektif']
            ];
            foreach ($services as $i => $service):
            ?>
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="<?= $i * 100 ?>">
                <div class="card service-card h-100 text-center p-4">
                    <i class="bi <?= $service['icon'] ?> display-4 text-primary mb-3"></i>
                    <h5><?= $service['title'] ?></h5>
                    <p><?= $service['desc'] ?></p>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta py-5 bg-primary text-white">
    <div class="container text-center">
        <h2 class="mb-4">Ready to Start Your Project?</h2>
        <a href="<?= url('contact') ?>" class="btn btn-light btn-lg">Get Started</a>
    </div>
</section>
