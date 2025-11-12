<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Our Portfolio</h1>
        <p class="lead">Showcase of our best work</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <?php for ($i = 1; $i <= 9; $i++): ?>
            <div class="col-md-6 col-lg-4" data-aos="fade-up">
                <div class="card portfolio-card">
                    <img src="<?= asset('images/portfolio-' . $i . '.jpg') ?>" class="card-img-top" alt="Portfolio">
                    <div class="card-body">
                        <h5>Project <?= $i ?></h5>
                        <a href="<?= url('portfolio/' . $i) ?>" class="btn btn-sm btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            <?php endfor; ?>
        </div>
    </div>
</section>
