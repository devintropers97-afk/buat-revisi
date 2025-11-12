<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Root Index - Redirect to Public
 *
 * Jika file ini diakses, redirect ke folder public/
 * Seharusnya tidak sampai ke sini jika .htaccess bekerja
 */

// Redirect ke folder public
header('Location: public/index.php');
exit();
