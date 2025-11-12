<?php
class Validator {
    private $errors = [];
    private $data = [];
    
    public function validate($data, $rules) {
        $this->data = $data;
        $this->errors = [];
        
        foreach ($rules as $field => $ruleSet) {
            $ruleList = explode('|', $ruleSet);
            foreach ($ruleList as $rule) {
                $this->applyRule($field, $rule);
            }
        }
        
        return empty($this->errors);
    }
    
    private function applyRule($field, $rule) {
        $value = $this->data[$field] ?? null;
        
        if ($rule === 'required' && empty($value)) {
            $this->errors[$field][] = ucfirst($field) . ' is required';
        }
        
        if (strpos($rule, 'min:') === 0) {
            $min = (int)substr($rule, 4);
            if (strlen($value) < $min) {
                $this->errors[$field][] = ucfirst($field) . " must be at least {$min} characters";
            }
        }
        
        if (strpos($rule, 'max:') === 0) {
            $max = (int)substr($rule, 4);
            if (strlen($value) > $max) {
                $this->errors[$field][] = ucfirst($field) . " must not exceed {$max} characters";
            }
        }
        
        if ($rule === 'email' && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
            $this->errors[$field][] = ucfirst($field) . ' must be a valid email';
        }
        
        if ($rule === 'numeric' && !is_numeric($value)) {
            $this->errors[$field][] = ucfirst($field) . ' must be numeric';
        }
    }
    
    public function errors() {
        return $this->errors;
    }
    
    public function firstError($field) {
        return $this->errors[$field][0] ?? null;
    }
}
