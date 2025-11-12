<header class="header">
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="<?= url('') ?>">
                <img src="<?= asset('images/logo.png') ?>" alt="SITUNEO" height="40">
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="<?= url('') ?>">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('about') ?>">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('services') ?>">Services</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('portfolio') ?>">Portfolio</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('pricing') ?>">Pricing</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('blog') ?>">Blog</a></li>
                    <li class="nav-item"><a class="nav-link" href="<?= url('contact') ?>">Contact</a></li>
                    
                    <?php if (is_logged_in()): ?>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                <?= e(auth()['full_name']) ?>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="<?= url(auth_role()) ?>">Dashboard</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<?= url('auth/logout') ?>">Logout</a></li>
                            </ul>
                        </li>
                    <?php else: ?>
                        <li class="nav-item"><a class="nav-link btn btn-outline-primary" href="<?= url('auth/login') ?>">Login</a></li>
                    <?php endif; ?>
                </ul>
            </div>
        </div>
    </nav>
</header>
