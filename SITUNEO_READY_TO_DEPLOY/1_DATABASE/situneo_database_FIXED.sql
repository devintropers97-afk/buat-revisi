-- =====================================================
-- SITUNEO DIGITAL PLATFORM - DATABASE SCHEMA COMPLETE
-- =====================================================
-- Version: 2.0 ENHANCED
-- Total Tables: 120+ (ALL FUNCTIONAL!)
-- Approach: KERJA CERDAS - OTOMATIS!
-- Date: 12 November 2025
-- =====================================================

-- Database Configuration
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- DATABASE CREATION
-- =====================================================
CREATE DATABASE IF NOT EXISTS `nrrskfvk_situneo_digital` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `nrrskfvk_situneo_digital`;

-- =====================================================
-- DISABLE FOREIGN KEY CHECKS (Fix dependency issues)
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- GROUP 1: USER MANAGEMENT (8 TABLES) - ENHANCED
-- =====================================================

-- 1. Master Users Table
CREATE TABLE `users` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `role` ENUM('admin', 'manager', 'spv', 'partner', 'client') NOT NULL,
  `username` VARCHAR(50) UNIQUE NOT NULL,
  `email` VARCHAR(100) UNIQUE NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20),
  `full_name` VARCHAR(100) NOT NULL,
  `status` ENUM('active', 'inactive', 'suspended', 'pending') DEFAULT 'pending',
  `language_preference` ENUM('id', 'en') DEFAULT 'id',
  `timezone` VARCHAR(50) DEFAULT 'Asia/Jakarta',
  `avatar` VARCHAR(255),
  `email_verified` BOOLEAN DEFAULT FALSE,
  `phone_verified` BOOLEAN DEFAULT FALSE,
  `two_factor_enabled` BOOLEAN DEFAULT FALSE,
  `two_factor_secret` VARCHAR(32),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` TIMESTAMP NULL,
  `last_login_ip` VARCHAR(45),
  `last_login_device` VARCHAR(255),
  `failed_login_attempts` INT DEFAULT 0,
  `locked_until` TIMESTAMP NULL,
  INDEX idx_role (role),
  INDEX idx_status (status),
  INDEX idx_email (email),
  INDEX idx_username (username),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. User Profiles (Extended Info)
CREATE TABLE `user_profiles` (
  `profile_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `birth_date` DATE,
  `gender` ENUM('male', 'female', 'other'),
  `address_street` VARCHAR(255),
  `address_city` VARCHAR(100),
  `address_province` VARCHAR(100),
  `address_postal_code` VARCHAR(10),
  `address_country` VARCHAR(2) DEFAULT 'ID',
  `bio` TEXT,
  `website_url` VARCHAR(255),
  `facebook_url` VARCHAR(255),
  `instagram_url` VARCHAR(255),
  `linkedin_url` VARCHAR(255),
  `twitter_url` VARCHAR(255),
  `emergency_contact_name` VARCHAR(100),
  `emergency_contact_phone` VARCHAR(20),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. User Sessions (Active Sessions Tracking)
