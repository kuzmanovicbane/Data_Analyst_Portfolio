-- ================================================================
-- DODAVANJE PRIMARY KEY I FOREIGN KEY OGRANIČENJA
-- ================================================================

USE ta_road_transport_agency;

-- ======================
-- PRIMARY KEYS
-- ======================
ALTER TABLE ta_drivers
    ADD PRIMARY KEY (driver_id);

ALTER TABLE ta_vehicles
    ADD PRIMARY KEY (vehicle_id);

ALTER TABLE ta_clients
    ADD PRIMARY KEY (client_id);

ALTER TABLE ta_shipments
    ADD PRIMARY KEY (shipment_id);

ALTER TABLE ta_routes
    ADD PRIMARY KEY (route_id);

ALTER TABLE ta_expenses
    ADD PRIMARY KEY (expense_id);

ALTER TABLE ta_maintenance
    ADD PRIMARY KEY (maintenance_id);

ALTER TABLE ta_fuel_logs
    ADD PRIMARY KEY (fuel_log_id);

-- ======================
-- FOREIGN KEYS
-- ======================
ALTER TABLE ta_shipments
    ADD CONSTRAINT fk_shipments_client
    FOREIGN KEY (client_id)
    REFERENCES ta_clients(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE ta_routes
    ADD CONSTRAINT fk_routes_shipment
    FOREIGN KEY (shipment_id)
    REFERENCES ta_shipments(shipment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE ta_routes
    ADD CONSTRAINT fk_routes_driver
    FOREIGN KEY (driver_id)
    REFERENCES ta_drivers(driver_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE ta_routes
    ADD CONSTRAINT fk_routes_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES ta_vehicles(vehicle_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE ta_expenses
    ADD CONSTRAINT fk_expenses_route
    FOREIGN KEY (route_id)
    REFERENCES ta_routes(route_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE ta_maintenance
    ADD CONSTRAINT fk_maintenance_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES ta_vehicles(vehicle_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE ta_fuel_logs
    ADD CONSTRAINT fk_fuel_logs_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES ta_vehicles(vehicle_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

