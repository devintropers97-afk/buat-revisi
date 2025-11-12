<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Portfolio Detail</h1>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <h2>Project <?= $id ?></h2>
        <img src="<?= asset('images/portfolio-' . $id . '.jpg') ?>" class="img-fluid mb-4" alt="Portfolio">
        <p>Project description and details here...</p>
    </div>
</section>
