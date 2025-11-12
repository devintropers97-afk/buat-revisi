<?php
function is_email($email) { return filter_var($email, FILTER_VALIDATE_EMAIL) !== false; }
function is_url($url) { return filter_var($url, FILTER_VALIDATE_URL) !== false; }
