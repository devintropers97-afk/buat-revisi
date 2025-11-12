<?php
class Auth {
    public static function check() {
        return isset($_SESSION['user_id']);
    }
    
    public static function id() {
        return $_SESSION['user_id'] ?? null;
    }
    
    public static function user() {
        return $_SESSION['user'] ?? null;
    }
    
    public static function role() {
        return $_SESSION['user']['role'] ?? null;
    }
    
    public static function hasRole($role) {
        return self::role() === $role;
    }
    
    public static function login($user) {
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user'] = $user;
        $_SESSION['logged_in_at'] = time();
    }
    
    public static function logout() {
        session_destroy();
    }
}
