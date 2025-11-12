<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Router Class - URL Routing & Controller Loading
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

class Router {
    protected $controller = 'HomeController';
    protected $method = 'index';
    protected $params = [];
    protected $role = 'public';
    
    public function __construct() {
        $url = $this->parseUrl();
        
        // Determine role from URL
        if (isset($url[0]) && in_array($url[0], ['admin', 'manager', 'spv', 'partner', 'client', 'auth'])) {
            $this->role = array_shift($url);
        }
        
        // Determine controller
        if (isset($url[0])) {
            $controller = ucfirst($url[0]) . 'Controller';
            $controllerPath = CONTROLLERS_PATH . '/' . $this->role . '/' . $controller . '.php';
            
            if (file_exists($controllerPath)) {
                $this->controller = $controller;
                array_shift($url);
            }
        }
        
        // Load controller
        $controllerFile = CONTROLLERS_PATH . '/' . $this->role . '/' . $this->controller . '.php';
        
        if (!file_exists($controllerFile)) {
            $this->show404();
            return;
        }
        
        require_once $controllerFile;
        $this->controller = new $this->controller;
        
        // Determine method
        if (isset($url[0])) {
            if (method_exists($this->controller, $url[0])) {
                $this->method = array_shift($url);
            }
        }
        
        // Get params
        $this->params = $url ? array_values($url) : [];
        
        // Call controller method with params
        call_user_func_array([$this->controller, $this->method], $this->params);
    }
    
    protected function parseUrl() {
        if (isset($_GET['url'])) {
            return explode('/', filter_var(rtrim($_GET['url'], '/'), FILTER_SANITIZE_URL));
        }
        return [];
    }
    
    protected function show404() {
        http_response_code(404);
        require_once VIEWS_PATH . '/errors/404.php';
        exit;
    }
}
