<?php
class ServiceController extends Controller {
    public function index() {
        $data = [
            'title' => 'Services - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.services', $data);
    }
    
    public function detail($slug) {
        $data = [
            'title' => 'Service Detail - SITUNEO Digital',
            'layout' => 'public',
            'slug' => $slug
        ];
        $this->view('public.service-detail', $data);
    }
}
