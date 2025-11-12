<?php
class PageController extends Controller {
    public function about() {
        $data = [
            'title' => 'About Us - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.about', $data);
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

    public function sitemap() {
        $data = [
            'title' => 'Sitemap - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.sitemap', $data);
    }
}
