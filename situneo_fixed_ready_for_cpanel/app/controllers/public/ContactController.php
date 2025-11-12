<?php
class ContactController extends Controller {
    public function index() {
        $data = [
            'title' => 'Contact - SITUNEO Digital',
            'layout' => 'public'
        ];
        $this->view('public.contact', $data);
    }

    public function submit() {
        if (is_post()) {
            // Validate CSRF token
            if (!CSRF::verify(post('csrf_token'))) {
                $this->json(['success' => false, 'message' => 'Invalid CSRF token'], 403);
                return;
            }

            // Validate input
            $validator = new Validator();
            $validator->validate([
                'name' => ['required', 'min:3'],
                'email' => ['required', 'email'],
                'message' => ['required', 'min:10']
            ], post());

            if ($validator->fails()) {
                $this->json(['success' => false, 'errors' => $validator->errors()], 400);
                return;
            }

            // Process contact form
            $name = clean(post('name'));
            $email = clean(post('email'));
            $message = clean(post('message'));

            // TODO: Send email or save to database

            $this->json(['success' => true, 'message' => 'Message sent successfully!']);
        }
    }
}
