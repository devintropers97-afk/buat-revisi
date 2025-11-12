<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Main Application Configuration
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

// Application Settings
define('APP_NAME', 'SITUNEO Digital');
define('APP_URL', 'https://situneo.my.id');
define('APP_ENV', 'production'); // production | development | staging
define('APP_DEBUG', false);
define('APP_TIMEZONE', 'Asia/Jakarta');

// Paths
define('ROOT_PATH', dirname(__DIR__));
define('APP_PATH', ROOT_PATH . '/app');
define('CORE_PATH', ROOT_PATH . '/core');
define('CONFIG_PATH', ROOT_PATH . '/config');
define('PUBLIC_PATH', ROOT_PATH . '/public');
define('STORAGE_PATH', ROOT_PATH . '/storage');
define('UPLOAD_PATH', PUBLIC_PATH . '/assets/uploads');
define('VIEWS_PATH', APP_PATH . '/views');
define('CONTROLLERS_PATH', APP_PATH . '/controllers');
define('MODELS_PATH', APP_PATH . '/models');

// URLs
define('BASE_URL', APP_URL);
define('ASSETS_URL', APP_URL . '/assets');
define('UPLOAD_URL', APP_URL . '/assets/uploads');

// Security
define('ENCRYPTION_KEY', 'your-32-character-secret-key-here-change-this');
define('SESSION_LIFETIME', 7200); // 2 hours in seconds
define('CSRF_TOKEN_NAME', '_token');
define('CSRF_TOKEN_LIFETIME', 3600); // 1 hour

// Upload Settings
define('MAX_UPLOAD_SIZE', 10485760); // 10MB in bytes
define('ALLOWED_IMAGE_TYPES', ['jpg', 'jpeg', 'png', 'gif', 'webp']);
define('ALLOWED_DOCUMENT_TYPES', ['pdf', 'doc', 'docx', 'xls', 'xlsx']);
define('ALLOWED_FILE_TYPES', array_merge(ALLOWED_IMAGE_TYPES, ALLOWED_DOCUMENT_TYPES));

// Pagination
define('ITEMS_PER_PAGE', 20);
define('PAGINATION_LINKS', 5);

// API Settings
define('API_VERSION', 'v1');
define('API_RATE_LIMIT', 60); // requests per minute

// Timezone
date_default_timezone_set(APP_TIMEZONE);

// Error Reporting
if (APP_DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
    ini_set('log_errors', 1);
    ini_set('error_log', ROOT_PATH . '/logs/error.log');
}

// Session Configuration
ini_set('session.cookie_httponly', 1);
ini_set('session.use_only_cookies', 1);
ini_set('session.cookie_samesite', 'Lax');
if (APP_ENV === 'production') {
    ini_set('session.cookie_secure', 1);
}

// Load other configs
require_once CONFIG_PATH . '/database.php';
require_once CONFIG_PATH . '/email.php';
require_once CONFIG_PATH . '/constants.php';