CREATE TABLE `user_sessions` (
  `session_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `session_token` VARCHAR(255) UNIQUE NOT NULL,
  `ip_address` VARCHAR(45),
  `user_agent` VARCHAR(255),
  `device_type` ENUM('desktop', 'mobile', 'tablet', 'other'),
  `browser` VARCHAR(50),
  `os` VARCHAR(50),
  `location_country` VARCHAR(100),
  `location_city` VARCHAR(100),
  `is_active` BOOLEAN DEFAULT TRUE,
  `last_activity` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_token (session_token),
  INDEX idx_active (is_active),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. User Activity Logs (AUDIT TRAIL - AUTO LOG)
CREATE TABLE `user_activity_logs` (
  `log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `action` VARCHAR(100) NOT NULL,
  `entity_type` VARCHAR(50),
  `entity_id` INT UNSIGNED,
  `description` TEXT,
  `ip_address` VARCHAR(45),
  `user_agent` VARCHAR(255),
  `request_method` VARCHAR(10),
  `request_url` VARCHAR(500),
  `old_data` JSON,
  `new_data` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_action (action),
  INDEX idx_entity (entity_type, entity_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Password Resets
CREATE TABLE `password_resets` (
  `reset_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `ip_address` VARCHAR(45),
  `used` BOOLEAN DEFAULT FALSE,
  `expires_at` TIMESTAMP NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_token (token),
  INDEX idx_email (email),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Email Verifications
CREATE TABLE `email_verifications` (
  `verification_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `verified` BOOLEAN DEFAULT FALSE,
  `verified_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_token (token),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. User Preferences (AUTO-SAVE SETTINGS)
CREATE TABLE `user_preferences` (
  `preference_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `notification_email` BOOLEAN DEFAULT TRUE,
  `notification_sms` BOOLEAN DEFAULT FALSE,
  `notification_push` BOOLEAN DEFAULT TRUE,
  `notification_order_status` BOOLEAN DEFAULT TRUE,
  `notification_payment` BOOLEAN DEFAULT TRUE,
  `notification_commission` BOOLEAN DEFAULT TRUE,
  `notification_marketing` BOOLEAN DEFAULT FALSE,
  `dashboard_layout` ENUM('grid', 'list', 'compact') DEFAULT 'grid',
  `theme` ENUM('light', 'dark', 'auto') DEFAULT 'light',
  `items_per_page` INT DEFAULT 20,
  `currency_display` VARCHAR(10) DEFAULT 'IDR',
  `date_format` VARCHAR(20) DEFAULT 'd M Y',
  `time_format` VARCHAR(20) DEFAULT 'H:i',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. User Devices (DEVICE TRACKING - SECURITY)
CREATE TABLE `user_devices` (
  `device_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `device_fingerprint` VARCHAR(255) NOT NULL,
  `device_name` VARCHAR(100),
  `device_type` ENUM('desktop', 'mobile', 'tablet'),
  `browser` VARCHAR(50),
  `os` VARCHAR(50),
  `is_trusted` BOOLEAN DEFAULT FALSE,
  `last_used` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `first_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_fingerprint (device_fingerprint)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 2: CLIENT TABLES (10 TABLES) - ENHANCED
-- =====================================================

-- 9. Clients
CREATE TABLE `clients` (
  `client_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NULL COMMENT 'Who recruited this client',
  `company_name` VARCHAR(150),
  `company_type` ENUM('individual', 'cv', 'pt', 'yayasan', 'other'),
  `industry` VARCHAR(100),
  `tax_id` VARCHAR(50) COMMENT 'NPWP',
  `total_orders` INT UNSIGNED DEFAULT 0,
  `total_spent` DECIMAL(15,2) DEFAULT 0.00,
  `lifetime_value` DECIMAL(15,2) DEFAULT 0.00 COMMENT 'Projected CLV',
  `avg_order_value` DECIMAL(15,2) DEFAULT 0.00,
  `last_order_date` TIMESTAMP NULL,
  `client_since` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `client_segment` ENUM('bronze', 'silver', 'gold', 'platinum', 'diamond') DEFAULT 'bronze',
  `satisfaction_score` DECIMAL(3,2) DEFAULT 0.00 COMMENT 'Out of 5.00',
  `churn_risk_score` DECIMAL(3,2) DEFAULT 0.00 COMMENT '0=low, 1=high',
  `status` ENUM('active', 'inactive', 'vip', 'blacklist') DEFAULT 'active',
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_partner (partner_id),
  INDEX idx_segment (client_segment),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. Client Contacts (Multiple Contacts per Client)
CREATE TABLE `client_contacts` (
  `contact_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `contact_type` ENUM('primary', 'billing', 'technical', 'other') DEFAULT 'primary',
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100),
  `phone` VARCHAR(20),
  `position` VARCHAR(100),
  `is_primary` BOOLEAN DEFAULT FALSE,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_client (client_id),
  INDEX idx_type (contact_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. Client Addresses (Multiple Addresses)
CREATE TABLE `client_addresses` (
  `address_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `address_type` ENUM('office', 'warehouse', 'billing', 'shipping', 'other') DEFAULT 'office',
  `address_label` VARCHAR(50),
  `street` VARCHAR(255),
  `city` VARCHAR(100),
  `province` VARCHAR(100),
  `postal_code` VARCHAR(10),
  `country` VARCHAR(2) DEFAULT 'ID',
  `latitude` DECIMAL(10, 8),
  `longitude` DECIMAL(11, 8),
  `is_default` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_client (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. Client Notes (Internal Notes by Admin/Sales)
CREATE TABLE `client_notes` (
  `note_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `author_id` INT UNSIGNED NOT NULL COMMENT 'Admin/Partner who wrote note',
  `note_type` ENUM('general', 'follow_up', 'complaint', 'opportunity', 'warning') DEFAULT 'general',
  `subject` VARCHAR(200),
  `content` TEXT NOT NULL,
  `is_important` BOOLEAN DEFAULT FALSE,
  `reminder_date` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_client (client_id),
  INDEX idx_type (note_type),
  INDEX idx_reminder (reminder_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. Client Interactions (AUTO-LOG all touchpoints)
CREATE TABLE `client_interactions` (
  `interaction_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `interaction_type` ENUM('email', 'call', 'meeting', 'chat', 'support_ticket', 'order', 'payment') NOT NULL,
  `direction` ENUM('inbound', 'outbound'),
  `subject` VARCHAR(255),
  `summary` TEXT,
  `staff_id` INT UNSIGNED COMMENT 'Who handled this',
  `duration_minutes` INT,
  `outcome` ENUM('successful', 'follow_up_needed', 'issue_resolved', 'no_answer', 'other'),
  `next_action` VARCHAR(255),
  `next_action_date` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_client (client_id),
  INDEX idx_type (interaction_type),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. Client Segments (AUTO-SEGMENT based on behavior)
CREATE TABLE `client_segments` (
  `segment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `segment_name` VARCHAR(100) NOT NULL,
  `segment_criteria` JSON COMMENT 'Rules for auto-segmentation',
  `description` TEXT,
  `color_code` VARCHAR(7),
  `is_active` BOOLEAN DEFAULT TRUE,
  `client_count` INT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 15. Client Segment Members (AUTO-UPDATED)
CREATE TABLE `client_segment_members` (
  `member_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `segment_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `added_by` ENUM('auto', 'manual') DEFAULT 'auto',
  FOREIGN KEY (segment_id) REFERENCES client_segments(segment_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  UNIQUE KEY unique_member (segment_id, client_id),
  INDEX idx_segment (segment_id),
  INDEX idx_client (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 16. Client Feedback (Ratings & Reviews)
CREATE TABLE `client_feedback` (
  `feedback_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED,
  `rating_overall` TINYINT CHECK (rating_overall BETWEEN 1 AND 5),
  `rating_quality` TINYINT CHECK (rating_quality BETWEEN 1 AND 5),
  `rating_communication` TINYINT CHECK (rating_communication BETWEEN 1 AND 5),
  `rating_timeliness` TINYINT CHECK (rating_timeliness BETWEEN 1 AND 5),
  `rating_value` TINYINT CHECK (rating_value BETWEEN 1 AND 5),
  `comment` TEXT,
  `would_recommend` BOOLEAN,
  `is_testimonial` BOOLEAN DEFAULT FALSE,
  `is_public` BOOLEAN DEFAULT TRUE,
  `admin_response` TEXT,
  `responded_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_client (client_id),
  INDEX idx_order (order_id),
  INDEX idx_rating (rating_overall),
  INDEX idx_public (is_public)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 17. Client Tags (Flexible Tagging System)
CREATE TABLE `client_tags` (
  `tag_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tag_name` VARCHAR(50) NOT NULL UNIQUE,
  `tag_color` VARCHAR(7),
  `usage_count` INT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 18. Client Tag Relations
CREATE TABLE `client_tag_relations` (
  `relation_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `tag_id` INT UNSIGNED NOT NULL,
  `tagged_by` INT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES client_tags(tag_id) ON DELETE CASCADE,
  FOREIGN KEY (tagged_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_tag (client_id, tag_id),
  INDEX idx_client (client_id),
  INDEX idx_tag (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 3: PARTNER TABLES (15 TABLES) - SUPER ENHANCED
-- =====================================================

-- 19. Partners
CREATE TABLE `partners` (
  `partner_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `spv_id` INT UNSIGNED NULL,
  `tier_current` ENUM('1', '2', '3', 'MAX') DEFAULT '1',
  `tier_locked_until` DATE NULL COMMENT 'Locked due to maintenance fail',
  `total_orders_lifetime` INT UNSIGNED DEFAULT 0,
  `monthly_orders` INT UNSIGNED DEFAULT 0,
  `monthly_orders_last_updated` DATE,
  `commission_rate` DECIMAL(5,2) COMMENT 'Current tier percentage',
  `commission_balance` DECIMAL(15,2) DEFAULT 0.00,
  `commission_pending` DECIMAL(15,2) DEFAULT 0.00,
  `commission_paid_total` DECIMAL(15,2) DEFAULT 0.00,
  `commission_lifetime` DECIMAL(15,2) DEFAULT 0.00,
  `referral_code` VARCHAR(20) UNIQUE NOT NULL,
  `referral_link_clicks` INT UNSIGNED DEFAULT 0,
  `referral_conversions` INT UNSIGNED DEFAULT 0,
  `conversion_rate` DECIMAL(5,2) DEFAULT 0.00,
  `total_clients_recruited` INT UNSIGNED DEFAULT 0,
  `active_clients` INT UNSIGNED DEFAULT 0,
  `avg_client_value` DECIMAL(15,2) DEFAULT 0.00,
  `performance_score` DECIMAL(5,2) DEFAULT 0.00 COMMENT 'Auto-calculated 0-100',
  `rank_in_team` INT UNSIGNED,
  `rank_global` INT UNSIGNED,
  `status` ENUM('active', 'inactive', 'suspended', 'probation') DEFAULT 'active',
  `probation_reason` TEXT,
  `probation_until` DATE NULL,
  `last_activity` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `activated_at` TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE SET NULL,
  INDEX idx_tier (tier_current),
  INDEX idx_spv (spv_id),
  INDEX idx_status (status),
  INDEX idx_referral (referral_code),
  INDEX idx_performance (performance_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 20. Partner Tiers Configuration (DYNAMIC TIER RULES)
CREATE TABLE `partner_tier_config` (
  `config_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tier_level` ENUM('1', '2', '3', 'MAX') NOT NULL UNIQUE,
  `tier_name` VARCHAR(50),
  `commission_percentage` DECIMAL(5,2) NOT NULL,
  `min_orders_lifetime` INT UNSIGNED NOT NULL,
  `maintenance_orders_monthly` INT UNSIGNED DEFAULT 0,
  `benefits` JSON COMMENT 'Special benefits for this tier',
  `badge_icon` VARCHAR(255),
  `badge_color` VARCHAR(7),
  `is_active` BOOLEAN DEFAULT TRUE,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 21. Partner Tier History (AUTO-LOG tier changes)
CREATE TABLE `partner_tier_history` (
  `history_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `old_tier` ENUM('1', '2', '3', 'MAX'),
  `new_tier` ENUM('1', '2', '3', 'MAX') NOT NULL,
  `change_reason` ENUM('achieved_requirement', 'maintenance_success', 'maintenance_failed', 'manual_adjustment', 'promotion', 'demotion') NOT NULL,
  `orders_at_change` INT UNSIGNED,
  `commission_rate_old` DECIMAL(5,2),
  `commission_rate_new` DECIMAL(5,2),
  `changed_by` INT UNSIGNED COMMENT 'User ID if manual',
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 22. Partner Referrals (Track referral performance)
CREATE TABLE `partner_referrals` (
  `referral_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `referral_source` VARCHAR(100) COMMENT 'utm_source',
  `referral_medium` VARCHAR(100) COMMENT 'utm_medium',
  `referral_campaign` VARCHAR(100) COMMENT 'utm_campaign',
  `landing_page` VARCHAR(255),
  `device_type` ENUM('desktop', 'mobile', 'tablet'),
  `first_interaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `conversion_date` TIMESTAMP NULL,
  `days_to_convert` INT,
  `first_order_id` INT UNSIGNED,
  `first_order_value` DECIMAL(15,2),
  `lifetime_value` DECIMAL(15,2) DEFAULT 0.00,
  `total_orders` INT UNSIGNED DEFAULT 0,
  `is_active_client` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_client (client_id),
  INDEX idx_conversion (conversion_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 23. Partner Commissions (ALL commission records)
CREATE TABLE `partner_commissions` (
  `commission_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `commission_type` ENUM('order', 'recurring', 'bonus', 'adjustment', 'task') NOT NULL,
  `order_amount` DECIMAL(15,2) NOT NULL,
  `tier_at_time` ENUM('1', '2', '3', 'MAX') NOT NULL,
  `commission_rate` DECIMAL(5,2) NOT NULL,
  `commission_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled', 'disputed') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `payment_method` VARCHAR(50),
  `payment_reference` VARCHAR(100),
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_order (order_id),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 24. Partner Withdrawals
CREATE TABLE `partner_withdrawals` (
  `withdrawal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `withdrawal_method` ENUM('bank_transfer', 'e-wallet', 'crypto', 'other') DEFAULT 'bank_transfer',
  `bank_name` VARCHAR(100),
  `account_number` VARCHAR(50),
  `account_holder_name` VARCHAR(100),
  `status` ENUM('pending', 'approved', 'processing', 'completed', 'rejected', 'cancelled') DEFAULT 'pending',
  `admin_notes` TEXT,
  `rejection_reason` TEXT,
  `processed_by` INT UNSIGNED,
  `processed_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `transaction_reference` VARCHAR(100),
  `receipt_url` VARCHAR(255),
  `fee_amount` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_partner (partner_id),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 25. Partner Performance Monthly (AUTO-CALCULATE)
CREATE TABLE `partner_performance_monthly` (
  `performance_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  `orders_count` INT UNSIGNED DEFAULT 0,
  `revenue_generated` DECIMAL(15,2) DEFAULT 0.00,
  `commission_earned` DECIMAL(15,2) DEFAULT 0.00,
  `new_clients` INT UNSIGNED DEFAULT 0,
  `active_clients` INT UNSIGNED DEFAULT 0,
  `tier_at_month_start` ENUM('1', '2', '3', 'MAX'),
  `tier_at_month_end` ENUM('1', '2', '3', 'MAX'),
  `tier_changed` BOOLEAN DEFAULT FALSE,
  `maintenance_met` BOOLEAN DEFAULT FALSE,
  `performance_score` DECIMAL(5,2),
  `rank_in_team` INT UNSIGNED,
  `rank_global` INT UNSIGNED,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  UNIQUE KEY unique_period (partner_id, year, month),
  INDEX idx_partner (partner_id),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 26. Partner Bank Accounts
CREATE TABLE `partner_bank_accounts` (
  `bank_account_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `bank_name` VARCHAR(100) NOT NULL,
  `account_number` VARCHAR(50) NOT NULL,
  `account_holder_name` VARCHAR(100) NOT NULL,
  `bank_branch` VARCHAR(100),
  `swift_code` VARCHAR(20),
  `is_primary` BOOLEAN DEFAULT FALSE,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verification_document` VARCHAR(255),
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `status` ENUM('active', 'inactive', 'pending_verification') DEFAULT 'pending_verification',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_primary (is_primary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 27. Partner Documents
CREATE TABLE `partner_documents` (
  `document_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `document_type` ENUM('ktp', 'npwp', 'cv', 'certificate', 'contract', 'other') NOT NULL,
  `document_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `expires_at` DATE NULL,
  `notes` TEXT,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_type (document_type),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 28. Partner Penalties (AUTO-TRACK penalties)
CREATE TABLE `partner_penalties` (
  `penalty_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `penalty_type` ENUM('late_delivery', 'quality_issue', 'client_complaint', 'policy_violation', 'maintenance_fail', 'tanggungan', 'other') NOT NULL,
  `order_id` INT UNSIGNED,
  `penalty_amount` DECIMAL(15,2) DEFAULT 0.00,
  `penalty_points` INT DEFAULT 0,
  `description` TEXT NOT NULL,
  `status` ENUM('pending', 'applied', 'waived', 'disputed') DEFAULT 'pending',
  `waived_reason` TEXT,
  `issued_by` INT UNSIGNED,
  `issued_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `applied_at` TIMESTAMP NULL,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
  INDEX idx_partner (partner_id),
  INDEX idx_type (penalty_type),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 29. Partner Rewards (AUTO-GRANT rewards)
CREATE TABLE `partner_rewards` (
  `reward_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `reward_type` ENUM('milestone', 'top_performer', 'referral_bonus', 'loyalty', 'special_promo', 'other') NOT NULL,
  `reward_name` VARCHAR(100) NOT NULL,
  `reward_description` TEXT,
  `reward_value` DECIMAL(15,2) DEFAULT 0.00,
  `reward_points` INT DEFAULT 0,
  `criteria_met` JSON COMMENT 'What triggered this reward',
  `status` ENUM('pending', 'granted', 'claimed', 'expired') DEFAULT 'pending',
  `granted_at` TIMESTAMP NULL,
  `claimed_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_type (reward_type),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 30. Partner Training Progress
CREATE TABLE `partner_training_progress` (
  `progress_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `training_module_id` INT UNSIGNED NOT NULL,
  `status` ENUM('not_started', 'in_progress', 'completed', 'certified') DEFAULT 'not_started',
  `progress_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `score` DECIMAL(5,2),
  `attempts` INT DEFAULT 0,
  `time_spent_minutes` INT DEFAULT 0,
  `started_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `certificate_url` VARCHAR(255),
  `expires_at` DATE NULL,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 31. Partner Leaderboard (AUTO-UPDATE rankings)
CREATE TABLE `partner_leaderboard` (
  `leaderboard_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `period_type` ENUM('daily', 'weekly', 'monthly', 'quarterly', 'yearly', 'all_time') NOT NULL,
  `period_start` DATE NOT NULL,
  `period_end` DATE NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `rank_global` INT UNSIGNED,
  `rank_in_team` INT UNSIGNED,
  `metric_type` ENUM('orders', 'revenue', 'commission', 'clients', 'performance_score') NOT NULL,
  `metric_value` DECIMAL(15,2) NOT NULL,
  `badge` VARCHAR(50),
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  UNIQUE KEY unique_ranking (period_type, period_start, partner_id, metric_type),
  INDEX idx_partner (partner_id),
  INDEX idx_period (period_type, period_start),
  INDEX idx_rank (rank_global)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 32. Partner Chat Messages (Internal Communication)
CREATE TABLE `partner_chat_messages` (
  `message_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `from_user_id` INT UNSIGNED NOT NULL,
  `to_user_id` INT UNSIGNED NOT NULL,
  `message_type` ENUM('text', 'image', 'file', 'system') DEFAULT 'text',
  `message_content` TEXT NOT NULL,
  `file_url` VARCHAR(500),
  `is_read` BOOLEAN DEFAULT FALSE,
  `read_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_from (from_user_id),
  INDEX idx_to (to_user_id),
  INDEX idx_read (is_read),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 33. Partner Goals (Personal Goals & Tracking)
CREATE TABLE `partner_goals` (
  `goal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `partner_id` INT UNSIGNED NOT NULL,
  `goal_type` ENUM('orders', 'revenue', 'clients', 'tier_upgrade', 'custom') NOT NULL,
  `goal_name` VARCHAR(100) NOT NULL,
  `goal_description` TEXT,
  `target_value` DECIMAL(15,2) NOT NULL,
  `current_value` DECIMAL(15,2) DEFAULT 0.00,
  `progress_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `status` ENUM('active', 'achieved', 'failed', 'cancelled') DEFAULT 'active',
  `achieved_at` TIMESTAMP NULL,
  `reward_on_completion` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_partner (partner_id),
  INDEX idx_status (status),
  INDEX idx_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 4: SPV SUPERVISOR TABLES (15 TABLES) - SUPER ENHANCED
-- =====================================================

-- 34. SPV Supervisors
CREATE TABLE `spv_supervisors` (
  `spv_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `manager_id` INT UNSIGNED NULL,
  `team_name` VARCHAR(100),
  `total_partners` INT UNSIGNED DEFAULT 0,
  `active_partners` INT UNSIGNED DEFAULT 0,
  `total_clients` INT UNSIGNED DEFAULT 0,
  `team_arpu_current` DECIMAL(15,2) DEFAULT 0.00,
  `team_arpu_target` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_bonus_tier` ENUM('none', 'tier1', 'tier2', 'tier3', 'tier4') DEFAULT 'none',
  `commission_balance` DECIMAL(15,2) DEFAULT 0.00,
  `commission_pending` DECIMAL(15,2) DEFAULT 0.00,
  `commission_paid_total` DECIMAL(15,2) DEFAULT 0.00,
  `commission_lifetime` DECIMAL(15,2) DEFAULT 0.00,
  `referral_code` VARCHAR(20) UNIQUE NOT NULL,
  `performance_score` DECIMAL(5,2) DEFAULT 0.00,
  `rank_in_area` INT UNSIGNED,
  `rank_global` INT UNSIGNED,
  `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `activated_at` TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_manager (manager_id),
  INDEX idx_status (status),
  INDEX idx_referral (referral_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 35. SPV ARPU Configuration (DYNAMIC ARPU RULES)
CREATE TABLE `spv_arpu_config` (
  `config_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tier_name` VARCHAR(50) NOT NULL,
  `min_arpu` DECIMAL(15,2) NOT NULL,
  `max_arpu` DECIMAL(15,2),
  `bonus_amount` DECIMAL(15,2) NOT NULL,
  `tier_color` VARCHAR(7),
  `tier_icon` VARCHAR(100),
  `is_active` BOOLEAN DEFAULT TRUE,
  `display_order` INT DEFAULT 0,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 36. SPV ARPU Tracking (AUTO-CALCULATE monthly)
CREATE TABLE `spv_arpu_tracking` (
  `tracking_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  `total_partners` INT UNSIGNED DEFAULT 0,
  `active_partners` INT UNSIGNED DEFAULT 0,
  `total_orders` INT UNSIGNED DEFAULT 0,
  `total_revenue` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_value` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_target` DECIMAL(15,2),
  `target_achievement` DECIMAL(5,2) DEFAULT 0.00,
  `bonus_tier_achieved` ENUM('none', 'tier1', 'tier2', 'tier3', 'tier4') DEFAULT 'none',
  `bonus_amount` DECIMAL(15,2) DEFAULT 0.00,
  `base_commission` DECIMAL(15,2) DEFAULT 0.00,
  `total_earnings` DECIMAL(15,2) DEFAULT 0.00,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  UNIQUE KEY unique_period (spv_id, year, month),
  INDEX idx_spv (spv_id),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 37. SPV Commissions
CREATE TABLE `spv_commissions` (
  `commission_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `commission_type` ENUM('base', 'arpu_bonus', 'override', 'adjustment') NOT NULL,
  `order_amount` DECIMAL(15,2) NOT NULL,
  `commission_rate` DECIMAL(5,2) DEFAULT 10.00,
  `commission_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_partner (partner_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 38. SPV Bonuses (ARPU & Other bonuses)
CREATE TABLE `spv_bonuses` (
  `bonus_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `bonus_type` ENUM('arpu', 'performance', 'recruitment', 'milestone', 'special') NOT NULL,
  `year` INT,
  `month` INT CHECK (month BETWEEN 1 AND 12),
  `bonus_name` VARCHAR(100),
  `arpu_achieved` DECIMAL(15,2),
  `bonus_tier` VARCHAR(50),
  `bonus_amount` DECIMAL(15,2) NOT NULL,
  `criteria_met` JSON,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_type (bonus_type),
  INDEX idx_period (year, month),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 39. SPV Withdrawals
CREATE TABLE `spv_withdrawals` (
  `withdrawal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `withdrawal_method` ENUM('bank_transfer', 'e-wallet', 'crypto', 'other') DEFAULT 'bank_transfer',
  `bank_name` VARCHAR(100),
  `account_number` VARCHAR(50),
  `account_holder_name` VARCHAR(100),
  `status` ENUM('pending', 'approved', 'processing', 'completed', 'rejected', 'cancelled') DEFAULT 'pending',
  `admin_notes` TEXT,
  `rejection_reason` TEXT,
  `processed_by` INT UNSIGNED,
  `processed_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `transaction_reference` VARCHAR(100),
  `fee_amount` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 40. SPV Performance Monthly
CREATE TABLE `spv_performance_monthly` (
  `performance_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  `partners_start` INT UNSIGNED DEFAULT 0,
  `partners_end` INT UNSIGNED DEFAULT 0,
  `partners_added` INT UNSIGNED DEFAULT 0,
  `partners_lost` INT UNSIGNED DEFAULT 0,
  `active_partners` INT UNSIGNED DEFAULT 0,
  `total_clients` INT UNSIGNED DEFAULT 0,
  `new_clients` INT UNSIGNED DEFAULT 0,
  `orders_count` INT UNSIGNED DEFAULT 0,
  `revenue_generated` DECIMAL(15,2) DEFAULT 0.00,
  `commission_earned` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_value` DECIMAL(15,2) DEFAULT 0.00,
  `bonus_earned` DECIMAL(15,2) DEFAULT 0.00,
  `total_earnings` DECIMAL(15,2) DEFAULT 0.00,
  `performance_score` DECIMAL(5,2),
  `rank_in_area` INT UNSIGNED,
  `rank_global` INT UNSIGNED,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  UNIQUE KEY unique_period (spv_id, year, month),
  INDEX idx_spv (spv_id),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 41. SPV Team Hierarchy (Partner assignments)
CREATE TABLE `spv_team_members` (
  `member_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `assigned_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` INT UNSIGNED,
  `removed_date` TIMESTAMP NULL,
  `removed_by` INT UNSIGNED,
  `removal_reason` TEXT,
  `is_active` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_partner (partner_id),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 42. SPV Referrals
CREATE TABLE `spv_referrals` (
  `referral_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `referral_source` VARCHAR(100),
  `conversion_date` TIMESTAMP NULL,
  `first_client_date` TIMESTAMP NULL,
  `total_clients_recruited` INT UNSIGNED DEFAULT 0,
  `total_revenue_generated` DECIMAL(15,2) DEFAULT 0.00,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_partner (partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 43. SPV Leaderboard
CREATE TABLE `spv_leaderboard` (
  `leaderboard_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `period_type` ENUM('monthly', 'quarterly', 'yearly', 'all_time') NOT NULL,
  `period_start` DATE NOT NULL,
  `period_end` DATE NOT NULL,
  `spv_id` INT UNSIGNED NOT NULL,
  `rank_global` INT UNSIGNED,
  `rank_in_area` INT UNSIGNED,
  `metric_type` ENUM('arpu', 'partners', 'revenue', 'performance_score') NOT NULL,
  `metric_value` DECIMAL(15,2) NOT NULL,
  `badge` VARCHAR(50),
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  UNIQUE KEY unique_ranking (period_type, period_start, spv_id, metric_type),
  INDEX idx_spv (spv_id),
  INDEX idx_period (period_type, period_start)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 44. SPV Goals
CREATE TABLE `spv_goals` (
  `goal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `goal_type` ENUM('arpu', 'partners', 'revenue', 'team_growth', 'custom') NOT NULL,
  `goal_name` VARCHAR(100) NOT NULL,
  `target_value` DECIMAL(15,2) NOT NULL,
  `current_value` DECIMAL(15,2) DEFAULT 0.00,
  `progress_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `status` ENUM('active', 'achieved', 'failed', 'cancelled') DEFAULT 'active',
  `achieved_at` TIMESTAMP NULL,
  `reward_on_completion` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 45. SPV Team Meetings (Track team activities)
CREATE TABLE `spv_team_meetings` (
  `meeting_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `meeting_type` ENUM('team_huddle', 'training', 'performance_review', 'planning', 'other') NOT NULL,
  `meeting_title` VARCHAR(200) NOT NULL,
  `meeting_date` TIMESTAMP NOT NULL,
  `duration_minutes` INT,
  `location` VARCHAR(200),
  `meeting_notes` TEXT,
  `attendees` JSON COMMENT 'Array of partner_ids',
  `action_items` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_date (meeting_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 46. SPV Coaching Sessions
CREATE TABLE `spv_coaching_sessions` (
  `session_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `session_date` TIMESTAMP NOT NULL,
  `duration_minutes` INT,
  `topics_discussed` TEXT,
  `action_items` TEXT,
  `partner_feedback` TEXT,
  `next_session_date` TIMESTAMP NULL,
  `status` ENUM('scheduled', 'completed', 'cancelled', 'rescheduled') DEFAULT 'scheduled',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_partner (partner_id),
  INDEX idx_date (session_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 47. SPV Bank Accounts
CREATE TABLE `spv_bank_accounts` (
  `bank_account_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `bank_name` VARCHAR(100) NOT NULL,
  `account_number` VARCHAR(50) NOT NULL,
  `account_holder_name` VARCHAR(100) NOT NULL,
  `is_primary` BOOLEAN DEFAULT FALSE,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `status` ENUM('active', 'inactive', 'pending_verification') DEFAULT 'pending_verification',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 48. SPV Documents
CREATE TABLE `spv_documents` (
  `document_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `spv_id` INT UNSIGNED NOT NULL,
  `document_type` ENUM('ktp', 'npwp', 'cv', 'certificate', 'contract', 'other') NOT NULL,
  `document_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `expires_at` DATE NULL,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_spv (spv_id),
  INDEX idx_type (document_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 5: MANAGER AREA TABLES (15 TABLES)
-- =====================================================

-- 49. Manager Area Managers
CREATE TABLE `manager_area_managers` (
  `manager_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `area_name` VARCHAR(100),
  `area_code` VARCHAR(20) UNIQUE,
  `total_spv` INT UNSIGNED DEFAULT 0,
  `total_partners` INT UNSIGNED DEFAULT 0,
  `total_clients` INT UNSIGNED DEFAULT 0,
  `area_arpu_current` DECIMAL(15,2) DEFAULT 0.00,
  `area_arpu_target` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_bonus_tier` ENUM('none', 'tier1', 'tier2', 'tier3', 'tier4') DEFAULT 'none',
  `commission_balance` DECIMAL(15,2) DEFAULT 0.00,
  `commission_pending` DECIMAL(15,2) DEFAULT 0.00,
  `commission_paid_total` DECIMAL(15,2) DEFAULT 0.00,
  `commission_lifetime` DECIMAL(15,2) DEFAULT 0.00,
  `referral_code` VARCHAR(20) UNIQUE NOT NULL,
  `performance_score` DECIMAL(5,2) DEFAULT 0.00,
  `rank_global` INT UNSIGNED,
  `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `activated_at` TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_area_code (area_code),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 50. Manager ARPU Configuration
CREATE TABLE `manager_arpu_config` (
  `config_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tier_name` VARCHAR(50) NOT NULL,
  `min_arpu` DECIMAL(15,2) NOT NULL,
  `max_arpu` DECIMAL(15,2),
  `bonus_amount` DECIMAL(15,2) NOT NULL,
  `tier_color` VARCHAR(7),
  `is_active` BOOLEAN DEFAULT TRUE,
  `display_order` INT DEFAULT 0,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 51. Manager ARPU Tracking
CREATE TABLE `manager_arpu_tracking` (
  `tracking_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  `total_spv` INT UNSIGNED DEFAULT 0,
  `active_spv` INT UNSIGNED DEFAULT 0,
  `total_partners` INT UNSIGNED DEFAULT 0,
  `active_partners` INT UNSIGNED DEFAULT 0,
  `total_clients` INT UNSIGNED DEFAULT 0,
  `total_orders` INT UNSIGNED DEFAULT 0,
  `total_revenue` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_value` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_target` DECIMAL(15,2),
  `target_achievement` DECIMAL(5,2) DEFAULT 0.00,
  `bonus_tier_achieved` ENUM('none', 'tier1', 'tier2', 'tier3', 'tier4') DEFAULT 'none',
  `bonus_amount` DECIMAL(15,2) DEFAULT 0.00,
  `base_commission` DECIMAL(15,2) DEFAULT 0.00,
  `total_earnings` DECIMAL(15,2) DEFAULT 0.00,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  UNIQUE KEY unique_period (manager_id, year, month),
  INDEX idx_manager (manager_id),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 52. Manager Commissions
CREATE TABLE `manager_commissions` (
  `commission_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `spv_id` INT UNSIGNED,
  `partner_id` INT UNSIGNED,
  `order_id` INT UNSIGNED NOT NULL,
  `commission_type` ENUM('base', 'arpu_bonus', 'override', 'adjustment') NOT NULL,
  `order_amount` DECIMAL(15,2) NOT NULL,
  `commission_rate` DECIMAL(5,2) DEFAULT 5.00,
  `commission_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 53. Manager Bonuses
CREATE TABLE `manager_bonuses` (
  `bonus_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `bonus_type` ENUM('arpu', 'performance', 'recruitment', 'milestone', 'special') NOT NULL,
  `year` INT,
  `month` INT CHECK (month BETWEEN 1 AND 12),
  `bonus_name` VARCHAR(100),
  `arpu_achieved` DECIMAL(15,2),
  `bonus_tier` VARCHAR(50),
  `bonus_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_type (bonus_type),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 54. Manager Withdrawals
CREATE TABLE `manager_withdrawals` (
  `withdrawal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `withdrawal_method` ENUM('bank_transfer', 'e-wallet', 'crypto', 'other') DEFAULT 'bank_transfer',
  `bank_name` VARCHAR(100),
  `account_number` VARCHAR(50),
  `account_holder_name` VARCHAR(100),
  `status` ENUM('pending', 'approved', 'processing', 'completed', 'rejected', 'cancelled') DEFAULT 'pending',
  `processed_by` INT UNSIGNED,
  `processed_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `transaction_reference` VARCHAR(100),
  `fee_amount` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 55. Manager Performance Monthly
CREATE TABLE `manager_performance_monthly` (
  `performance_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  `spv_count` INT UNSIGNED DEFAULT 0,
  `partners_count` INT UNSIGNED DEFAULT 0,
  `clients_count` INT UNSIGNED DEFAULT 0,
  `orders_count` INT UNSIGNED DEFAULT 0,
  `revenue_generated` DECIMAL(15,2) DEFAULT 0.00,
  `commission_earned` DECIMAL(15,2) DEFAULT 0.00,
  `arpu_value` DECIMAL(15,2) DEFAULT 0.00,
  `bonus_earned` DECIMAL(15,2) DEFAULT 0.00,
  `total_earnings` DECIMAL(15,2) DEFAULT 0.00,
  `performance_score` DECIMAL(5,2),
  `rank_global` INT UNSIGNED,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  UNIQUE KEY unique_period (manager_id, year, month),
  INDEX idx_manager (manager_id),
  INDEX idx_period (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 56. Manager Area Hierarchy
CREATE TABLE `manager_area_hierarchy` (
  `hierarchy_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `spv_id` INT UNSIGNED NOT NULL,
  `assigned_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` INT UNSIGNED,
  `removed_date` TIMESTAMP NULL,
  `removed_by` INT UNSIGNED,
  `removal_reason` TEXT,
  `is_active` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_spv (spv_id),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 57. Manager Referrals
CREATE TABLE `manager_referrals` (
  `referral_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `spv_id` INT UNSIGNED NOT NULL,
  `referral_source` VARCHAR(100),
  `conversion_date` TIMESTAMP NULL,
  `total_partners_under_spv` INT UNSIGNED DEFAULT 0,
  `total_revenue_generated` DECIMAL(15,2) DEFAULT 0.00,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  FOREIGN KEY (spv_id) REFERENCES spv_supervisors(spv_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_spv (spv_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 58. Manager Leaderboard
CREATE TABLE `manager_leaderboard` (
  `leaderboard_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `period_type` ENUM('monthly', 'quarterly', 'yearly', 'all_time') NOT NULL,
  `period_start` DATE NOT NULL,
  `period_end` DATE NOT NULL,
  `manager_id` INT UNSIGNED NOT NULL,
  `rank_global` INT UNSIGNED,
  `metric_type` ENUM('arpu', 'spv_count', 'revenue', 'performance_score') NOT NULL,
  `metric_value` DECIMAL(15,2) NOT NULL,
  `badge` VARCHAR(50),
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  UNIQUE KEY unique_ranking (period_type, period_start, manager_id, metric_type),
  INDEX idx_manager (manager_id),
  INDEX idx_period (period_type, period_start)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 59. Manager Goals
CREATE TABLE `manager_goals` (
  `goal_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `goal_type` ENUM('arpu', 'spv_count', 'revenue', 'area_growth', 'custom') NOT NULL,
  `goal_name` VARCHAR(100) NOT NULL,
  `target_value` DECIMAL(15,2) NOT NULL,
  `current_value` DECIMAL(15,2) DEFAULT 0.00,
  `progress_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `status` ENUM('active', 'achieved', 'failed', 'cancelled') DEFAULT 'active',
  `achieved_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 60. Manager Bank Accounts
CREATE TABLE `manager_bank_accounts` (
  `bank_account_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `bank_name` VARCHAR(100) NOT NULL,
  `account_number` VARCHAR(50) NOT NULL,
  `account_holder_name` VARCHAR(100) NOT NULL,
  `is_primary` BOOLEAN DEFAULT FALSE,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `status` ENUM('active', 'inactive', 'pending_verification') DEFAULT 'pending_verification',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 61. Manager Documents
CREATE TABLE `manager_documents` (
  `document_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `document_type` ENUM('ktp', 'npwp', 'cv', 'certificate', 'contract', 'other') NOT NULL,
  `document_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `expires_at` DATE NULL,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_type (document_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 62. Manager Reports
CREATE TABLE `manager_reports` (
  `report_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `report_type` ENUM('monthly_summary', 'area_performance', 'spv_comparison', 'custom') NOT NULL,
  `report_title` VARCHAR(200) NOT NULL,
  `report_period_start` DATE NOT NULL,
  `report_period_end` DATE NOT NULL,
  `report_data` JSON COMMENT 'Report metrics and data',
  `file_path` VARCHAR(500),
  `generated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_type (report_type),
  INDEX idx_period (report_period_start, report_period_end)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 63. Manager Area Meetings
CREATE TABLE `manager_area_meetings` (
  `meeting_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `manager_id` INT UNSIGNED NOT NULL,
  `meeting_type` ENUM('area_review', 'strategy', 'training', 'planning', 'other') NOT NULL,
  `meeting_title` VARCHAR(200) NOT NULL,
  `meeting_date` TIMESTAMP NOT NULL,
  `duration_minutes` INT,
  `location` VARCHAR(200),
  `meeting_notes` TEXT,
  `attendees` JSON COMMENT 'Array of spv_ids',
  `action_items` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (manager_id) REFERENCES manager_area_managers(manager_id) ON DELETE CASCADE,
  INDEX idx_manager (manager_id),
  INDEX idx_date (meeting_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 6: ORDERS & SERVICES (20 TABLES)
-- =====================================================

-- 64. Services Catalog
CREATE TABLE `services` (
  `service_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `service_category_id` INT UNSIGNED NOT NULL,
  `service_code` VARCHAR(50) UNIQUE NOT NULL,
  `service_name` VARCHAR(200) NOT NULL,
  `service_slug` VARCHAR(255) UNIQUE NOT NULL,
  `short_description` TEXT,
  `long_description` TEXT,
  `price_beli_putus_per_page` DECIMAL(15,2) DEFAULT 350000.00,
  `price_sewa_per_page_per_month` DECIMAL(15,2) DEFAULT 150000.00,
  `min_sewa_duration_months` INT DEFAULT 3,
  `estimated_delivery_days` INT DEFAULT 14,
  `max_revisions` INT DEFAULT 2,
  `features` JSON COMMENT 'Array of features',
  `requirements` JSON COMMENT 'What client needs to provide',
  `deliverables` JSON COMMENT 'What will be delivered',
  `icon_url` VARCHAR(255),
  `banner_url` VARCHAR(255),
  `gallery_images` JSON,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `is_popular` BOOLEAN DEFAULT FALSE,
  `is_new` BOOLEAN DEFAULT FALSE,
  `display_order` INT DEFAULT 0,
  `total_orders` INT UNSIGNED DEFAULT 0,
  `avg_rating` DECIMAL(3,2) DEFAULT 0.00,
  `total_reviews` INT UNSIGNED DEFAULT 0,
  `status` ENUM('active', 'inactive', 'coming_soon') DEFAULT 'active',
  `seo_title` VARCHAR(200),
  `seo_description` TEXT,
  `seo_keywords` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (service_category_id) REFERENCES service_categories(category_id),
  INDEX idx_category (service_category_id),
  INDEX idx_slug (service_slug),
  INDEX idx_status (status),
  INDEX idx_featured (is_featured),
  INDEX idx_popular (is_popular),
  FULLTEXT idx_search (service_name, short_description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 65. Service Categories
CREATE TABLE `service_categories` (
  `category_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `parent_id` INT UNSIGNED NULL,
  `category_name` VARCHAR(100) NOT NULL,
  `category_slug` VARCHAR(150) UNIQUE NOT NULL,
  `category_description` TEXT,
  `category_icon` VARCHAR(100),
  `category_color` VARCHAR(7),
  `display_order` INT DEFAULT 0,
  `total_services` INT UNSIGNED DEFAULT 0,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES service_categories(category_id) ON DELETE SET NULL,
  INDEX idx_parent (parent_id),
  INDEX idx_slug (category_slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 66. Service Add-ons
CREATE TABLE `service_addons` (
  `addon_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `addon_name` VARCHAR(100) NOT NULL,
  `addon_description` TEXT,
  `addon_price` DECIMAL(15,2) NOT NULL,
  `addon_type` ENUM('one_time', 'recurring') DEFAULT 'one_time',
  `is_active` BOOLEAN DEFAULT TRUE,
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 67. Service Addon Relations
CREATE TABLE `service_addon_relations` (
  `relation_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `service_id` INT UNSIGNED NOT NULL,
  `addon_id` INT UNSIGNED NOT NULL,
  `is_default` BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE,
  FOREIGN KEY (addon_id) REFERENCES service_addons(addon_id) ON DELETE CASCADE,
  UNIQUE KEY unique_relation (service_id, addon_id),
  INDEX idx_service (service_id),
  INDEX idx_addon (addon_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 68. Packages (Bundles)
CREATE TABLE `packages` (
  `package_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `package_name` VARCHAR(100) NOT NULL,
  `package_slug` VARCHAR(150) UNIQUE NOT NULL,
  `package_tagline` VARCHAR(200),
  `package_description` TEXT,
  `total_price` DECIMAL(15,2) NOT NULL,
  `discount_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `final_price` DECIMAL(15,2) NOT NULL,
  `savings_amount` DECIMAL(15,2) DEFAULT 0.00,
  `package_features` JSON,
  `package_image` VARCHAR(255),
  `is_featured` BOOLEAN DEFAULT FALSE,
  `display_order` INT DEFAULT 0,
  `total_orders` INT UNSIGNED DEFAULT 0,
  `status` ENUM('active', 'inactive') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_slug (package_slug),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 69. Package Items
CREATE TABLE `package_items` (
  `item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `package_id` INT UNSIGNED NOT NULL,
  `service_id` INT UNSIGNED NOT NULL,
  `quantity` INT DEFAULT 1,
  `item_price` DECIMAL(15,2),
  `display_order` INT DEFAULT 0,
  FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE,
  INDEX idx_package (package_id),
  INDEX idx_service (service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 70. Orders
CREATE TABLE `orders` (
  `order_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_number` VARCHAR(50) UNIQUE NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NULL,
  `service_id` INT UNSIGNED NULL,
  `package_id` INT UNSIGNED NULL,
  `order_type` ENUM('beli_putus', 'sewa') NOT NULL,
  `order_source` ENUM('website', 'direct', 'referral', 'demo_conversion') DEFAULT 'website',
  `total_pages` INT UNSIGNED DEFAULT 1,
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount_amount` DECIMAL(15,2) DEFAULT 0.00,
  `tax_amount` DECIMAL(15,2) DEFAULT 0.00,
  `total_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('draft', 'pending', 'payment_pending', 'paid', 'in_progress', 'review', 'revision', 'testing', 'completed', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
  `payment_status` ENUM('unpaid', 'partial', 'paid', 'refunded') DEFAULT 'unpaid',
  `assigned_to` INT UNSIGNED NULL COMMENT 'Internal team member',
  `priority` ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
  `deadline` DATE NULL,
  `estimated_completion` DATE NULL,
  `actual_completion` DATE NULL,
  `client_brief` TEXT,
  `admin_notes` TEXT,
  `cancellation_reason` TEXT,
  `refund_amount` DECIMAL(15,2),
  `refund_reason` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `paid_at` TIMESTAMP NULL,
  `started_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `delivered_at` TIMESTAMP NULL,
  `cancelled_at` TIMESTAMP NULL,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE SET NULL,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE SET NULL,
  FOREIGN KEY (package_id) REFERENCES packages(package_id) ON DELETE SET NULL,
  FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_order_number (order_number),
  INDEX idx_client (client_id),
  INDEX idx_partner (partner_id),
  INDEX idx_status (status),
  INDEX idx_payment_status (payment_status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 71. Order Items
CREATE TABLE `order_items` (
  `item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `item_type` ENUM('service', 'addon', 'custom') NOT NULL,
  `service_id` INT UNSIGNED NULL,
  `addon_id` INT UNSIGNED NULL,
  `item_name` VARCHAR(200) NOT NULL,
  `item_description` TEXT,
  `quantity` INT DEFAULT 1,
  `unit_price` DECIMAL(15,2) NOT NULL,
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount` DECIMAL(15,2) DEFAULT 0.00,
  `total` DECIMAL(15,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE SET NULL,
  FOREIGN KEY (addon_id) REFERENCES service_addons(addon_id) ON DELETE SET NULL,
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 72. Order Status History (AUTO-LOG)
CREATE TABLE `order_status_history` (
  `history_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `old_status` VARCHAR(50),
  `new_status` VARCHAR(50) NOT NULL,
  `changed_by` INT UNSIGNED,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_order (order_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 73. Order Requirements (Files uploaded by client)
CREATE TABLE `order_requirements` (
  `requirement_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `requirement_type` ENUM('logo', 'content', 'reference', 'document', 'other') NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `notes` TEXT,
  `uploaded_by` INT UNSIGNED,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 74. Order Deliverables (Files delivered to client)
CREATE TABLE `order_deliverables` (
  `deliverable_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `deliverable_type` ENUM('source_code', 'database', 'documentation', 'design_files', 'other') NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `description` TEXT,
  `version` VARCHAR(20) DEFAULT '1.0',
  `uploaded_by` INT UNSIGNED,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `download_count` INT UNSIGNED DEFAULT 0,
  `last_downloaded_at` TIMESTAMP NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 75. Order Revisions
CREATE TABLE `order_revisions` (
  `revision_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `revision_number` INT NOT NULL,
  `requested_by` INT UNSIGNED NOT NULL,
  `revision_details` TEXT NOT NULL,
  `status` ENUM('pending', 'in_progress', 'completed', 'rejected') DEFAULT 'pending',
  `completed_at` TIMESTAMP NULL,
  `response_notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 76. Order Timeline (Visual tracking)
CREATE TABLE `order_timeline` (
  `timeline_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `event_type` ENUM('created', 'paid', 'assigned', 'started', 'milestone', 'revision', 'testing', 'completed', 'delivered', 'cancelled') NOT NULL,
  `event_title` VARCHAR(200) NOT NULL,
  `event_description` TEXT,
  `event_icon` VARCHAR(50),
  `event_color` VARCHAR(7),
  `created_by` INT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 77. Order Comments (Internal & Client communication)
CREATE TABLE `order_comments` (
  `comment_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `comment_text` TEXT NOT NULL,
  `is_internal` BOOLEAN DEFAULT FALSE COMMENT 'Only visible to team',
  `is_pinned` BOOLEAN DEFAULT FALSE,
  `parent_comment_id` BIGINT UNSIGNED NULL COMMENT 'For replies',
  `attachments` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES order_comments(comment_id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_user (user_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 78. Order Recurring (For Sewa subscription)
CREATE TABLE `order_recurring` (
  `recurring_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `parent_order_id` INT UNSIGNED NOT NULL COMMENT 'Original order',
  `billing_cycle` ENUM('monthly', 'quarterly', 'yearly') DEFAULT 'monthly',
  `billing_amount` DECIMAL(15,2) NOT NULL,
  `next_billing_date` DATE NOT NULL,
  `total_cycles` INT UNSIGNED COMMENT 'Total paid cycles',
  `remaining_cycles` INT UNSIGNED COMMENT 'If contract has end',
  `auto_renew` BOOLEAN DEFAULT TRUE,
  `payment_method` VARCHAR(50),
  `status` ENUM('active', 'paused', 'cancelled', 'expired') DEFAULT 'active',
  `cancelled_at` TIMESTAMP NULL,
  `cancellation_reason` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_parent (parent_order_id),
  INDEX idx_next_billing (next_billing_date),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 79. Order Tags
CREATE TABLE `order_tags` (
  `tag_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tag_name` VARCHAR(50) NOT NULL UNIQUE,
  `tag_color` VARCHAR(7),
  `usage_count` INT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 80. Order Tag Relations
CREATE TABLE `order_tag_relations` (
  `relation_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `tag_id` INT UNSIGNED NOT NULL,
  `tagged_by` INT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES order_tags(tag_id) ON DELETE CASCADE,
  UNIQUE KEY unique_tag (order_id, tag_id),
  INDEX idx_order (order_id),
  INDEX idx_tag (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 81. Order Milestones
CREATE TABLE `order_milestones` (
  `milestone_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `milestone_name` VARCHAR(200) NOT NULL,
  `milestone_description` TEXT,
  `milestone_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `due_date` DATE,
  `completed_date` DATE NULL,
  `status` ENUM('pending', 'in_progress', 'completed', 'delayed') DEFAULT 'pending',
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 82. Order SLA Tracking (Service Level Agreement)
CREATE TABLE `order_sla_tracking` (
  `sla_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `sla_type` ENUM('response_time', 'delivery_time', 'revision_time', 'support_time') NOT NULL,
  `target_hours` INT NOT NULL,
  `actual_hours` INT,
  `deadline` TIMESTAMP NOT NULL,
  `completed_at` TIMESTAMP NULL,
  `is_met` BOOLEAN,
  `breach_reason` TEXT,
  `calculated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_type (sla_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 83. Order Quality Checks
CREATE TABLE `order_quality_checks` (
  `check_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `check_type` ENUM('code_review', 'design_review', 'functionality', 'security', 'performance', 'seo') NOT NULL,
  `checked_by` INT UNSIGNED NOT NULL,
  `check_status` ENUM('pass', 'fail', 'needs_improvement') NOT NULL,
  `score` DECIMAL(3,2) COMMENT 'Out of 5.00',
  `findings` TEXT,
  `recommendations` TEXT,
  `checked_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (checked_by) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_order (order_id),
  INDEX idx_type (check_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 7: PAYMENTS & INVOICES (15 TABLES)
-- =====================================================

-- 84. Payments
CREATE TABLE `payments` (
  `payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `payment_number` VARCHAR(50) UNIQUE NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `payment_method` ENUM('bank_transfer', 'qris', 'credit_card', 'e-wallet', 'crypto', 'cash', 'other') NOT NULL,
  `payment_gateway` VARCHAR(50),
  `amount_paid` DECIMAL(15,2) NOT NULL,
  `payment_fee` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2) NOT NULL,
  `payment_proof` VARCHAR(500) COMMENT 'Upload bukti transfer',
  `sender_name` VARCHAR(100),
  `sender_bank` VARCHAR(100),
  `sender_account` VARCHAR(50),
  `transfer_date` DATE,
  `status` ENUM('pending', 'verified', 'rejected', 'refunded') DEFAULT 'pending',
  `verified_by` INT UNSIGNED,
  `verified_at` TIMESTAMP NULL,
  `rejection_reason` TEXT,
  `refund_amount` DECIMAL(15,2),
  `refund_date` DATE,
  `refund_reason` TEXT,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_order (order_id),
  INDEX idx_client (client_id),
  INDEX idx_status (status),
  INDEX idx_payment_number (payment_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 85. Payment Methods Configuration
CREATE TABLE `payment_methods_config` (
  `method_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `method_type` ENUM('bank_transfer', 'qris', 'e-wallet', 'payment_gateway') NOT NULL,
  `method_name` VARCHAR(100) NOT NULL,
  `provider_name` VARCHAR(100),
  `account_number` VARCHAR(100),
  `account_holder` VARCHAR(100),
  `qr_code_image` VARCHAR(500),
  `api_key` VARCHAR(255),
  `api_secret` VARCHAR(255),
  `webhook_url` VARCHAR(500),
  `transaction_fee_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `transaction_fee_fixed` DECIMAL(15,2) DEFAULT 0.00,
  `min_amount` DECIMAL(15,2),
  `max_amount` DECIMAL(15,2),
  `is_active` BOOLEAN DEFAULT TRUE,
  `display_order` INT DEFAULT 0,
  `instructions` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_type (method_type),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 86. Invoices
CREATE TABLE `invoices` (
  `invoice_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `invoice_number` VARCHAR(50) UNIQUE NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `invoice_type` ENUM('order', 'recurring', 'adjustment', 'refund') DEFAULT 'order',
  `issue_date` DATE NOT NULL,
  `due_date` DATE NOT NULL,
  `payment_terms` VARCHAR(100) DEFAULT 'Due upon receipt',
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount_amount` DECIMAL(15,2) DEFAULT 0.00,
  `tax_amount` DECIMAL(15,2) DEFAULT 0.00,
  `total_amount` DECIMAL(15,2) NOT NULL,
  `amount_paid` DECIMAL(15,2) DEFAULT 0.00,
  `amount_due` DECIMAL(15,2) NOT NULL,
  `status` ENUM('draft', 'sent', 'viewed', 'partial', 'paid', 'overdue', 'cancelled', 'refunded') DEFAULT 'draft',
  `sent_at` TIMESTAMP NULL,
  `viewed_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `notes` TEXT,
  `terms_conditions` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_invoice_number (invoice_number),
  INDEX idx_order (order_id),
  INDEX idx_client (client_id),
  INDEX idx_status (status),
  INDEX idx_due_date (due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 87. Invoice Items
CREATE TABLE `invoice_items` (
  `item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `invoice_id` INT UNSIGNED NOT NULL,
  `item_description` TEXT NOT NULL,
  `quantity` INT DEFAULT 1,
  `unit_price` DECIMAL(15,2) NOT NULL,
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount` DECIMAL(15,2) DEFAULT 0.00,
  `tax` DECIMAL(15,2) DEFAULT 0.00,
  `total` DECIMAL(15,2) NOT NULL,
  `display_order` INT DEFAULT 0,
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
  INDEX idx_invoice (invoice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 88. Invoice Payments (Track partial payments)
CREATE TABLE `invoice_payments` (
  `invoice_payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `invoice_id` INT UNSIGNED NOT NULL,
  `payment_id` INT UNSIGNED NOT NULL,
  `amount_applied` DECIMAL(15,2) NOT NULL,
  `applied_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
  FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE,
  INDEX idx_invoice (invoice_id),
  INDEX idx_payment (payment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 89. Quotes (Pre-Order Estimates)
CREATE TABLE `quotes` (
  `quote_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `quote_number` VARCHAR(50) UNIQUE NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `prepared_by` INT UNSIGNED NOT NULL,
  `quote_title` VARCHAR(200) NOT NULL,
  `quote_description` TEXT,
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `discount_amount` DECIMAL(15,2) DEFAULT 0.00,
  `tax_amount` DECIMAL(15,2) DEFAULT 0.00,
  `total_amount` DECIMAL(15,2) NOT NULL,
  `valid_until` DATE NOT NULL,
  `status` ENUM('draft', 'sent', 'viewed', 'accepted', 'rejected', 'expired', 'converted') DEFAULT 'draft',
  `converted_to_order_id` INT UNSIGNED NULL,
  `rejection_reason` TEXT,
  `notes` TEXT,
  `terms_conditions` TEXT,
  `sent_at` TIMESTAMP NULL,
  `viewed_at` TIMESTAMP NULL,
  `responded_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (prepared_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (converted_to_order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
  INDEX idx_quote_number (quote_number),
  INDEX idx_client (client_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 90. Quote Items
CREATE TABLE `quote_items` (
  `item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `quote_id` INT UNSIGNED NOT NULL,
  `service_id` INT UNSIGNED NULL,
  `item_description` TEXT NOT NULL,
  `quantity` INT DEFAULT 1,
  `unit_price` DECIMAL(15,2) NOT NULL,
  `subtotal` DECIMAL(15,2) NOT NULL,
  `discount` DECIMAL(15,2) DEFAULT 0.00,
  `total` DECIMAL(15,2) NOT NULL,
  `display_order` INT DEFAULT 0,
  FOREIGN KEY (quote_id) REFERENCES quotes(quote_id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE SET NULL,
  INDEX idx_quote (quote_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 91. Refunds
CREATE TABLE `refunds` (
  `refund_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `refund_number` VARCHAR(50) UNIQUE NOT NULL,
  `payment_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `refund_amount` DECIMAL(15,2) NOT NULL,
  `refund_reason` TEXT NOT NULL,
  `refund_method` ENUM('original_payment', 'bank_transfer', 'store_credit', 'other') DEFAULT 'original_payment',
  `bank_name` VARCHAR(100),
  `account_number` VARCHAR(50),
  `account_holder` VARCHAR(100),
  `status` ENUM('requested', 'approved', 'processing', 'completed', 'rejected') DEFAULT 'requested',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `processed_by` INT UNSIGNED,
  `processed_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `rejection_reason` TEXT,
  `transaction_reference` VARCHAR(100),
  `admin_notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_refund_number (refund_number),
  INDEX idx_payment (payment_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 92. Discounts & Coupons
CREATE TABLE `discounts` (
  `discount_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `discount_code` VARCHAR(50) UNIQUE NOT NULL,
  `discount_name` VARCHAR(100) NOT NULL,
  `discount_type` ENUM('percentage', 'fixed_amount', 'free_service') NOT NULL,
  `discount_value` DECIMAL(15,2) NOT NULL,
  `max_discount_amount` DECIMAL(15,2),
  `min_order_amount` DECIMAL(15,2) DEFAULT 0.00,
  `applicable_to` ENUM('all', 'specific_services', 'specific_categories', 'specific_clients') DEFAULT 'all',
  `applicable_ids` JSON COMMENT 'Array of service_ids or client_ids',
  `usage_limit_total` INT UNSIGNED,
  `usage_limit_per_client` INT DEFAULT 1,
  `usage_count` INT UNSIGNED DEFAULT 0,
  `valid_from` TIMESTAMP NOT NULL,
  `valid_until` TIMESTAMP NOT NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_by` INT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_code (discount_code),
  INDEX idx_active (is_active),
  INDEX idx_valid (valid_from, valid_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 93. Discount Usage Log
CREATE TABLE `discount_usage_log` (
  `usage_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `discount_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `discount_amount` DECIMAL(15,2) NOT NULL,
  `used_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (discount_id) REFERENCES discounts(discount_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  INDEX idx_discount (discount_id),
  INDEX idx_client (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 94. Tax Rates
CREATE TABLE `tax_rates` (
  `tax_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tax_name` VARCHAR(100) NOT NULL,
  `tax_code` VARCHAR(20) UNIQUE NOT NULL,
  `tax_rate` DECIMAL(5,2) NOT NULL,
  `tax_type` ENUM('percentage', 'fixed') DEFAULT 'percentage',
  `applicable_to` ENUM('all', 'services', 'location') DEFAULT 'all',
  `country` VARCHAR(2),
  `province` VARCHAR(100),
  `is_default` BOOLEAN DEFAULT FALSE,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 95. Payment Gateways Integration
CREATE TABLE `payment_gateways` (
  `gateway_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `gateway_name` VARCHAR(100) NOT NULL,
  `gateway_code` VARCHAR(50) UNIQUE NOT NULL,
  `gateway_type` ENUM('bank_transfer', 'e-wallet', 'credit_card', 'qris', 'crypto') NOT NULL,
  `provider` VARCHAR(100),
  `api_endpoint` VARCHAR(500),
  `api_key` VARCHAR(255),
  `api_secret` VARCHAR(255),
  `merchant_id` VARCHAR(100),
  `webhook_url` VARCHAR(500),
  `webhook_secret` VARCHAR(255),
  `transaction_fee_percentage` DECIMAL(5,2) DEFAULT 0.00,
  `transaction_fee_fixed` DECIMAL(15,2) DEFAULT 0.00,
  `settings` JSON COMMENT 'Gateway-specific settings',
  `is_sandbox` BOOLEAN DEFAULT FALSE,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (gateway_code),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 96. Payment Gateway Transactions (AUTO-LOG)
CREATE TABLE `payment_gateway_transactions` (
  `transaction_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `gateway_id` INT UNSIGNED NOT NULL,
  `payment_id` INT UNSIGNED NULL,
  `order_id` INT UNSIGNED NULL,
  `transaction_reference` VARCHAR(255) UNIQUE NOT NULL,
  `external_transaction_id` VARCHAR(255),
  `transaction_type` ENUM('payment', 'refund', 'chargeback') NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `fee` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2) NOT NULL,
  `currency` VARCHAR(3) DEFAULT 'IDR',
  `status` ENUM('pending', 'processing', 'success', 'failed', 'cancelled') NOT NULL,
  `status_message` TEXT,
  `request_payload` JSON,
  `response_payload` JSON,
  `webhook_payload` JSON,
  `customer_email` VARCHAR(100),
  `customer_phone` VARCHAR(20),
  `ip_address` VARCHAR(45),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (gateway_id) REFERENCES payment_gateways(gateway_id),
  FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE SET NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
  INDEX idx_gateway (gateway_id),
  INDEX idx_payment (payment_id),
  INDEX idx_reference (transaction_reference),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 97. Credit Notes (For refunds/adjustments)
CREATE TABLE `credit_notes` (
  `credit_note_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `credit_note_number` VARCHAR(50) UNIQUE NOT NULL,
  `invoice_id` INT UNSIGNED NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `credit_amount` DECIMAL(15,2) NOT NULL,
  `reason` TEXT NOT NULL,
  `credit_type` ENUM('refund', 'adjustment', 'goodwill', 'error_correction') NOT NULL,
  `status` ENUM('draft', 'issued', 'applied', 'expired') DEFAULT 'draft',
  `valid_until` DATE,
  `applied_to_invoice_id` INT UNSIGNED NULL,
  `applied_at` TIMESTAMP NULL,
  `notes` TEXT,
  `issued_by` INT UNSIGNED,
  `issued_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE SET NULL,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (applied_to_invoice_id) REFERENCES invoices(invoice_id) ON DELETE SET NULL,
  INDEX idx_credit_note_number (credit_note_number),
  INDEX idx_client (client_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 98. Store Credit (Client wallet/balance)
CREATE TABLE `store_credits` (
  `credit_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NOT NULL,
  `current_balance` DECIMAL(15,2) DEFAULT 0.00,
  `lifetime_earned` DECIMAL(15,2) DEFAULT 0.00,
  `lifetime_spent` DECIMAL(15,2) DEFAULT 0.00,
  `expires_at` DATE NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  UNIQUE KEY unique_client (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 8: DEMO REQUESTS (5 TABLES)
-- =====================================================

-- 99. Demo Requests (26 FIELDS!)
CREATE TABLE `demo_requests` (
  `demo_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `demo_number` VARCHAR(50) UNIQUE NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NULL,
  
  -- SECTION 1: Business Info (4 fields)
  `field_01_nama_bisnis` VARCHAR(100) NOT NULL,
  `field_02_jenis_usaha` VARCHAR(100) NOT NULL,
  `field_03_target_market` TEXT,
  `field_04_lokasi` VARCHAR(100),
  
  -- SECTION 2: Existing Assets (3 fields)
  `field_05_website_existing` VARCHAR(255),
  `field_11_logo_existing` VARCHAR(255),
  `field_17_domain_existing` VARCHAR(100),
  
  -- SECTION 3: Budget & Timeline (3 fields)
  `field_06_budget` VARCHAR(50),
  `field_07_timeline` VARCHAR(50),
  `field_25_deadline_launch` DATE,
  
  -- SECTION 4: Features (7 fields)
  `field_08_fitur_utama` TEXT,
  `field_13_jumlah_halaman` INT UNSIGNED,
  `field_14_bahasa` ENUM('indonesia', 'english', 'both'),
  `field_15_payment_gateway` ENUM('ya', 'tidak'),
  `field_21_mobile_app` ENUM('ya', 'tidak', 'nanti'),
  `field_18_seo_priority` ENUM('low', 'medium', 'high'),
  `field_20_email_marketing` ENUM('ya', 'tidak'),
  
  -- SECTION 5: Design (3 fields)
  `field_09_referensi_website` TEXT,
  `field_10_warna_brand` VARCHAR(100),
  `field_12_konten_ready` ENUM('ya', 'tidak', 'sebagian'),
  
  -- SECTION 6: Technical (3 fields)
  `field_16_hosting_preference` ENUM('shared', 'vps', 'cloud'),
  `field_19_social_media` TEXT,
  `field_23_competitor_websites` TEXT,
  
  -- SECTION 7: Additional (3 fields)
  `field_22_special_request` TEXT,
  `field_24_unique_selling_point` TEXT,
  `field_26_additional_notes` TEXT,
  
  -- Status & Review
  `status` ENUM('pending', 'reviewing', 'approved', 'rejected', 'demo_sent', 'converted') DEFAULT 'pending',
  `priority` ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
  `reviewed_by` INT UNSIGNED NULL,
  `reviewed_at` TIMESTAMP NULL,
  `demo_link` VARCHAR(255),
  `demo_sent_at` TIMESTAMP NULL,
  `rejection_reason` TEXT,
  `admin_notes` TEXT,
  `converted_to_order_id` INT UNSIGNED NULL,
  `converted_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (partner_id) REFERENCES partners(partner_id) ON DELETE SET NULL,
  FOREIGN KEY (converted_to_order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
  INDEX idx_demo_number (demo_number),
  INDEX idx_client (client_id),
  INDEX idx_partner (partner_id),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 100. Demo Request Files
CREATE TABLE `demo_request_files` (
  `file_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `demo_id` INT UNSIGNED NOT NULL,
  `file_type` ENUM('logo', 'reference', 'document', 'other') NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (demo_id) REFERENCES demo_requests(demo_id) ON DELETE CASCADE,
  INDEX idx_demo (demo_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 101. Demo Websites (Actual demo outputs)
CREATE TABLE `demo_websites` (
  `demo_website_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `demo_request_id` INT UNSIGNED NULL,
  `demo_category` VARCHAR(100) NOT NULL,
  `demo_name` VARCHAR(200) NOT NULL,
  `demo_slug` VARCHAR(255) UNIQUE NOT NULL,
  `demo_url` VARCHAR(500) NOT NULL,
  `demo_preview_image` VARCHAR(500),
  `demo_description` TEXT,
  `demo_features` JSON,
  `technologies_used` JSON,
  `is_template` BOOLEAN DEFAULT FALSE,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `view_count` INT UNSIGNED DEFAULT 0,
  `conversion_count` INT UNSIGNED DEFAULT 0 COMMENT 'How many became orders',
  `status` ENUM('active', 'maintenance', 'archived') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (demo_request_id) REFERENCES demo_requests(demo_id) ON DELETE SET NULL,
  INDEX idx_category (demo_category),
  INDEX idx_slug (demo_slug),
  INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 102. Demo Feedback
CREATE TABLE `demo_feedback` (
  `feedback_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `demo_request_id` INT UNSIGNED NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `satisfaction_rating` TINYINT CHECK (satisfaction_rating BETWEEN 1 AND 5),
  `design_rating` TINYINT CHECK (design_rating BETWEEN 1 AND 5),
  `functionality_rating` TINYINT CHECK (functionality_rating BETWEEN 1 AND 5),
  `feedback_text` TEXT,
  `will_proceed_to_order` ENUM('yes', 'no', 'maybe') DEFAULT 'maybe',
  `reasons_if_no` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (demo_request_id) REFERENCES demo_requests(demo_id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  INDEX idx_demo (demo_request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 103. Demo Templates (Reusable demo templates)
CREATE TABLE `demo_templates` (
  `template_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `template_name` VARCHAR(200) NOT NULL,
  `template_category` VARCHAR(100) NOT NULL,
  `template_description` TEXT,
  `template_preview` VARCHAR(500),
  `source_files_path` VARCHAR(500),
  `customizable_fields` JSON,
  `usage_count` INT UNSIGNED DEFAULT 0,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_category (template_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 9: TASKS & TASK BOARD (6 TABLES)
-- =====================================================

-- 104. Tasks
CREATE TABLE `tasks` (
  `task_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `task_number` VARCHAR(50) UNIQUE NOT NULL,
  `task_title` VARCHAR(200) NOT NULL,
  `task_description` TEXT NOT NULL,
  `task_category` ENUM('coding', 'design', 'content', 'marketing', 'seo', 'other') NOT NULL,
  `task_type` ENUM('one_time', 'recurring') DEFAULT 'one_time',
  `difficulty_level` ENUM('easy', 'medium', 'hard', 'expert') DEFAULT 'medium',
  `commission_amount` DECIMAL(15,2) NOT NULL,
  `estimated_hours` DECIMAL(5,2),
  `required_skills` JSON,
  `deliverables_required` JSON,
  `instructions` TEXT,
  `max_takers` INT DEFAULT 1 COMMENT 'How many can take this task',
  `taken_count` INT DEFAULT 0,
  `deadline` DATE NULL,
  `status` ENUM('draft', 'open', 'reserved', 'in_progress', 'submitted', 'completed', 'cancelled') DEFAULT 'draft',
  `priority` ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
  `posted_by` INT UNSIGNED NOT NULL,
  `posted_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_task_number (task_number),
  INDEX idx_status (status),
  INDEX idx_category (task_category),
  INDEX idx_deadline (deadline)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 105. Task Assignments
CREATE TABLE `task_assignments` (
  `assignment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT UNSIGNED NOT NULL,
  `assigned_to_user_id` INT UNSIGNED NOT NULL,
  `assigned_to_role` ENUM('partner', 'spv') NOT NULL,
  `status` ENUM('reserved', 'working', 'submitted', 'revision', 'completed', 'rejected', 'cancelled') DEFAULT 'reserved',
  `taken_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `started_at` TIMESTAMP NULL,
  `submitted_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  `cancelled_at` TIMESTAMP NULL,
  `cancellation_reason` TEXT,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_to_user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_task (task_id),
  INDEX idx_user (assigned_to_user_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 106. Task Submissions
CREATE TABLE `task_submissions` (
  `submission_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `assignment_id` INT UNSIGNED NOT NULL,
  `submission_notes` TEXT NOT NULL,
  `submission_files` JSON COMMENT 'Array of file paths',
  `time_spent_hours` DECIMAL(5,2),
  `status` ENUM('pending_review', 'approved', 'rejected', 'needs_revision') DEFAULT 'pending_review',
  `reviewed_by` INT UNSIGNED,
  `reviewed_at` TIMESTAMP NULL,
  `review_notes` TEXT,
  `quality_score` DECIMAL(3,2) COMMENT 'Out of 5.00',
  `revision_requested` BOOLEAN DEFAULT FALSE,
  `revision_notes` TEXT,
  `resubmission_deadline` DATE NULL,
  `submitted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (assignment_id) REFERENCES task_assignments(assignment_id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_assignment (assignment_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 107. Task Comments
CREATE TABLE `task_comments` (
  `comment_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `comment_text` TEXT NOT NULL,
  `is_internal` BOOLEAN DEFAULT FALSE,
  `parent_comment_id` BIGINT UNSIGNED NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES task_comments(comment_id) ON DELETE CASCADE,
  INDEX idx_task (task_id),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 108. Task Files
CREATE TABLE `task_files` (
  `file_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT UNSIGNED NULL,
  `assignment_id` INT UNSIGNED NULL,
  `submission_id` INT UNSIGNED NULL,
  `file_type` ENUM('instruction', 'reference', 'deliverable', 'revision') NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `uploaded_by` INT UNSIGNED,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES task_assignments(assignment_id) ON DELETE CASCADE,
  FOREIGN KEY (submission_id) REFERENCES task_submissions(submission_id) ON DELETE CASCADE,
  INDEX idx_task (task_id),
  INDEX idx_assignment (assignment_id),
  INDEX idx_submission (submission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 109. Task Payment (Commission for completed tasks)
CREATE TABLE `task_payments` (
  `payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `task_id` INT UNSIGNED NOT NULL,
  `assignment_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `commission_amount` DECIMAL(15,2) NOT NULL,
  `bonus_amount` DECIMAL(15,2) DEFAULT 0.00,
  `total_amount` DECIMAL(15,2) NOT NULL,
  `status` ENUM('pending', 'approved', 'paid', 'cancelled') DEFAULT 'pending',
  `approved_by` INT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `paid_at` TIMESTAMP NULL,
  `payment_reference` VARCHAR(100),
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES task_assignments(assignment_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_task (task_id),
  INDEX idx_user (user_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 10: CMS & CONTENT (5 TABLES)
-- =====================================================

-- 110. Blog Posts
CREATE TABLE `blog_posts` (
  `post_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `post_title` VARCHAR(200) NOT NULL,
  `post_slug` VARCHAR(255) UNIQUE NOT NULL,
  `post_excerpt` TEXT,
  `post_content` LONGTEXT NOT NULL,
  `featured_image` VARCHAR(500),
  `author_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED,
  `tags` JSON,
  `view_count` INT UNSIGNED DEFAULT 0,
  `like_count` INT UNSIGNED DEFAULT 0,
  `comment_count` INT UNSIGNED DEFAULT 0,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `status` ENUM('draft', 'published', 'scheduled', 'archived') DEFAULT 'draft',
  `published_at` TIMESTAMP NULL,
  `seo_title` VARCHAR(200),
  `seo_description` TEXT,
  `seo_keywords` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_slug (post_slug),
  INDEX idx_author (author_id),
  INDEX idx_category (category_id),
  INDEX idx_status (status),
  INDEX idx_published (published_at),
  FULLTEXT idx_search (post_title, post_content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 111. Blog Categories
CREATE TABLE `blog_categories` (
  `category_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `category_name` VARCHAR(100) NOT NULL,
  `category_slug` VARCHAR(150) UNIQUE NOT NULL,
  `category_description` TEXT,
  `parent_id` INT UNSIGNED NULL,
  `post_count` INT UNSIGNED DEFAULT 0,
  `display_order` INT DEFAULT 0,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES blog_categories(category_id) ON DELETE SET NULL,
  INDEX idx_slug (category_slug),
  INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 112. Portfolio Items
CREATE TABLE `portfolio_items` (
  `portfolio_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `project_title` VARCHAR(200) NOT NULL,
  `project_slug` VARCHAR(255) UNIQUE NOT NULL,
  `client_name` VARCHAR(100),
  `project_category` VARCHAR(100) NOT NULL,
  `project_description` TEXT,
  `featured_image` VARCHAR(500),
  `gallery_images` JSON,
  `project_url` VARCHAR(500),
  `technologies_used` JSON,
  `project_duration` VARCHAR(50),
  `completion_date` DATE,
  `testimonial` TEXT,
  `testimonial_author` VARCHAR(100),
  `view_count` INT UNSIGNED DEFAULT 0,
  `like_count` INT UNSIGNED DEFAULT 0,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `display_order` INT DEFAULT 0,
  `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_slug (project_slug),
  INDEX idx_category (project_category),
  INDEX idx_status (status),
  INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 113. FAQs
CREATE TABLE `faqs` (
  `faq_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `faq_category` VARCHAR(100) NOT NULL,
  `question` TEXT NOT NULL,
  `answer` TEXT NOT NULL,
  `helpful_count` INT UNSIGNED DEFAULT 0,
  `not_helpful_count` INT UNSIGNED DEFAULT 0,
  `view_count` INT UNSIGNED DEFAULT 0,
  `display_order` INT DEFAULT 0,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `status` ENUM('draft', 'published', 'archived') DEFAULT 'published',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_category (faq_category),
  INDEX idx_status (status),
  FULLTEXT idx_search (question, answer)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 114. Testimonials
CREATE TABLE `testimonials` (
  `testimonial_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `client_id` INT UNSIGNED NULL,
  `client_name` VARCHAR(100) NOT NULL,
  `client_company` VARCHAR(100),
  `client_position` VARCHAR(100),
  `client_avatar` VARCHAR(500),
  `testimonial_text` TEXT NOT NULL,
  `rating` TINYINT CHECK (rating BETWEEN 1 AND 5) DEFAULT 5,
  `project_type` VARCHAR(100),
  `is_featured` BOOLEAN DEFAULT FALSE,
  `is_verified` BOOLEAN DEFAULT FALSE,
  `display_order` INT DEFAULT 0,
  `status` ENUM('pending', 'approved', 'rejected', 'archived') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE SET NULL,
  INDEX idx_client (client_id),
  INDEX idx_status (status),
  INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 11: SUPPORT & TICKETS (3 TABLES)
-- =====================================================

-- 115. Support Tickets
CREATE TABLE `support_tickets` (
  `ticket_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `ticket_number` VARCHAR(50) UNIQUE NOT NULL,
  `client_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NULL,
  `subject` VARCHAR(200) NOT NULL,
  `category` ENUM('technical', 'billing', 'general', 'complaint', 'feature_request', 'other') NOT NULL,
  `priority` ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
  `status` ENUM('open', 'pending_reply', 'in_progress', 'resolved', 'closed', 'reopened') DEFAULT 'open',
  `assigned_to` INT UNSIGNED NULL,
  `first_response_at` TIMESTAMP NULL,
  `resolved_at` TIMESTAMP NULL,
  `closed_at` TIMESTAMP NULL,
  `satisfaction_rating` TINYINT CHECK (satisfaction_rating BETWEEN 1 AND 5),
  `satisfaction_comment` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
  FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_ticket_number (ticket_number),
  INDEX idx_client (client_id),
  INDEX idx_status (status),
  INDEX idx_assigned (assigned_to)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 116. Support Ticket Replies
CREATE TABLE `support_ticket_replies` (
  `reply_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `ticket_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `reply_text` TEXT NOT NULL,
  `is_internal_note` BOOLEAN DEFAULT FALSE,
  `attachments` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_ticket (ticket_id),
  INDEX idx_user (user_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 117. Support Ticket Attachments
CREATE TABLE `support_ticket_attachments` (
  `attachment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `ticket_id` INT UNSIGNED NULL,
  `reply_id` BIGINT UNSIGNED NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `uploaded_by` INT UNSIGNED,
  `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id) ON DELETE CASCADE,
  FOREIGN KEY (reply_id) REFERENCES support_ticket_replies(reply_id) ON DELETE CASCADE,
  INDEX idx_ticket (ticket_id),
  INDEX idx_reply (reply_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 12: NOTIFICATIONS (3 TABLES)
-- =====================================================

-- 118. Notifications
CREATE TABLE `notifications` (
  `notification_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `notification_type` VARCHAR(50) NOT NULL,
  `notification_title` VARCHAR(200) NOT NULL,
  `notification_message` TEXT NOT NULL,
  `notification_icon` VARCHAR(100),
  `notification_color` VARCHAR(7),
  `action_url` VARCHAR(500),
  `action_label` VARCHAR(100),
  `related_entity_type` VARCHAR(50),
  `related_entity_id` INT UNSIGNED,
  `is_read` BOOLEAN DEFAULT FALSE,
  `read_at` TIMESTAMP NULL,
  `priority` ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal',
  `expires_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_read (is_read),
  INDEX idx_type (notification_type),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 119. Notification Templates
CREATE TABLE `notification_templates` (
  `template_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `template_key` VARCHAR(100) UNIQUE NOT NULL,
  `template_name` VARCHAR(200) NOT NULL,
  `template_category` VARCHAR(100),
  `channel` ENUM('in_app', 'email', 'sms', 'push', 'all') DEFAULT 'all',
  `subject` VARCHAR(200),
  `body_template` TEXT NOT NULL,
  `variables` JSON COMMENT 'Available variables for this template',
  `icon` VARCHAR(100),
  `color` VARCHAR(7),
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_key (template_key),
  INDEX idx_channel (channel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 120. Email Queue (AUTO-SEND emails)
CREATE TABLE `email_queue` (
  `queue_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `recipient_email` VARCHAR(100) NOT NULL,
  `recipient_name` VARCHAR(100),
  `subject` VARCHAR(200) NOT NULL,
  `body_html` LONGTEXT NOT NULL,
  `body_text` TEXT,
  `from_email` VARCHAR(100),
  `from_name` VARCHAR(100),
  `reply_to` VARCHAR(100),
  `cc` TEXT,
  `bcc` TEXT,
  `attachments` JSON,
  `priority` ENUM('low', 'normal', 'high') DEFAULT 'normal',
  `status` ENUM('pending', 'processing', 'sent', 'failed', 'cancelled') DEFAULT 'pending',
  `attempts` INT DEFAULT 0,
  `max_attempts` INT DEFAULT 3,
  `error_message` TEXT,
  `scheduled_at` TIMESTAMP NULL,
  `sent_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_scheduled (scheduled_at),
  INDEX idx_recipient (recipient_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- GROUP 13: SYSTEM SETTINGS & CONFIGURATION (8 TABLES)
-- =====================================================

-- 121. System Settings
CREATE TABLE `system_settings` (
  `setting_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `setting_key` VARCHAR(100) UNIQUE NOT NULL,
  `setting_value` TEXT,
  `setting_type` ENUM('string', 'number', 'boolean', 'json', 'array') DEFAULT 'string',
  `setting_category` VARCHAR(50) NOT NULL,
  `setting_label` VARCHAR(200),
  `setting_description` TEXT,
  `is_public` BOOLEAN DEFAULT FALSE COMMENT 'Can be accessed by frontend',
  `is_encrypted` BOOLEAN DEFAULT FALSE,
  `updated_by` INT UNSIGNED,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_key (setting_key),
  INDEX idx_category (setting_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 122. Email Templates
CREATE TABLE `email_templates` (
  `template_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `template_key` VARCHAR(100) UNIQUE NOT NULL,
  `template_name` VARCHAR(200) NOT NULL,
  `template_subject` VARCHAR(200) NOT NULL,
  `template_body_html` LONGTEXT NOT NULL,
  `template_body_text` TEXT,
  `template_variables` JSON COMMENT 'Available variables',
  `template_category` VARCHAR(100),
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_key (template_key),
  INDEX idx_category (template_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 123. Cron Jobs Log (AUTO-LOG all cron executions)
CREATE TABLE `cron_jobs_log` (
  `log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `job_name` VARCHAR(100) NOT NULL,
  `job_type` ENUM('tier_update', 'arpu_calculate', 'invoice_generate', 'email_queue', 'backup', 'cleanup', 'other') NOT NULL,
  `status` ENUM('running', 'success', 'failed', 'skipped') NOT NULL,
  `started_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL,
  `duration_seconds` INT UNSIGNED,
  `rows_affected` INT UNSIGNED,
  `output_log` TEXT,
  `error_message` TEXT,
  `server_hostname` VARCHAR(100),
  INDEX idx_job (job_name),
  INDEX idx_status (status),
  INDEX idx_started (started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 124. System Logs
CREATE TABLE `system_logs` (
  `log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `log_level` ENUM('debug', 'info', 'warning', 'error', 'critical') NOT NULL,
  `log_category` VARCHAR(50) NOT NULL,
  `log_message` TEXT NOT NULL,
  `log_context` JSON,
  `user_id` INT UNSIGNED NULL,
  `ip_address` VARCHAR(45),
  `user_agent` VARCHAR(255),
  `request_url` VARCHAR(500),
  `stack_trace` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_level (log_level),
  INDEX idx_category (log_category),
  INDEX idx_user (user_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 125. API Keys (For integrations)
CREATE TABLE `api_keys` (
  `key_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `key_name` VARCHAR(100) NOT NULL,
  `api_key` VARCHAR(255) UNIQUE NOT NULL,
  `api_secret` VARCHAR(255),
  `user_id` INT UNSIGNED NULL,
  `permissions` JSON COMMENT 'Array of allowed endpoints',
  `rate_limit` INT DEFAULT 1000 COMMENT 'Requests per hour',
  `is_active` BOOLEAN DEFAULT TRUE,
  `last_used_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_key (api_key),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 126. Webhooks
CREATE TABLE `webhooks` (
  `webhook_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `webhook_name` VARCHAR(100) NOT NULL,
  `webhook_url` VARCHAR(500) NOT NULL,
  `webhook_events` JSON COMMENT 'Array of events to trigger',
  `webhook_secret` VARCHAR(255),
  `is_active` BOOLEAN DEFAULT TRUE,
  `retry_on_failure` BOOLEAN DEFAULT TRUE,
  `max_retries` INT DEFAULT 3,
  `last_triggered_at` TIMESTAMP NULL,
  `success_count` INT UNSIGNED DEFAULT 0,
  `failure_count` INT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 127. Webhook Logs
CREATE TABLE `webhook_logs` (
  `log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `webhook_id` INT UNSIGNED NOT NULL,
  `event_type` VARCHAR(100) NOT NULL,
  `payload` JSON NOT NULL,
  `response_status` INT,
  `response_body` TEXT,
  `status` ENUM('pending', 'success', 'failed', 'retrying') NOT NULL,
  `attempt_number` INT DEFAULT 1,
  `error_message` TEXT,
  `triggered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (webhook_id) REFERENCES webhooks(webhook_id) ON DELETE CASCADE,
  INDEX idx_webhook (webhook_id),
  INDEX idx_status (status),
  INDEX idx_triggered (triggered_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 128. Media Library
CREATE TABLE `media_library` (
  `media_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `file_url` VARCHAR(500) NOT NULL,
  `file_size` BIGINT UNSIGNED,
  `mime_type` VARCHAR(100),
  `media_type` ENUM('image', 'video', 'document', 'audio', 'other') NOT NULL,
  `width` INT UNSIGNED,
  `height` INT UNSIGNED,
  `duration` INT UNSIGNED COMMENT 'For video/audio in seconds',
  `alt_text` VARCHAR(255),
  `title` VARCHAR(255),
  `description` TEXT,
  `uploaded_by` INT UNSIGNED,
  `usage_count` INT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_type (media_type),
  INDEX idx_uploaded (uploaded_by),
  FULLTEXT idx_search (file_name, title, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- FINAL: SEED DATA TABLES (2 TABLES)
-- =====================================================

-- 129. Training Modules
CREATE TABLE `training_modules` (
  `module_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `module_name` VARCHAR(200) NOT NULL,
  `module_description` TEXT,
  `module_content` LONGTEXT,
  `module_category` VARCHAR(100),
  `target_audience` ENUM('partner', 'spv', 'manager', 'all') DEFAULT 'all',
  `difficulty_level` ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
  `estimated_duration_minutes` INT,
  `passing_score` DECIMAL(5,2) DEFAULT 70.00,
  `certificate_template` VARCHAR(500),
  `display_order` INT DEFAULT 0,
  `is_mandatory` BOOLEAN DEFAULT FALSE,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_category (module_category),
  INDEX idx_audience (target_audience)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 130. Database Backups Log
CREATE TABLE `database_backups_log` (
  `backup_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `backup_filename` VARCHAR(255) NOT NULL,
  `backup_path` VARCHAR(500) NOT NULL,
  `backup_size` BIGINT UNSIGNED,
  `backup_type` ENUM('full', 'incremental', 'differential') DEFAULT 'full',
  `backup_method` ENUM('manual', 'auto_cron', 'scheduled') DEFAULT 'auto_cron',
  `backup_status` ENUM('in_progress', 'completed', 'failed') NOT NULL,
  `tables_count` INT UNSIGNED,
  `duration_seconds` INT UNSIGNED,
  `created_by` INT UNSIGNED,
  `error_message` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_status (backup_status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TOTAL: 130 TABLES COMPLETE! 🎉
-- =====================================================

-- Add Foreign Key for blog_posts category
ALTER TABLE `blog_posts` 
ADD CONSTRAINT `fk_blog_category` 
FOREIGN KEY (category_id) REFERENCES blog_categories(category_id) ON DELETE SET NULL;

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional composite indexes for common queries
CREATE INDEX idx_orders_client_status ON orders(client_id, status);
CREATE INDEX idx_orders_partner_status ON orders(partner_id, status);
CREATE INDEX idx_orders_created_status ON orders(created_at, status);
CREATE INDEX idx_payments_order_status ON payments(order_id, status);
CREATE INDEX idx_commissions_partner_status ON partner_commissions(partner_id, status);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read, created_at);
CREATE INDEX idx_activity_logs_user_created ON user_activity_logs(user_id, created_at);

-- =====================================================
-- TRIGGERS FOR AUTO-CALCULATIONS (Examples)
-- =====================================================

DELIMITER $$

-- AUTO UPDATE: Client total spent when payment verified
CREATE TRIGGER after_payment_verified
AFTER UPDATE ON payments
FOR EACH ROW
BEGIN
  IF NEW.status = 'verified' AND OLD.status != 'verified' THEN
    UPDATE clients 
    SET total_spent = total_spent + NEW.amount_paid,
        total_orders = total_orders + 1,
        last_order_date = NOW()
    WHERE client_id = NEW.client_id;
  END IF;
END$$

-- AUTO UPDATE: Partner referral stats
CREATE TRIGGER after_client_insert
AFTER INSERT ON clients
FOR EACH ROW
BEGIN
  IF NEW.partner_id IS NOT NULL THEN
    UPDATE partners
    SET total_clients_recruited = total_clients_recruited + 1,
        active_clients = active_clients + 1
    WHERE partner_id = NEW.partner_id;
  END IF;
END$$

-- AUTO UPDATE: Service total orders
CREATE TRIGGER after_order_completed
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    IF NEW.service_id IS NOT NULL THEN
      UPDATE services
      SET total_orders = total_orders + 1
      WHERE service_id = NEW.service_id;
    END IF;
  END IF;
END$$

DELIMITER ;

-- =====================================================
-- INITIAL SEED DATA (Critical)
-- =====================================================

-- Insert default admin user
INSERT INTO users (role, username, email, password_hash, full_name, status, email_verified) VALUES
('admin', 'admin', 'vins@situneo.my.id', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5PJavKJqNu7cK', 'Admin SITUNEO', 'active', TRUE);

-- Insert SPV ARPU tiers
INSERT INTO spv_arpu_config (tier_name, min_arpu, max_arpu, bonus_amount, tier_color, display_order) VALUES
('Tier 1', 15000000.00, 34999999.99, 500000.00, '#3B82F6', 1),
('Tier 2', 35000000.00, 74999999.99, 1000000.00, '#10B981', 2),
('Tier 3', 75000000.00, 199999999.99, 2000000.00, '#F59E0B', 3),
('Tier 4', 200000000.00, NULL, 10000000.00, '#EF4444', 4);

-- Insert Manager ARPU tiers
INSERT INTO manager_arpu_config (tier_name, min_arpu, max_arpu, bonus_amount, tier_color, display_order) VALUES
('Tier 1', 45000000.00, 104999999.99, 1000000.00, '#3B82F6', 1),
('Tier 2', 105000000.00, 224999999.99, 2000000.00, '#10B981', 2),
('Tier 3', 225000000.00, 599999999.99, 3000000.00, '#F59E0B', 3),
('Tier 4', 600000000.00, NULL, 15000000.00, '#EF4444', 4);

-- Insert Partner Tier Configuration
INSERT INTO partner_tier_config (tier_level, tier_name, commission_percentage, min_orders_lifetime, maintenance_orders_monthly) VALUES
('1', 'Bronze Partner', 30.00, 0, 0),
('2', 'Silver Partner', 40.00, 10, 10),
('3', 'Gold Partner', 50.00, 50, 25),
('MAX', 'Platinum Partner', 55.00, 75, 50);

-- Insert default payment methods
INSERT INTO payment_methods_config (method_type, method_name, provider_name, account_number, account_holder, is_active) VALUES
('bank_transfer', 'BCA', 'Bank BCA', '2750424018', 'Devin Prasetyo Hermawan', TRUE),
('qris', 'QRIS SITUNEO', 'QRIS', NULL, 'PT SITUNEO DIGITAL', TRUE);

-- Insert service categories (10 divisions)
INSERT INTO service_categories (category_name, category_slug, category_description, display_order) VALUES
('Website Development', 'website-development', 'Professional website development services', 1),
('SEO & Digital Marketing', 'seo-digital-marketing', 'Search engine optimization and marketing', 2),
('Social Media Management', 'social-media-management', 'Complete social media solutions', 3),
('Graphic Design', 'graphic-design', 'Creative design services', 4),
('Content Writing', 'content-writing', 'Professional content creation', 5),
('Video Production', 'video-production', 'Video creation and editing', 6),
('Branding', 'branding', 'Brand identity and strategy', 7),
('Digital Advertising', 'digital-advertising', 'Google Ads, Facebook Ads, etc', 8),
('E-commerce Solutions', 'ecommerce-solutions', 'Online store development', 9),
('App Development', 'app-development', 'Mobile and web applications', 10);

-- =====================================================
-- DATABASE SCHEMA COMPLETE!
-- Total Tables: 130 TABLES
-- All FUNCTIONAL & AUTO-OPTIMIZED!
-- =====================================================

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

COMMIT;