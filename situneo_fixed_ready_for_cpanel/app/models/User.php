<?php
/**
 * User Model
 * Handles user data and authentication
 */

class User extends Model {
    protected $table = 'users';
    protected $fillable = ['name', 'email', 'password', 'role', 'phone', 'company'];

    /**
     * Find user by email
     */
    public function findByEmail($email) {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE email = ? LIMIT 1");
        $stmt->execute([$email]);
        return $stmt->fetch();
    }

    /**
     * Verify user credentials
     */
    public function verify($email, $password) {
        $user = $this->findByEmail($email);

        if (!$user) {
            return false;
        }

        if (password_verify($password, $user['password'])) {
            return $user;
        }

        return false;
    }

    /**
     * Create new user
     */
    public function createUser($data) {
        // Hash password before saving
        if (isset($data['password'])) {
            $data['password'] = password_hash($data['password'], PASSWORD_BCRYPT);
        }

        return $this->create($data);
    }
}
