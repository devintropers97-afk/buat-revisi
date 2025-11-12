<?php
require_once '../config/app.php';

spl_autoload_register(function($class) {
    $paths = [CORE_PATH, CONTROLLERS_PATH, MODELS_PATH, APP_PATH . '/middleware'];
    foreach ($paths as $path) {
        $file = $path . '/' . $class . '.php';
        if (file_exists($file)) {
            require_once $file;
            return;
        }
    }
});

require_once ROOT_PATH . '/helpers/functions.php';

// Initialize session
$session = new Session();

// Initialize router and handle request
try {
    $router = new Router();
} catch (Exception $e) {
    if (ENV === 'development') {
        die('Error: ' . $e->getMessage());
    } else {
        header('HTTP/1.1 500 Internal Server Error');
        die('An error occurred. Please try again later.');
    }
}
