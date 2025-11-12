<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * Email Configuration (SMTP)
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

// Email Settings
define('MAIL_HOST', 'smtp.gmail.com'); // atau smtp hosting Anda
define('MAIL_PORT', 587);
define('MAIL_USERNAME', 'noreply@situneo.my.id');
define('MAIL_PASSWORD', 'your-email-password-here');
define('MAIL_ENCRYPTION', 'tls'); // tls atau ssl
define('MAIL_FROM_ADDRESS', 'noreply@situneo.my.id');
define('MAIL_FROM_NAME', 'SITUNEO Digital');

// Email Templates Path
define('EMAIL_TEMPLATES_PATH', APP_PATH . '/views/emails');

// Email Queue (if using)
define('EMAIL_QUEUE_ENABLED', false);
