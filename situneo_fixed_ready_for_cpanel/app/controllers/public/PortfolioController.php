<?php
class PortfolioController extends Controller {
    public function index() {
        $data = [
            'title' => 'Portfolio - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.portfolio', $data);
    }
    
    public function detail($id) {
        $data = [
            'title' => 'Portfolio Detail - SITUNEO Digital',
            'layout' => 'public',
            'id' => $id
        ];
        $this->view('public.portfolio-detail', $data);
    }
}
