<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Career</h1>
        <p class="lead">Join our amazing team</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <h3 class="mb-4">Open Positions</h3>
        <div class="row g-4">
            <?php
            $positions = [
                ['title' => 'Web Developer', 'type' => 'Full Time'],
                ['title' => 'Graphic Designer', 'type' => 'Full Time'],
                ['title' => 'Digital Marketing', 'type' => 'Part Time']
            ];
            foreach ($positions as $pos):
            ?>
            <div class="col-md-6" data-aos="fade-up">
                <div class="card p-4">
                    <h5><?= $pos['title'] ?></h5>
                    <p class="text-muted"><?= $pos['type'] ?></p>
                    <a href="<?= url('contact') ?>" class="btn btn-primary">Apply Now</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>
