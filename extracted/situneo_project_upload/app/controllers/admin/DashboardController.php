<?php
/**
 * Admin Dashboard Controller
 */

class DashboardController extends Controller {

    public function index() {
        $data = [
            'title' => 'Admin Dashboard',
            'user' => auth()
        ];

        $this->view('admin.dashboard', $data);
    }
}
