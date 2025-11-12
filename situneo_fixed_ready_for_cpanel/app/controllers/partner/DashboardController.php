<?php
/**
 * Partner Dashboard Controller
 */

class DashboardController extends Controller {

    public function index() {
        $data = [
            'title' => 'Partner Dashboard',
            'user' => auth()
        ];

        $this->view('partner.dashboard', $data);
    }
}
