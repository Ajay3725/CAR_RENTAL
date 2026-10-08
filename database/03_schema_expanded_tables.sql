-- ============================================================================
-- 03. EXPANDED ENTERPRISE SCHEMA (12 Additional Tables)
-- Database: car_rental
-- ============================================================================

USE car_rental;

-- 1. CUSTOMER PROFILES (Detailed verification & contact info)
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

-- 2. CAR CATEGORIES (Sedan, SUV, Luxury, EV, Hatchback)
CREATE TABLE IF NOT EXISTS car_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    security_deposit DECIMAL(10, 2) NOT NULL DEFAULT 5000.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. CAR FEATURES (Amenities & equipment)
CREATE TABLE IF NOT EXISTS car_features (
    id INT AUTO_INCREMENT PRIMARY KEY,
    feature_name VARCHAR(80) NOT NULL UNIQUE,
    icon VARCHAR(50) DEFAULT '🚗',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. CAR FEATURE MAPPINGS (Junction linking cars to features)
CREATE TABLE IF NOT EXISTS car_feature_mappings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    feature_id INT NOT NULL,
    UNIQUE KEY unique_car_feature (car_id, feature_id),
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES car_features(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. RENTAL LOCATIONS (Branches, airport hubs, city hubs)
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

-- 6. CHAUFFEURS / DRIVERS
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

-- 7. INSURANCE PLANS (Protection options)
CREATE TABLE IF NOT EXISTS insurance_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(80) NOT NULL,
    coverage_type ENUM('Basic', 'Comprehensive', 'Zero-Depreciation') NOT NULL,
    daily_price DECIMAL(8, 2) NOT NULL,
    deductible_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. DISCOUNT COUPONS (Promotions & vouchers)
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

-- 9. PAYMENTS (Audit ledger & gateway records)
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

-- 10. REVIEWS & RATINGS
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

-- 11. CAR MAINTENANCE
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

-- 12. DAMAGE & RETURN INSPECTIONS
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

