<div class="sidebar bg-dark text-white vh-100 p-3">
    <div class="sidebar-brand mb-4">
        <h4>SITUNEO</h4>
    </div>
    
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link text-white" href="<?= url(auth_role()) ?>">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white" href="<?= url(auth_role() . '/profile') ?>">
                <i class="bi bi-person"></i> Profile
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white" href="<?= url('auth/logout') ?>">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </li>
    </ul>
</div>
