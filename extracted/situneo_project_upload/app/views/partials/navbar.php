<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <span class="navbar-brand">SITUNEO Dashboard</span>
        
        <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                    <?= e(auth()['full_name']) ?>
                </a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="<?= url(auth_role() . '/profile') ?>">Profile</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="<?= url('auth/logout') ?>">Logout</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>
