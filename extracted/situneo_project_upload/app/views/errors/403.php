<!DOCTYPE html>
<html>
<head>
    <title>403 - Access Denied</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .error-card {
            background: white;
            border-radius: 15px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="error-card">
                    <i class="bi bi-shield-x text-danger" style="font-size: 80px;"></i>
                    <h1 class="display-1 text-danger">403</h1>
                    <h2>Akses Ditolak</h2>
                    <p class="text-muted">Maaf, Anda tidak memiliki izin untuk mengakses halaman ini.</p>
                    <div class="mt-4">
                        <a href="<?= url('') ?>" class="btn btn-primary me-2">
                            <i class="bi bi-house"></i> Beranda
                        </a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Kembali
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
