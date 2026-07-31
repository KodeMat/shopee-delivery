-- MySQL Database initialization for Shopee Delivery system

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(20) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    capacity INT,
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS delivery_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    recipient_name VARCHAR(100) NOT NULL,
    recipient_address TEXT NOT NULL,
    weight DOUBLE,
    status VARCHAR(20) DEFAULT 'Pending',
    driver_id INT NULL,
    vehicle_id INT NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE SET NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE SET NULL
);

-- Insert hardcoded admin user
INSERT INTO users (username, password, role, status)
VALUES ('admin', 'admin123', 'ADMIN', 'APPROVED')
ON DUPLICATE KEY UPDATE username=username;
