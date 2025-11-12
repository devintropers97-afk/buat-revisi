<?php
class BlogController extends Controller {
    public function index() {
        $data = [
            'title' => 'Blog - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.blog', $data);
    }
    
    public function detail($slug) {
        $data = [
            'title' => 'Blog Post - SITUNEO Digital',
            'layout' => 'public',
            'slug' => $slug
        ];
        $this->view('public.blog-detail', $data);
    }
}
