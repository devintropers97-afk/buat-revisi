<?php
class HomeController extends Controller {
    public function index() {
        $data = [
            'title' => 'Home - SITUNEO Digital',
            'layout' => 'public',
            'stats' => [
                'clients' => 500,
                'projects' => 1200,
                'partners' => 150,
                'services' => 232
            ]
        ];
        $this->view('public.home', $data);
    }
}
