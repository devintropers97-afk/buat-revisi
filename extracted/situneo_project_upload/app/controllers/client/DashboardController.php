<?php
/**
 * Client Dashboard Controller
 */

class DashboardController extends Controller {

    public function index() {
        $data = [
            'title' => 'Client Dashboard',
            'user' => auth()
        ];

        $this->view('client.dashboard', $data);
    }
}
