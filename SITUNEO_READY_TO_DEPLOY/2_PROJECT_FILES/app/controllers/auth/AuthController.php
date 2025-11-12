<?php
class AuthController extends Controller {
    public function login() {
        if (is_post()) {
            $email = post('email');
            $password = post('password');
            
            // Validate and authenticate
            // This is placeholder - implement proper authentication
            
            $this->json(['success' => true, 'message' => 'Login successful']);
        }
        
        $data = ['title' => 'Login - SITUNEO Digital'];
        $this->view('auth.login', $data);
    }
    
    public function register() {
        $data = ['title' => 'Register - SITUNEO Digital'];
        $this->view('auth.register', $data);
    }
    
    public function logout() {
        Auth::logout();
        redirect('');
    }
}
