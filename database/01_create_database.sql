-- ============================================================================
-- 01. CREATE DATABASE & APPLICATION USER
-- Database: car_rental
-- MySQL Password Reference: 1234
-- ============================================================================

CREATE DATABASE IF NOT EXISTS car_rental
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Optional dedicated user creation (if not using root)
CREATE USER IF NOT EXISTS 'car_rental_app'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON car_rental.* TO 'car_rental_app'@'localhost';
FLUSH PRIVILEGES;

USE car_rental;

