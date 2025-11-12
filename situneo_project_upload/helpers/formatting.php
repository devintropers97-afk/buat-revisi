<?php
function format_phone($phone) {
    $phone = preg_replace('/[^0-9]/', '', $phone);
    return (substr($phone, 0, 1) === '0') ? '62' . substr($phone, 1) : $phone;
}
