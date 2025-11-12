<?php
function escape($str) { return htmlspecialchars($str, ENT_QUOTES, 'UTF-8'); }
function e($str) { return escape($str); }
function clean($str) { return strip_tags(trim($str)); }
