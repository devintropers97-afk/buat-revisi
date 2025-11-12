<?php
/**
 * Manager Dashboard Controller
 */

class DashboardController extends Controller {

    public function index() {
        $data = [
            'title' => 'Manager Dashboard',
            'user' => auth()
        ];

        $this->view('manager.dashboard', $data);
    }
}
