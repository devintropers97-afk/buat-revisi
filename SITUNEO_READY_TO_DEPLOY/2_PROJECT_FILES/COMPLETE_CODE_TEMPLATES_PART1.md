# 📝 SITUNEO BATCH 1-3 - COMPLETE CODE TEMPLATES
## All Files Ready to Copy-Paste

Ini adalah **COMPLETE CODE** untuk semua 60 files Batch 1-3.
Anda tinggal copy-paste sesuai struktur folder.

---

## 📂 STRUKTUR FOLDER

```
situneo/
├── config/ (4 files) ✅ DONE
├── core/ (10 files) 
├── helpers/ (5 files)
├── app/
│   ├── middleware/ (4 files)
│   ├── controllers/
│   │   ├── public/ (6 files)
│   │   └── auth/ (1 file)
│   ├── models/ (empty - for later)
│   └── views/
│       ├── layouts/ (2 files)
│       ├── partials/ (4 files)
│       ├── public/ (14 files)
│       └── errors/ (3 files)
├── public/
│   ├── index.php (1 file)
│   ├── .htaccess (1 file)
│   └── assets/
│       ├── css/ (3 files)
│       └── js/ (4 files)
└── database/
    └── schema.sql ✅ DONE
```

---

## 🔧 CORE FILES (10 files)

### 1. core/Database.php ✅ DONE

### 2. core/Router.php ✅ DONE

### 3. core/Controller.php

```php
<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Base Controller Class
 */

class Controller {
    protected $db;
    protected $view;
    protected $session;
    
    public function __construct() {
        $this->db = new Database();
        $this->view = new View();
        $this->session = new Session();
    }
    
    // Load model
    protected function model($model) {
        $modelPath = MODELS_PATH . '/' . $model . '.php';
        
        if (file_exists($modelPath)) {
            require_once $modelPath;
            return new $model();
        }
        
        throw new Exception("Model {$model} not found");
    }
    
    // Render view
    protected function view($view, $data = []) {
        return $this->view->render($view, $data);
    }
    
    // JSON response
    protected function json($data, $statusCode = 200) {
        return Response::json($data, $statusCode);
    }
    
    // Redirect
    protected function redirect($url) {
        header('Location: ' . BASE_URL . '/' . $url);
        exit;
    }
    
    // Check authentication
    protected function requireAuth() {
        if (!Auth::check()) {
            $this->redirect('auth/login');
        }
    }
    
    // Check role
    protected function requireRole($role) {
        if (!Auth::hasRole($role)) {
            $this->redirect('403');
        }
    }
}
```

### 4. core/Model.php

```php
<?php
/**
 * SITUNEO DIGITAL PLATFORM  
 * Base Model Class
 */

class Model {
    protected $db;
    protected $table;
    protected $primaryKey = 'id';
    
    public function __construct() {
        $this->db = new Database();
    }
    
    // Find by ID
    public function find($id) {
        return $this->db
            ->query("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = :id")
            ->bind(':id', $id)
            ->one();
    }
    
    // Find all
    public function all() {
        return $this->db
            ->query("SELECT * FROM {$this->table}")
            ->all();
    }
    
    // Find with conditions
    public function where($conditions = []) {
        $sql = "SELECT * FROM {$this->table}";
        
        if (!empty($conditions)) {
            $sql .= " WHERE ";
            $where = [];
            
            foreach ($conditions as $key => $value) {
                $where[] = "{$key} = :{$key}";
            }
            
            $sql .= implode(' AND ', $where);
        }
        
        $query = $this->db->query($sql);
        
        foreach ($conditions as $key => $value) {
            $query->bind(":{$key}", $value);
        }
        
        return $query->all();
    }
    
    // Insert
    public function create($data) {
        $columns = implode(', ', array_keys($data));
        $placeholders = ':' . implode(', :', array_keys($data));
        
        $sql = "INSERT INTO {$this->table} ({$columns}) VALUES ({$placeholders})";
        $query = $this->db->query($sql);
        
        foreach ($data as $key => $value) {
            $query->bind(":{$key}", $value);
        }
        
        if ($query->execute()) {
            return $this->db->lastInsertId();
        }
        
        return false;
    }
    
    // Update
    public function update($id, $data) {
        $set = [];
        
        foreach ($data as $key => $value) {
            $set[] = "{$key} = :{$key}";
        }
        
        $sql = "UPDATE {$this->table} SET " . implode(', ', $set) . 
               " WHERE {$this->primaryKey} = :id";
        
        $query = $this->db->query($sql);
        $query->bind(':id', $id);
        
        foreach ($data as $key => $value) {
            $query->bind(":{$key}", $value);
        }
        
        return $query->execute();
    }
    
    // Delete
    public function delete($id) {
        return $this->db
            ->query("DELETE FROM {$this->table} WHERE {$this->primaryKey} = :id")
            ->bind(':id', $id)
            ->execute();
    }
    
    // Count
    public function count($conditions = []) {
        $sql = "SELECT COUNT(*) FROM {$this->table}";
        
        if (!empty($conditions)) {
            $sql .= " WHERE ";
            $where = [];
            
            foreach ($conditions as $key => $value) {
                $where[] = "{$key} = :{$key}";
            }
            
            $sql .= implode(' AND ', $where);
        }
        
        $query = $this->db->query($sql);
        
        foreach ($conditions as $key => $value) {
            $query->bind(":{$key}", $value);
        }
        
        return $query->single();
    }
}
```

###  5. core/View.php

```php
<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * View Rendering Engine
 */

class View {
    public function render($view, $data = []) {
        // Extract data to variables
        extract($data);
        
        // Build view path
        $viewFile = VIEWS_PATH . '/' . str_replace('.', '/', $view) . '.php';
        
        if (!file_exists($viewFile)) {
            die("View not found: {$view}");
        }
        
        // Start output buffering
        ob_start();
        
        // Include view file
        require $viewFile;
        
        // Get buffered content
        $content = ob_get_clean();
        
        // If view has layout, wrap content
        if (isset($layout)) {
            $layoutFile = VIEWS_PATH . '/layouts/' . $layout . '.php';
            
            if (file_exists($layoutFile)) {
                require $layoutFile;
            } else {
                echo $content;
            }
        } else {
            echo $content;
        }
    }
}
```

Saya akan lanjutkan dengan remaining files. Karena terlalu panjang untuk 1 file, saya akan split menjadi beberapa part. 

**Mau saya lanjutkan buat SEMUA FILES (akan jadi document panjang) atau langsung bikin ZIP dengan files yang sudah ada + dokumentasi?** 🤔
