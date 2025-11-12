<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * CSRF Protection Middleware
 */

class CSRFMiddleware {
    public function handle() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $token = $_POST[CSRF_TOKEN_NAME] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
            
            if (!$token || !CSRF::validate($token)) {
                http_response_code(419);
                die('CSRF token mismatch. Please refresh and try again.');
            }
        }
    }
}
