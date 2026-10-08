-- ============================================================================
-- 02. CORE APPLICATION SCHEMA (Users, Cars, Bookings)
-- Database: car_rental
-- ============================================================================

USE car_rental;

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COLLATE utf8mb4_unicode_ci,
    password_hash VARCHAR(200) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. CARS TABLE
CREATE TABLE IF NOT EXISTS cars (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL DEFAULT 0,
    image VARCHAR(255) NOT NULL DEFAULT '/placeholder.jpg',
    mileage VARCHAR(50) NOT NULL DEFAULT '',
    seats VARCHAR(20) NOT NULL DEFAULT '',
    rating VARCHAR(20) NOT NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS bookings (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    car_details JSON NULL,
    total_amount INT NULL,
    payment_method VARCHAR(50) NULL,
    pickup_date VARCHAR(20) NULL,
    return_date VARCHAR(20) NULL,
    status ENUM('pending', 'confirmed', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

