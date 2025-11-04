-- ================================================================
-- DATABASE: ta_road_transport_agency
-- ================================================================

CREATE DATABASE IF NOT EXISTS ta_road_transport_agency;
USE ta_road_transport_agency;

-- ================================================================
-- TABLES CREATION (bez PRIMARY i FOREIGN KEY ograničenja)
-- ================================================================

CREATE TABLE IF NOT EXISTS ta_drivers (
    driver_id INT,
    name VARCHAR(50),
    surname VARCHAR(50),
    license_number VARCHAR(20),
    hire_date DATE,
    experience_years INT,
    status ENUM('active', 'on_leave', 'inactive') DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS ta_vehicles (
    vehicle_id INT,
    plate_number VARCHAR(15),
    model VARCHAR(50),
    year YEAR,
    capacity_tons DECIMAL(5,1),
    fuel_type ENUM('Diesel', 'LPG', 'Petrol'),
    status ENUM('available', 'in_service', 'maintenance') DEFAULT 'available'
);

CREATE TABLE IF NOT EXISTS ta_clients (
    client_id INT,
    company_name VARCHAR(100),
    contact_person VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ta_shipments (
    shipment_id INT,
    client_id INT,
    origin VARCHAR(100),
    destination VARCHAR(100),
    distance_km DECIMAL(8,1),
    weight_tons DECIMAL(6,2),
    price_eur DECIMAL(10,2),
    date_requested DATE
);

CREATE TABLE IF NOT EXISTS ta_routes (
    route_id INT,
    shipment_id INT,
    driver_id INT,
    vehicle_id INT,
    start_date DATE,
    end_date DATE,
    status ENUM('completed', 'in_progress', 'delayed') DEFAULT 'in_progress'
);

CREATE TABLE IF NOT EXISTS ta_expenses (
    expense_id INT,
    route_id INT,
    date DATE,
    type ENUM('Fuel', 'Toll', 'Maintenance', 'Fine', 'Other'),
    amount_eur DECIMAL(10,2),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ta_maintenance (
    maintenance_id INT,
    vehicle_id INT,
    date DATE,
    service_type ENUM('Oil Change', 'Tire Replacement', 'Engine Repair', 'Brake Service', 'Other'),
    cost_eur DECIMAL(10,2),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ta_fuel_logs (
    fuel_log_id INT,
    vehicle_id INT,
    date DATE,
    liters DECIMAL(8,1),
    price_per_liter_eur DECIMAL(5,2),
    total_cost_eur DECIMAL(10,2),
    location VARCHAR(100)
);
