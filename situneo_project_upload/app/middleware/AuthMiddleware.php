<?php
class AuthMiddleware {
    public function handle() {
        if (!Auth::check()) redirect('auth/login');
    }
}
