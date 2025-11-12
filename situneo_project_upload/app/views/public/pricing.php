<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Pricing Plans</h1>
        <p class="lead">Choose the perfect plan for your business</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <?php
            $plans = [
                ['name' => 'Starter', 'price' => '5.000.000', 'features' => ['5 Pages', 'Basic SEO', '1 Month Support']],
                ['name' => 'Business', 'price' => '15.000.000', 'features' => ['15 Pages', 'Advanced SEO', '6 Months Support']],
                ['name' => 'Premium', 'price' => '50.000.000', 'features' => ['Unlimited', 'Full SEO', '12 Months Support']]
            ];
            foreach ($plans as $plan):
            ?>
            <div class="col-md-4" data-aos="fade-up">
                <div class="card pricing-card text-center p-4">
                    <h4><?= $plan['name'] ?></h4>
                    <h2 class="text-primary"><?= rupiah($plan['price']) ?></h2>
                    <ul class="list-unstyled my-4">
                        <?php foreach ($plan['features'] as $feature): ?>
                        <li><i class="bi bi-check text-success"></i> <?= $feature ?></li>
                        <?php endforeach; ?>
                    </ul>
                    <a href="<?= url('contact') ?>" class="btn btn-primary">Get Started</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>
