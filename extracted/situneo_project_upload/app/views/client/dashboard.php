<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($title ?? 'Client Dashboard') ?> - <?= SITE_NAME ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="<?= url('client') ?>"><?= SITE_NAME ?></a>
                        <div class="ms-auto text-white">
                            <i class="bi bi-person-circle"></i> <?= e($user['name'] ?? 'Client') ?>
                            <a href="<?= url('auth/logout') ?>" class="btn btn-sm btn-outline-light ms-2">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container py-4">
                    <h2>Dashboard Client</h2>
                    <div class="row mt-4">
                        <div class="col-md-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="bi bi-folder-fill text-primary" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Projects</h5>
                                    <p class="text-muted">Manage your projects</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="bi bi-file-text text-success" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Invoices</h5>
                                    <p class="text-muted">View invoices</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="bi bi-chat-dots text-info" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Messages</h5>
                                    <p class="text-muted">Communication</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="bi bi-gear text-warning" style="font-size: 2rem;"></i>
                                    <h5 class="mt-2">Settings</h5>
                                    <p class="text-muted">Account settings</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
