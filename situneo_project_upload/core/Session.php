<?php
class Session {
    public function __construct() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }
    
    public function set($key, $value) {
        $_SESSION[$key] = $value;
    }
    
    public function get($key, $default = null) {
        return $_SESSION[$key] ?? $default;
    }
    
    public function has($key) {
        return isset($_SESSION[$key]);
    }
    
    public function remove($key) {
        unset($_SESSION[$key]);
    }
    
    public function destroy() {
        session_destroy();
    }
    
    public function flash($key, $value = null) {
        if ($value === null) {
            $flash = $this->get('flash_' . $key);
            $this->remove('flash_' . $key);
            return $flash;
        }
        $this->set('flash_' . $key, $value);
    }
}
