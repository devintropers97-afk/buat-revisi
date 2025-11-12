<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - <?= SITE_NAME ?></title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<?= asset('css/main.css') ?>">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 30px 0;
        }
        .register-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="register-card">
                    <div class="register-header">
                        <h3><i class="bi bi-person-plus"></i> Registrasi</h3>
                        <p class="mb-0">Buat akun baru untuk memulai</p>
                    </div>

                    <div class="p-4">
                        <?php if (isset($error)): ?>
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle"></i> <?= e($error) ?>
                            </div>
                        <?php endif; ?>

                        <form action="<?= url('auth/register') ?>" method="POST">
                            <?= csrf_field() ?>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Nama Lengkap</label>
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="John Doe" required value="<?= old('name') ?>">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           placeholder="nama@email.com" required value="<?= old('email') ?>">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">No. Telepon</label>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           placeholder="08123456789" required value="<?= old('phone') ?>">
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="company" class="form-label">Perusahaan (Opsional)</label>
                                    <input type="text" class="form-control" id="company" name="company"
                                           placeholder="PT. Example" value="<?= old('company') ?>">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Minimal 8 karakter" required>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="password_confirm" class="form-label">Konfirmasi Password</label>
                                    <input type="password" class="form-control" id="password_confirm" name="password_confirm"
                                           placeholder="Ulangi password" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="role" class="form-label">Daftar Sebagai</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">Pilih Role</option>
                                    <option value="client" <?= old('role') == 'client' ? 'selected' : '' ?>>Client</option>
                                    <option value="partner" <?= old('role') == 'partner' ? 'selected' : '' ?>>Partner</option>
                                </select>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="agree" name="agree" required>
                                <label class="form-check-label" for="agree">
                                    Saya setuju dengan <a href="<?= url('page/terms') ?>" target="_blank">Syarat & Ketentuan</a>
                                </label>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mb-3">
                                <i class="bi bi-person-check"></i> Daftar Sekarang
                            </button>

                            <div class="text-center">
                                <p class="mb-0">Sudah punya akun?
                                    <a href="<?= url('auth/login') ?>">Login di sini</a>
                                </p>
                                <a href="<?= url('') ?>" class="text-muted small">
                                    <i class="bi bi-arrow-left"></i> Kembali ke beranda
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
