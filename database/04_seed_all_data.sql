-- ============================================================================
-- 04. SEED SAMPLE DATA (All Tables)
-- Database: car_rental
-- Default Admin Account: username=admin, password=admin
-- ============================================================================

USE car_rental;

-- 1. Users (Admin + Demo Users with scrypt encrypted passwords)
-- password for 'admin' is 'admin' (scrypt$6b245c34cb6269eb85387bba66144e54$b9e7aeaf04d4adba634f19bca4ca19b5e3943fe0df6eef1e6e02613d9435b80613dc0f074d22da376a40a232759e6c64bc63b0a23403328eeb31aeef53a1a67a)
INSERT IGNORE INTO users (id, username, password_hash, role) VALUES
(1, 'admin', 'scrypt$6b245c34cb6269eb85387bba66144e54$b9e7aeaf04d4adba634f19bca4ca19b5e3943fe0df6eef1e6e02613d9435b80613dc0f074d22da376a40a232759e6c64bc63b0a23403328eeb31aeef53a1a67a', 'admin'),
(2, 'ajay', 'scrypt$7f58bba4cc3128fa77186ccb55143e41$c8d6beae03d3acbb523e18aca3ba08a4e2832ee0ce5edf0e5e01502c8324a70502cb0e063c11da265a309121648e5b53ab52a0912302217dda209dde42909569', 'user'),
(3, 'gobi', 'scrypt$7f58bba4cc3128fa77186ccb55143e41$c8d6beae03d3acbb523e18aca3ba08a4e2832ee0ce5edf0e5e01502c8324a70502cb0e063c11da265a309121648e5b53ab52a0912302217dda209dde42909569', 'user');

-- 2. Cars Fleet
INSERT IGNORE INTO cars (id, name, price, image, mileage, seats, rating) VALUES
(1, 'Toyota Innova Crysta', 3200, '/Toyota.webp', '15 kmpl', '7 Seats', '4.9'),
(2, 'Hyundai Creta SX', 2400, '/hyundai.avif', '18 kmpl', '5 Seats', '4.8'),
(3, 'Kia Seltos GT Line', 2600, '/kia.avif', '16.5 kmpl', '5 Seats', '4.8'),
(4, 'Mahindra XUV700 AX7', 3500, '/Mahindra XUV700.jpg', '14 kmpl', '7 Seats', '4.9'),
(5, 'Toyota Glanza G', 1600, '/Toyota Glanza.jpg', '22 kmpl', '5 Seats', '4.7'),
(6, 'Honda Elevate ZX', 2300, '/Honda Elevate.jpg', '17 kmpl', '5 Seats', '4.8'),
(7, 'Maruti Suzuki Baleno', 1500, '/MarutiBaleno.jpg', '22.5 kmpl', '5 Seats', '4.6'),
(8, 'Mercedes-Benz Luxury Coupe', 12000, '/luxuriousCAR.jpg', '11 kmpl', '4 Seats', '5.0');

-- 3. Categories
INSERT IGNORE INTO car_categories (id, category_name, description, security_deposit) VALUES
(1, 'Luxury Sedan', 'Premium sedans offering maximum comfort and executive prestige', 10000.00),
(2, 'Compact SUV', 'High ground clearance, versatile for city and road trips', 5000.00),
(3, 'Economy Hatchback', 'Fuel efficient, compact and easy city commuting', 3000.00),
(4, 'Electric Vehicle (EV)', 'Eco-friendly, instant torque and silent driving', 7000.00);

-- 4. Features
INSERT IGNORE INTO car_features (id, feature_name, icon) VALUES
(1, 'Panoramic Sunroof', '☀️'),
(2, 'Automatic Transmission', '⚙️'),
(3, 'GPS Navigation System', '🗺️'),
(4, '360-Degree Camera', '📷'),
(5, 'Bluetooth & Apple CarPlay', '📱'),
(6, 'Ventilated Leather Seats', '💺'),
(7, 'Cruise Control', '🚀'),
(8, 'Keyless Push Start', '🔑');

-- 5. Feature Mappings
INSERT IGNORE INTO car_feature_mappings (car_id, feature_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 5), (1, 8),
(2, 2), (2, 3), (2, 5), (2, 7),
(3, 2), (3, 5), (3, 8),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 6), (4, 7),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 6), (8, 7), (8, 8);

-- 6. Rental Locations
INSERT IGNORE INTO rental_locations (id, branch_name, city, full_address, contact_phone, is_airport_hub) VALUES
(1, 'AL Cars Chennai Central Hub', 'Chennai', 'No. 45, Anna Salai, Mount Road, Chennai - 600002', '+91 98765 43210', FALSE),
(2, 'AL Cars Chennai International Airport', 'Chennai', 'Arrival Terminal T2, Airport Road, Meenambakkam, Chennai - 600027', '+91 98765 43211', TRUE),
(3, 'AL Cars OMR IT Expressway', 'Chennai', 'Plot 12, Rajiv Gandhi Salai, Thoraipakkam, Chennai - 600097', '+91 98765 43212', FALSE);

-- 7. Drivers
INSERT IGNORE INTO drivers (id, driver_name, phone_number, license_number, experience_years, rating, daily_rate, status) VALUES
(1, 'Ramesh Kumar', '+91 94441 23456', 'TN0120150001234', 8, 4.9, 850.00, 'available'),
(2, 'Senthil Nathan', '+91 94442 34567', 'TN0220170005678', 5, 4.8, 800.00, 'available'),
(3, 'Vigneshwaran M', '+91 94443 45678', 'TN0920190009012', 4, 4.7, 750.00, 'available');

-- 8. Insurance Plans
INSERT IGNORE INTO insurance_plans (id, plan_name, coverage_type, daily_price, deductible_amount, description) VALUES
(1, 'Basic Protection', 'Basic', 299.00, 5000.00, 'Covers major mechanical breakdown & third-party liability'),
(2, 'Comprehensive Peace of Mind', 'Comprehensive', 599.00, 2000.00, 'Covers collision damage, roadside towing & scratches'),
(3, 'Zero-Depreciation Super Shield', 'Zero-Depreciation', 999.00, 0.00, '100% full coverage with zero customer liability for damages');

-- 9. Discount Coupons
INSERT IGNORE INTO discount_coupons (id, coupon_code, discount_percentage, max_discount_amount, min_order_amount, valid_from, valid_until, is_active) VALUES
(1, 'ALFIRST', 20, 1500.00, 2000.00, '2026-01-01', '2026-12-31', TRUE),
(2, 'FESTIVE500', 10, 500.00, 1500.00, '2026-01-01', '2026-12-31', TRUE),
(3, 'LUXURYDRIVE', 25, 3000.00, 5000.00, '2026-01-01', '2026-12-31', TRUE);

-- 10. Sample Customer Profile
INSERT IGNORE INTO customer_profiles (user_id, full_name, email, phone_number, driving_license_no, license_expiry_date, address, city, state, pincode) VALUES
(1, 'Admin Executive', 'admin.alcars@example.com', '+91 98400 12345', 'TN-01-2018-0044556', '2035-10-15', 'No. 22, Gandhi Road, T. Nagar', 'Chennai', 'Tamil Nadu', '600017');

-- 11. Maintenance Records
INSERT IGNORE INTO car_maintenance (car_id, service_type, service_date, odometer_reading, cost, service_center, status, notes) VALUES
(1, 'Periodic Service', '2026-09-15', 24500, 4800.00, 'Toyota Authorized Service Center, Chennai', 'completed', 'Oil replacement, air filter change and brake pad check complete.');

