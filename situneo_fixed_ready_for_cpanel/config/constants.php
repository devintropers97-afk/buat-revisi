<?php
/**
 * SITUNEO DIGITAL PLATFORM
 * System Constants & Enums
 * 
 * @version 1.0
 * @author SITUNEO Team
 */

// User Roles
define('ROLE_ADMIN', 'admin');
define('ROLE_MANAGER', 'manager');
define('ROLE_SPV', 'spv');
define('ROLE_PARTNER', 'partner');
define('ROLE_CLIENT', 'client');

// User Status
define('STATUS_ACTIVE', 'active');
define('STATUS_INACTIVE', 'inactive');
define('STATUS_SUSPENDED', 'suspended');
define('STATUS_PENDING', 'pending');

// Order Status
define('ORDER_PENDING', 'pending');
define('ORDER_PAID', 'paid');
define('ORDER_PROCESSING', 'processing');
define('ORDER_COMPLETED', 'completed');
define('ORDER_CANCELLED', 'cancelled');
define('ORDER_REFUNDED', 'refunded');

// Payment Status
define('PAYMENT_PENDING', 'pending');
define('PAYMENT_VERIFIED', 'verified');
define('PAYMENT_REJECTED', 'rejected');
define('PAYMENT_EXPIRED', 'expired');

// Commission Status
define('COMMISSION_PENDING', 'pending');
define('COMMISSION_APPROVED', 'approved');
define('COMMISSION_PAID', 'paid');
define('COMMISSION_CANCELLED', 'cancelled');

// Partner Tiers
define('TIER_1', '1'); // Bronze - 30%
define('TIER_2', '2'); // Silver - 40%
define('TIER_3', '3'); // Gold - 50%
define('TIER_MAX', 'MAX'); // Platinum - 55%

// Commission Percentages
define('COMMISSION_TIER_1', 30.00);
define('COMMISSION_TIER_2', 40.00);
define('COMMISSION_TIER_3', 50.00);
define('COMMISSION_TIER_MAX', 55.00);
define('COMMISSION_SPV', 10.00);
define('COMMISSION_MANAGER', 5.00);

// Tier Requirements
define('TIER_1_MIN_ORDERS', 0);
define('TIER_1_MAINTENANCE', 0);
define('TIER_2_MIN_ORDERS', 10);
define('TIER_2_MAINTENANCE', 10);
define('TIER_3_MIN_ORDERS', 50);
define('TIER_3_MAINTENANCE', 25);
define('TIER_MAX_MIN_ORDERS', 75);
define('TIER_MAX_MAINTENANCE', 50);

// ARPU Tiers (SPV)
define('SPV_ARPU_TIER_1_MIN', 15000000);
define('SPV_ARPU_TIER_1_MAX', 34999999);
define('SPV_ARPU_TIER_1_BONUS', 500000);

define('SPV_ARPU_TIER_2_MIN', 35000000);
define('SPV_ARPU_TIER_2_MAX', 74999999);
define('SPV_ARPU_TIER_2_BONUS', 1000000);

define('SPV_ARPU_TIER_3_MIN', 75000000);
define('SPV_ARPU_TIER_3_MAX', 199999999);
define('SPV_ARPU_TIER_3_BONUS', 2000000);

define('SPV_ARPU_TIER_4_MIN', 200000000);
define('SPV_ARPU_TIER_4_BONUS', 10000000);

// ARPU Tiers (Manager)
define('MANAGER_ARPU_TIER_1_MIN', 45000000);
define('MANAGER_ARPU_TIER_1_MAX', 104999999);
define('MANAGER_ARPU_TIER_1_BONUS', 1000000);

define('MANAGER_ARPU_TIER_2_MIN', 105000000);
define('MANAGER_ARPU_TIER_2_MAX', 224999999);
define('MANAGER_ARPU_TIER_2_BONUS', 2000000);

define('MANAGER_ARPU_TIER_3_MIN', 225000000);
define('MANAGER_ARPU_TIER_3_MAX', 599999999);
define('MANAGER_ARPU_TIER_3_BONUS', 3000000);

define('MANAGER_ARPU_TIER_4_MIN', 600000000);
define('MANAGER_ARPU_TIER_4_BONUS', 15000000);

// Service Types
define('SERVICE_TYPE_SEWA', 'sewa'); // Recurring
define('SERVICE_TYPE_PEMBUATAN', 'pembuatan'); // One-time

// Payment Methods
define('PAYMENT_BANK_TRANSFER', 'bank_transfer');
define('PAYMENT_QRIS', 'qris');
define('PAYMENT_VA', 'virtual_account');
define('PAYMENT_EWALLET', 'ewallet');

// Notification Types
define('NOTIF_INFO', 'info');
define('NOTIF_SUCCESS', 'success');
define('NOTIF_WARNING', 'warning');
define('NOTIF_ERROR', 'error');

// Languages
define('LANG_ID', 'id');
define('LANG_EN', 'en');

// Date Formats
define('DATE_FORMAT', 'd M Y');
define('TIME_FORMAT', 'H:i');
define('DATETIME_FORMAT', 'd M Y H:i');

// Currency
define('CURRENCY', 'IDR');
define('CURRENCY_SYMBOL', 'Rp');

// Company Info
define('COMPANY_NAME', 'PT SITUNEO DIGITAL SOLUSI INDONESIA');
define('COMPANY_ADDRESS', 'Jl. Bekasi Timur IX Dalam No.29, RT.13/RW.8, Duren Sawit, Jakarta Timur, DKI Jakarta 13440');
define('COMPANY_PHONE', '021-8880-7229');
define('COMPANY_WHATSAPP', '6283173868915');
define('COMPANY_EMAIL', 'vins@situneo.my.id');

// Social Media
define('SOCIAL_FACEBOOK', 'https://facebook.com/situneo');
define('SOCIAL_INSTAGRAM', 'https://instagram.com/situneo');
define('SOCIAL_TWITTER', 'https://twitter.com/situneo');
define('SOCIAL_LINKEDIN', 'https://linkedin.com/company/situneo');
define('SOCIAL_YOUTUBE', 'https://youtube.com/@situneo');

// SEO Defaults
define('SEO_DEFAULT_TITLE', 'SITUNEO Digital - Digital Agency Profesional Indonesia');
define('SEO_DEFAULT_DESCRIPTION', 'Digital agency profesional untuk website, SEO, digital marketing, branding, dan solusi digital lainnya. Hubungi kami untuk konsultasi gratis!');
define('SEO_DEFAULT_KEYWORDS', 'digital agency, web development, SEO, digital marketing, branding, Indonesia');
define('SEO_DEFAULT_IMAGE', ASSETS_URL . '/images/og-image.jpg');
