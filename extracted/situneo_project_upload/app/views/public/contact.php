<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Contact Us</h1>
        <p class="lead">Get in touch with us</p>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-6" data-aos="fade-right">
                <h3>Send us a message</h3>
                <form id="contactForm" method="POST" action="<?= url('contact/submit') ?>">
                    <?= csrf_field() ?>
                    <div class="mb-3">
                        <input type="text" name="name" class="form-control" placeholder="Your Name" required>
                    </div>
                    <div class="mb-3">
                        <input type="email" name="email" class="form-control" placeholder="Your Email" required>
                    </div>
                    <div class="mb-3">
                        <textarea name="message" class="form-control" rows="5" placeholder="Your Message" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Send Message</button>
                </form>
            </div>

            <div class="col-md-6" data-aos="fade-left">
                <h3>Contact Information</h3>
                <p><i class="bi bi-geo-alt"></i> <?= COMPANY_ADDRESS ?></p>
                <p><i class="bi bi-phone"></i> <?= COMPANY_PHONE ?></p>
                <p><i class="bi bi-envelope"></i> <?= COMPANY_EMAIL ?></p>
                <p><i class="bi bi-whatsapp"></i> <?= COMPANY_WHATSAPP ?></p>
            </div>
        </div>
    </div>
</section>
