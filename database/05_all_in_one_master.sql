-- ============================================================================
-- 05. ALL-IN-ONE MASTER SCRIPT (1-CLICK SETUP FOR ALL 15 TABLES + SEED DATA)
-- Database: car_rental
-- MySQL Password Reference: 1234
-- Admin Login: username=admin, password=admin
-- ============================================================================

CREATE DATABASE IF NOT EXISTS car_rental
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE car_rental;

-- ----------------------------------------------------------------------------
-- CORE TABLES
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COLLATE utf8mb4_unicode_ci,
    password_hash VARCHAR(200) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- ----------------------------------------------------------------------------
-- 12 EXPANDED ENTERPRISE TABLES
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customer_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    driving_license_no VARCHAR(50) NOT NULL UNIQUE,
    license_expiry_date DATE NOT NULL,
    address TEXT,
    city VARCHAR(60) NOT NULL DEFAULT 'Chennai',
    state VARCHAR(60) NOT NULL DEFAULT 'Tamil Nadu',
    pincode VARCHAR(10),
    is_verified BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS car_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    security_deposit DECIMAL(10, 2) NOT NULL DEFAULT 5000.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS car_features (
    id INT AUTO_INCREMENT PRIMARY KEY,
    feature_name VARCHAR(80) NOT NULL UNIQUE,
    icon VARCHAR(50) DEFAULT '🚗',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS car_feature_mappings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    feature_id INT NOT NULL,
    UNIQUE KEY unique_car_feature (car_id, feature_id),
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES car_features(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS rental_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(60) NOT NULL,
    full_address TEXT NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    operating_hours VARCHAR(80) DEFAULT '24/7 Open',
    is_airport_hub BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS drivers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    driver_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    experience_years INT NOT NULL DEFAULT 3,
    rating DECIMAL(2, 1) DEFAULT 4.8,
    daily_rate DECIMAL(8, 2) NOT NULL DEFAULT 800.00,
    status ENUM('available', 'on_trip', 'leave') DEFAULT 'available',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS insurance_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(80) NOT NULL,
    coverage_type ENUM('Basic', 'Comprehensive', 'Zero-Depreciation') NOT NULL,
    daily_price DECIMAL(8, 2) NOT NULL,
    deductible_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS discount_coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(30) NOT NULL UNIQUE,
    discount_percentage INT NOT NULL,
    max_discount_amount DECIMAL(8, 2) NOT NULL DEFAULT 2000.00,
    min_order_amount DECIMAL(8, 2) NOT NULL DEFAULT 1500.00,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    user_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('UPI', 'Cash', 'Card', 'RuPay', 'Visa', 'Mastercard') NOT NULL,
    transaction_ref VARCHAR(100) UNIQUE,
    payment_status ENUM('completed', 'pending', 'failed', 'refunded') DEFAULT 'completed',
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS reviews_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_title VARCHAR(120),
    review_comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS car_maintenance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    service_type ENUM('Periodic Service', 'Oil Change', 'Brake Inspection', 'Tire Replacement', 'Body Repair', 'General Checkup') NOT NULL,
    service_date DATE NOT NULL,
    odometer_reading INT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    service_center VARCHAR(120) NOT NULL,
    status ENUM('scheduled', 'in_progress', 'completed') DEFAULT 'completed',
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS damage_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    car_id INT NOT NULL,
    inspected_by VARCHAR(80) NOT NULL,
    damage_description TEXT,
    repair_cost DECIMAL(10, 2) DEFAULT 0.00,
    settlement_status ENUM('no_damage', 'pending_claim', 'resolved', 'deducted_from_deposit') DEFAULT 'no_damage',
    inspected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- SEED DATA
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO users (id, username, password_hash, role) VALUES
(1, 'admin', 'scrypt$6b245c34cb6269eb85387bba66144e54$b9e7aeaf04d4adba634f19bca4ca19b5e3943fe0df6eef1e6e02613d9435b80613dc0f074d22da376a40a232759e6c64bc63b0a23403328eeb31aeef53a1a67a', 'admin'),
(2, 'ajay', 'scrypt$7f58bba4cc3128fa77186ccb55143e41$c8d6beae03d3acbb523e18aca3ba08a4e2832ee0ce5edf0e5e01502c8324a70502cb0e063c11da265a309121648e5b53ab52a0912302217dda209dde42909569', 'user');

INSERT IGNORE INTO cars (id, name, price, image, mileage, seats, rating) VALUES
(1, 'Toyota Innova Crysta', 3200, '/Toyota.webp', '15 kmpl', '7 Seats', '4.9'),
(2, 'Hyundai Creta SX', 2400, '/hyundai.avif', '18 kmpl', '5 Seats', '4.8'),
(3, 'Kia Seltos GT Line', 2600, '/kia.avif', '16.5 kmpl', '5 Seats', '4.8'),
(4, 'Mahindra XUV700 AX7', 3500, '/Mahindra XUV700.jpg', '14 kmpl', '7 Seats', '4.9'),
(5, 'Toyota Glanza G', 1600, '/Toyota Glanza.jpg', '22 kmpl', '5 Seats', '4.7'),
(6, 'Honda Elevate ZX', 2300, '/Honda Elevate.jpg', '17 kmpl', '5 Seats', '4.8'),
(7, 'Maruti Suzuki Baleno', 1500, '/MarutiBaleno.jpg', '22.5 kmpl', '5 Seats', '4.6'),
(8, 'Mercedes-Benz Luxury Coupe', 12000, '/luxuriousCAR.jpg', '11 kmpl', '4 Seats', '5.0');

INSERT IGNORE INTO car_categories (id, category_name, description, security_deposit) VALUES
(1, 'Luxury Sedan', 'Premium sedans offering maximum comfort and executive prestige', 10000.00),
(2, 'Compact SUV', 'High ground clearance, versatile for city and road trips', 5000.00),
(3, 'Economy Hatchback', 'Fuel efficient, compact and easy city commuting', 3000.00),
(4, 'Electric Vehicle (EV)', 'Eco-friendly, instant torque and silent driving', 7000.00);

INSERT IGNORE INTO car_features (id, feature_name, icon) VALUES
(1, 'Panoramic Sunroof', '☀️'),
(2, 'Automatic Transmission', '⚙️'),
(3, 'GPS Navigation System', '🗺️'),
(4, '360-Degree Camera', '📷'),
(5, 'Bluetooth & Apple CarPlay', '📱'),
(6, 'Ventilated Leather Seats', '💺'),
(7, 'Cruise Control', '🚀'),
(8, 'Keyless Push Start', '🔑');

INSERT IGNORE INTO car_feature_mappings (car_id, feature_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 5), (1, 8),
(2, 2), (2, 3), (2, 5), (2, 7),
(3, 2), (3, 5), (3, 8),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 6), (4, 7),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 6), (8, 7), (8, 8);

