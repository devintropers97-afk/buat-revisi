<?php
class AuthController extends Controller {
    public function login() {
        if (is_post()) {
            // Validate CSRF token
            if (!CSRF::verify(post('csrf_token'))) {
                $data = ['title' => 'Login - SITUNEO Digital', 'error' => 'Invalid CSRF token'];
                $this->view('auth.login', $data);
                return;
            }

            // Validate input
            $validator = new Validator();
            $validator->validate([
                'email' => ['required', 'email'],
                'password' => ['required', 'min:6']
            ], post());

            if ($validator->fails()) {
                $data = ['title' => 'Login - SITUNEO Digital', 'error' => 'Please check your input'];
                $this->view('auth.login', $data);
                return;
            }

            $email = clean(post('email'));
            $password = post('password');

            // Authenticate user
            $userModel = new User();
            $user = $userModel->verify($email, $password);

            if ($user) {
                Auth::login($user);
                redirect(auth_role());
            } else {
                $data = ['title' => 'Login - SITUNEO Digital', 'error' => 'Invalid email or password'];
                $this->view('auth.login', $data);
            }
            return;
        }

        $data = ['title' => 'Login - SITUNEO Digital'];
        $this->view('auth.login', $data);
    }

    public function register() {
        if (is_post()) {
            // Validate CSRF token
            if (!CSRF::verify(post('csrf_token'))) {
                $data = ['title' => 'Register - SITUNEO Digital', 'error' => 'Invalid CSRF token'];
                $this->view('auth.register', $data);
                return;
            }

            // Validate input
            $validator = new Validator();
            $validator->validate([
                'name' => ['required', 'min:3'],
                'email' => ['required', 'email'],
                'phone' => ['required'],
                'password' => ['required', 'min:8'],
                'password_confirm' => ['required', 'match:password'],
                'role' => ['required']
            ], post());

            if ($validator->fails()) {
                $data = ['title' => 'Register - SITUNEO Digital', 'error' => 'Please check your input'];
                $this->view('auth.register', $data);
                return;
            }

            // Check if email already exists
            $userModel = new User();
            if ($userModel->findByEmail(post('email'))) {
                $data = ['title' => 'Register - SITUNEO Digital', 'error' => 'Email already registered'];
                $this->view('auth.register', $data);
                return;
            }

            // Create user
            $userData = [
                'name' => clean(post('name')),
                'email' => clean(post('email')),
                'phone' => clean(post('phone')),
                'company' => clean(post('company')),
                'password' => post('password'),
                'role' => clean(post('role'))
            ];

            if ($userModel->createUser($userData)) {
                flash('success', 'Registration successful! Please login.');
                redirect('auth/login');
            } else {
                $data = ['title' => 'Register - SITUNEO Digital', 'error' => 'Registration failed'];
                $this->view('auth.register', $data);
            }
            return;
        }

        $data = ['title' => 'Register - SITUNEO Digital'];
        $this->view('auth.register', $data);
    }

    public function logout() {
        Auth::logout();
        redirect('');
    }
}
