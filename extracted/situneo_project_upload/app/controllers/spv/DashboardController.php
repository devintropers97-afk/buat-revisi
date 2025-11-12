<?php
/**
 * Supervisor Dashboard Controller
 */

class DashboardController extends Controller {

    public function index() {
        $data = [
            'title' => 'Supervisor Dashboard',
            'user' => auth()
        ];

        $this->view('spv.dashboard', $data);
    }
}