INSERT IGNORE INTO rental_locations (id, branch_name, city, full_address, contact_phone, is_airport_hub) VALUES
(1, 'AL Cars Chennai Central Hub', 'Chennai', 'No. 45, Anna Salai, Mount Road, Chennai - 600002', '+91 98765 43210', FALSE),
(2, 'AL Cars Chennai International Airport', 'Chennai', 'Arrival Terminal T2, Airport Road, Meenambakkam, Chennai - 600027', '+91 98765 43211', TRUE),
(3, 'AL Cars OMR IT Expressway', 'Chennai', 'Plot 12, Rajiv Gandhi Salai, Thoraipakkam, Chennai - 600097', '+91 98765 43212', FALSE);

INSERT IGNORE INTO drivers (id, driver_name, phone_number, license_number, experience_years, rating, daily_rate, status) VALUES
(1, 'Ramesh Kumar', '+91 94441 23456', 'TN0120150001234', 8, 4.9, 850.00, 'available'),
(2, 'Senthil Nathan', '+91 94442 34567', 'TN0220170005678', 5, 4.8, 800.00, 'available');

INSERT IGNORE INTO insurance_plans (id, plan_name, coverage_type, daily_price, deductible_amount, description) VALUES
(1, 'Basic Protection', 'Basic', 299.00, 5000.00, 'Covers major mechanical breakdown & third-party liability'),
(2, 'Comprehensive Peace of Mind', 'Comprehensive', 599.00, 2000.00, 'Covers collision damage, roadside towing & scratches'),
(3, 'Zero-Depreciation Super Shield', 'Zero-Depreciation', 999.00, 0.00, '100% full coverage with zero customer liability for damages');

INSERT IGNORE INTO discount_coupons (id, coupon_code, discount_percentage, max_discount_amount, min_order_amount, valid_from, valid_until, is_active) VALUES
(1, 'ALFIRST', 20, 1500.00, 2000.00, '2026-01-01', '2026-12-31', TRUE),
(2, 'FESTIVE500', 10, 500.00, 1500.00, '2026-01-01', '2026-12-31', TRUE);

