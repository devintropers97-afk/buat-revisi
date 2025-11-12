<?php
class ContactController extends Controller {
    public function index() {
        $data = [
            'title' => 'Contact - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.contact', $data);
    }
    
    public function pricing() {
        $data = [
            'title' => 'Pricing - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.pricing', $data);
    }
    
    public function career() {
        $data = [
            'title' => 'Career - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.career', $data);
    }
    
    public function terms() {
        $data = [
            'title' => 'Terms & Conditions - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.terms', $data);
    }
    
    public function privacy() {
        $data = [
            'title' => 'Privacy Policy - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.privacy', $data);
    }
    
    public function about() {
        $data = [
            'title' => 'About Us - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.about', $data);
    }
    
    public function submit() {
        if (is_post()) {
            // Process contact form
            $this->json(['success' => true, 'message' => 'Message sent!']);
        }
    }
}
