<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Database Class - PDO Wrapper
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

class Database {
    private $conn;
    private $stmt;
    private $error;
    
    /**
     * Constructor - Create PDO connection
     */
    public function __construct() {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        
        try {
            $this->conn = new PDO($dsn, DB_USER, DB_PASS, DB_OPTIONS);
        } catch(PDOException $e) {
            $this->error = $e->getMessage();
            $this->logError('Database Connection Error: ' . $this->error);
            
            if (APP_DEBUG) {
                die('Database Connection Error: ' . $this->error);
            } else {
                die('Unable to connect to database. Please try again later.');
            }
        }
    }
    
    /**
     * Prepare SQL statement
     */
    public function query($sql) {
        $this->stmt = $this->conn->prepare($sql);
        return $this;
    }
    
    /**
     * Bind parameter to prepared statement
     */
    public function bind($param, $value, $type = null) {
        if (is_null($type)) {
            switch (true) {
                case is_int($value):
                    $type = PDO::PARAM_INT;
                    break;
                case is_bool($value):
                    $type = PDO::PARAM_BOOL;
                    break;
                case is_null($value):
                    $type = PDO::PARAM_NULL;
                    break;
                default:
                    $type = PDO::PARAM_STR;
            }
        }
        
        $this->stmt->bindValue($param, $value, $type);
        return $this;
    }
    
    /**
     * Execute prepared statement
     */
    public function execute() {
        try {
            return $this->stmt->execute();
        } catch(PDOException $e) {
            $this->error = $e->getMessage();
            $this->logError('Query Execution Error: ' . $this->error);
            return false;
        }
    }
    
    /**
     * Get all results as array
     */
    public function all() {
        $this->execute();
        return $this->stmt->fetchAll();
    }
    
    /**
     * Get single result
     */
    public function one() {
        $this->execute();
        return $this->stmt->fetch();
    }
    
    /**
     * Get single column value
     */
    public function single() {
        $this->execute();
        return $this->stmt->fetchColumn();
    }
    
    /**
     * Get row count
     */
    public function count() {
        return $this->stmt->rowCount();
    }
    
    /**
     * Get last insert ID
     */
    public function lastInsertId() {
        return $this->conn->lastInsertId();
    }
    
    /**
     * Begin transaction
     */
    public function beginTransaction() {
        return $this->conn->beginTransaction();
    }
    
    /**
     * Commit transaction
     */
    public function commit() {
        return $this->conn->commit();
    }
    
    /**
     * Rollback transaction
     */
    public function rollBack() {
        return $this->conn->rollBack();
    }
    
    /**
     * Check if in transaction
     */
    public function inTransaction() {
        return $this->conn->inTransaction();
    }
    
    /**
     * Get PDO connection
     */
    public function getConnection() {
        return $this->conn;
    }
    
    /**
     * Get last error
     */
    public function getError() {
        return $this->error;
    }
    
    /**
     * Log error to file
     */
    private function logError($message) {
        $logFile = ROOT_PATH . '/logs/database.log';
        $timestamp = date('Y-m-d H:i:s');
        $logMessage = "[{$timestamp}] {$message}\n";
        
        if (!file_exists(dirname($logFile))) {
            mkdir(dirname($logFile), 0755, true);
        }
        
        file_put_contents($logFile, $logMessage, FILE_APPEND);
    }
    
    /**
     * Close connection
     */
    public function close() {
        $this->stmt = null;
        $this->conn = null;
    }
}
