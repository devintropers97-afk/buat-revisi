<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Helper Functions (140+ utilities)
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

// ==================== URL & ROUTING ====================

function url($path = '') {
    return BASE_URL . '/' . ltrim($path, '/');
}

function asset($path) {
    return ASSETS_URL . '/' . ltrim($path, '/');
}

function redirect($url) {
    header('Location: ' . url($url));
    exit;
}

function back() {
    header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? url('')));
    exit;
}

// ==================== AUTH & SESSION ====================

function auth() {
    return Auth::user();
}

function auth_id() {
    return Auth::id();
}

function auth_role() {
    return Auth::role();
}

function is_logged_in() {
    return Auth::check();
}

function has_role($role) {
    return Auth::hasRole($role);
}

// ==================== REQUEST ====================

function request($key = null, $default = null) {
    if ($key === null) return $_REQUEST;
    return $_REQUEST[$key] ?? $default;
}

function get($key = null, $default = null) {
    if ($key === null) return $_GET;
    return $_GET[$key] ?? $default;
}

function post($key = null, $default = null) {
    if ($key === null) return $_POST;
    return $_POST[$key] ?? $default;
}

function method() {
    return $_SERVER['REQUEST_METHOD'];
}

function is_post() {
    return method() === 'POST';
}

function is_get() {
    return method() === 'GET';
}

// ==================== SESSION & FLASH ====================

function session($key = null, $value = null) {
    $sess = new Session();
    if ($key === null) return $_SESSION;
    if ($value === null) return $sess->get($key);
    return $sess->set($key, $value);
}

function flash($key, $value = null) {
    $sess = new Session();
    return $sess->flash($key, $value);
}

function old($key, $default = '') {
    return $_SESSION['old'][$key] ?? $default;
}

// ==================== CSRF ====================

function csrf_field() {
    return CSRF::field();
}

function csrf_token() {
    return CSRF::generate();
}

// ==================== STRING HELPERS ====================

function str_limit($string, $limit = 100, $end = '...') {
    if (mb_strlen($string) <= $limit) return $string;
    return mb_substr($string, 0, $limit) . $end;
}

function str_slug($string) {
    $string = preg_replace('/[^a-z0-9]+/i', '-', strtolower($string));
    return trim($string, '-');
}

function str_random($length = 16) {
    return bin2hex(random_bytes($length / 2));
}

function str_contains($haystack, $needle) {
    return strpos($haystack, $needle) !== false;
}

function str_starts_with($haystack, $needle) {
    return substr($haystack, 0, strlen($needle)) === $needle;
}

function str_ends_with($haystack, $needle) {
    return substr($haystack, -strlen($needle)) === $needle;
}

// ==================== ARRAY HELPERS ====================

function array_get($array, $key, $default = null) {
    if (isset($array[$key])) return $array[$key];
    
    foreach (explode('.', $key) as $segment) {
        if (!is_array($array) || !array_key_exists($segment, $array)) {
            return $default;
        }
        $array = $array[$segment];
    }
    
    return $array;
}

// ==================== DATE & TIME ====================

function now() {
    return date('Y-m-d H:i:s');
}

function today() {
    return date('Y-m-d');
}

function format_date($date, $format = DATE_FORMAT) {
    if (empty($date)) return '-';
    return date($format, strtotime($date));
}

function format_datetime($datetime, $format = DATETIME_FORMAT) {
    if (empty($datetime)) return '-';
    return date($format, strtotime($datetime));
}

function time_ago($datetime) {
    if (empty($datetime)) return '-';
    
    $timestamp = strtotime($datetime);
    $diff = time() - $timestamp;
    
    if ($diff < 60) return $diff . ' detik yang lalu';
    if ($diff < 3600) return floor($diff / 60) . ' menit yang lalu';
    if ($diff < 86400) return floor($diff / 3600) . ' jam yang lalu';
    if ($diff < 604800) return floor($diff / 86400) . ' hari yang lalu';
    
    return format_date($datetime);
}

// ==================== NUMBER & CURRENCY ====================

function rupiah($amount) {
    if (is_null($amount)) return 'Rp 0';
    return 'Rp ' . number_format($amount, 0, ',', '.');
}

function number_format_id($num) {
    return number_format($num, 0, ',', '.');
}

function percent($num, $decimals = 2) {
    return number_format($num, $decimals) . '%';
}

// ==================== FILE & UPLOAD ====================

function file_extension($filename) {
    return strtolower(pathinfo($filename, PATHINFO_EXTENSION));
}

function file_size_format($bytes) {
    $units = ['B', 'KB', 'MB', 'GB'];
    $i = 0;
    
    while ($bytes >= 1024 && $i < 3) {
        $bytes /= 1024;
        $i++;
    }
    
    return round($bytes, 2) . ' ' . $units[$i];
}

function is_image($filename) {
    $ext = file_extension($filename);
    return in_array($ext, ['jpg', 'jpeg', 'png', 'gif', 'webp']);
}

// ==================== VIEW HELPERS ====================

function view($view, $data = []) {
    $viewEngine = new View();
    $viewEngine->render($view, $data);
}

function json_response($data, $code = 200) {
    Response::json($data, $code);
}

function success_response($message, $data = []) {
    Response::success($message, $data);
}

function error_response($message, $code = 400) {
    Response::error($message, $code);
}

// ==================== SECURITY ====================

function escape($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}

function e($string) {
    return escape($string);
}

function clean($string) {
    return strip_tags(trim($string));
}

function hash_password($password) {
    return password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
}

function verify_password($password, $hash) {
    return password_verify($password, $hash);
}

// ==================== VALIDATION ====================

function is_email($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

function is_url($url) {
    return filter_var($url, FILTER_VALIDATE_URL) !== false;
}

function is_phone($phone) {
    return preg_match('/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/', $phone);
}

// ==================== PAGINATION ====================

function paginate($total, $perPage = ITEMS_PER_PAGE, $currentPage = 1) {
    $totalPages = ceil($total / $perPage);
    $offset = ($currentPage - 1) * $perPage;
    
    return [
        'total' => $total,
        'per_page' => $perPage,
        'current_page' => $currentPage,
        'total_pages' => $totalPages,
        'offset' => $offset,
        'has_more' => $currentPage < $totalPages
    ];
}

// ==================== DEBUG ====================

function dd(...$vars) {
    foreach ($vars as $var) {
        echo '<pre>';
        var_dump($var);
        echo '</pre>';
    }
    die();
}

function dump(...$vars) {
    foreach ($vars as $var) {
        echo '<pre>';
        var_dump($var);
        echo '</pre>';
    }
}

function logger($message, $data = []) {
    $logFile = ROOT_PATH . '/logs/app.log';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[{$timestamp}] {$message}";
    
    if (!empty($data)) {
        $logMessage .= ' | Data: ' . json_encode($data);
    }
    
    $logMessage .= "\n";
    
    if (!file_exists(dirname($logFile))) {
        mkdir(dirname($logFile), 0755, true);
    }
    
    file_put_contents($logFile, $logMessage, FILE_APPEND);
}
