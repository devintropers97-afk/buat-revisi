<footer class="footer bg-dark text-white py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5>SITUNEO Digital</h5>
                <p>Digital agency profesional untuk solusi bisnis Anda</p>
                <div class="social-links">
                    <a href="<?= SOCIAL_FACEBOOK ?>" target="_blank"><i class="bi bi-facebook"></i></a>
                    <a href="<?= SOCIAL_INSTAGRAM ?>" target="_blank"><i class="bi bi-instagram"></i></a>
                    <a href="<?= SOCIAL_LINKEDIN ?>" target="_blank"><i class="bi bi-linkedin"></i></a>
                    <a href="<?= SOCIAL_YOUTUBE ?>" target="_blank"><i class="bi bi-youtube"></i></a>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <h5>Services</h5>
                <ul class="list-unstyled">
                    <li><a href="<?= url('services/website') ?>">Website Development</a></li>
                    <li><a href="<?= url('services/seo') ?>">SEO & Marketing</a></li>
                    <li><a href="<?= url('services/social') ?>">Social Media</a></li>
                    <li><a href="<?= url('services/design') ?>">Graphic Design</a></li>
                </ul>
            </div>
            
            <div class="col-md-4 mb-4">
                <h5>Contact</h5>
                <p><i class="bi bi-geo-alt"></i> <?= COMPANY_ADDRESS ?></p>
                <p><i class="bi bi-phone"></i> <?= COMPANY_PHONE ?></p>
                <p><i class="bi bi-envelope"></i> <?= COMPANY_EMAIL ?></p>
            </div>
        </div>
        
        <hr class="my-4">
        
        <div class="row">
            <div class="col-md-6">
                <p class="mb-0">&copy; 2025 SITUNEO Digital. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-md-end">
                <a href="<?= url('terms') ?>" class="text-white me-3">Terms</a>
                <a href="<?= url('privacy') ?>" class="text-white">Privacy</a>
            </div>
        </div>
    </div>
</footer>
