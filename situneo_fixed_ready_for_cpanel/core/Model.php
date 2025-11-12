<?php
class Model {
    protected $db;
    protected $table;
    protected $primaryKey = 'id';
    
    public function __construct() {
        $this->db = new Database();
    }
    
    public function find($id) {
        return $this->db->query("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = :id")
            ->bind(':id', $id)->one();
    }
    
    public function all() {
        return $this->db->query("SELECT * FROM {$this->table}")->all();
    }
    
    public function create($data) {
        $columns = implode(', ', array_keys($data));
        $placeholders = ':' . implode(', :', array_keys($data));
        $sql = "INSERT INTO {$this->table} ({$columns}) VALUES ({$placeholders})";
        $query = $this->db->query($sql);
        foreach ($data as $key => $value) {
            $query->bind(":{$key}", $value);
        }
        return $query->execute() ? $this->db->lastInsertId() : false;
    }
}
