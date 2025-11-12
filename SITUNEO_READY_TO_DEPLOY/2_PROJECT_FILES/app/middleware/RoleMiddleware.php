<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Role-based Access Control Middleware
 */

class RoleMiddleware {
    public function handle($requiredRole) {
        if (!Auth::check()) {
            redirect('auth/login');
            exit;
        }
        
        $userRole = Auth::role();
        
        // Role hierarchy
        $roleHierarchy = [
            'admin' => 5,
            'manager' => 4,
            'spv' => 3,
            'partner' => 2,
            'client' => 1
        ];
        
        $userLevel = $roleHierarchy[$userRole] ?? 0;
        $requiredLevel = $roleHierarchy[$requiredRole] ?? 0;
        
        if ($userLevel < $requiredLevel) {
            http_response_code(403);
            require_once VIEWS_PATH . '/errors/403.php';
            exit;
        }
    }
}
