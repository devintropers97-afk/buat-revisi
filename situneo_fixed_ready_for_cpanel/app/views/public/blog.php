<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Blog</h1>
        <p class="lead">Latest news and updates</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <?php for ($i = 1; $i <= 6; $i++): ?>
            <div class="col-md-6 col-lg-4" data-aos="fade-up">
                <div class="card blog-card">
                    <img src="<?= asset('images/blog-' . $i . '.jpg') ?>" class="card-img-top" alt="Blog">
                    <div class="card-body">
                        <h5>Blog Post <?= $i ?></h5>
                        <p class="text-muted"><?= format_date(today()) ?></p>
                        <p>Lorem ipsum dolor sit amet...</p>
                        <a href="<?= url('blog/post-' . $i) ?>" class="btn btn-sm btn-primary">Read More</a>
                    </div>
                </div>
            </div>
            <?php endfor; ?>
        </div>
    </div>
</section>
