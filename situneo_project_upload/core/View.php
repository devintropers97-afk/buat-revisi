<?php
class View {
    public function render($view, $data = []) {
        extract($data);
        $viewFile = VIEWS_PATH . '/' . str_replace('.', '/', $view) . '.php';
        if (!file_exists($viewFile)) die("View not found: {$view}");
        ob_start();
        require $viewFile;
        $content = ob_get_clean();
        if (isset($layout)) {
            $layoutFile = VIEWS_PATH . '/layouts/' . $layout . '.php';
            if (file_exists($layoutFile)) require $layoutFile;
            else echo $content;
        } else {
            echo $content;
        }
    }
}
