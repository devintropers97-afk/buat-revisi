<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Rate Limiting Middleware
 */

class RateLimitMiddleware {
    private $maxAttempts = 60;
    private $decayMinutes = 1;
    
    public function handle($maxAttempts = null, $decayMinutes = null) {
        if ($maxAttempts) $this->maxAttempts = $maxAttempts;
        if ($decayMinutes) $this->decayMinutes = $decayMinutes;
        
        $key = $this->resolveRequestSignature();
        $attempts = $this->getAttempts($key);
        
        if ($attempts >= $this->maxAttempts) {
            http_response_code(429);
            die('Too many requests. Please try again later.');
        }
        
        $this->incrementAttempts($key);
    }
    
    private function resolveRequestSignature() {
        return md5($_SERVER['REQUEST_URI'] . '|' . $_SERVER['REMOTE_ADDR']);
    }
    
    private function getAttempts($key) {
        return (int)($_SESSION['rate_limit'][$key]['attempts'] ?? 0);
    }
    
    private function incrementAttempts($key) {
        if (!isset($_SESSION['rate_limit'][$key])) {
            $_SESSION['rate_limit'][$key] = [
                'attempts' => 0,
                'reset_at' => time() + ($this->decayMinutes * 60)
            ];
        }
        
        if (time() > $_SESSION['rate_limit'][$key]['reset_at']) {
            $_SESSION['rate_limit'][$key] = [
                'attempts' => 1,
                'reset_at' => time() + ($this->decayMinutes * 60)
            ];
        } else {
            $_SESSION['rate_limit'][$key]['attempts']++;
        }
    }
}
