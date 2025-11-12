<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Our Services</h1>
        <p class="lead">Complete Digital Solutions</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <?php
            $services = [
                'Website Development' => 'Professional website development',
                'SEO & Marketing' => 'Search engine optimization',
                'Social Media' => 'Social media management',
                'Graphic Design' => 'Creative design services',
                'Content Writing' => 'Professional content creation',
                'Video Production' => 'Video creation and editing',
                'Branding' => 'Brand identity strategy',
                'Digital Advertising' => 'Google & Facebook Ads'
            ];
            foreach ($services as $name => $desc):
            ?>
            <div class="col-md-6 col-lg-4" data-aos="fade-up">
                <div class="card service-card h-100 p-4">
                    <h5><?= $name ?></h5>
                    <p><?= $desc ?></p>
                    <a href="<?= url('services/' . str_slug($name)) ?>" class="btn btn-outline-primary">Learn More</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>
