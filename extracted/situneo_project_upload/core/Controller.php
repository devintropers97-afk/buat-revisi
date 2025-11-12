<?php
class Controller {
    protected $db;
    protected $view;
    
    public function __construct() {
        $this->db = new Database();
        $this->view = new View();
    }
    
    protected function model($model) {
        require_once MODELS_PATH . '/' . $model . '.php';
        return new $model();
    }
    
    protected function view($view, $data = []) {
        $this->view->render($view, $data);
    }
    
    protected function json($data, $code = 200) {
        Response::json($data, $code);
    }
    
    protected function redirect($url) {
        header('Location: ' . BASE_URL . '/' . $url);
        exit;
    }
}
