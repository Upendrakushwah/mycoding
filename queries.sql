-- ======================================================
-- RAILWAY RESERVATION SYSTEM (SQL SERVER)
-- ======================================================

-- Drop existing tables (to avoid duplication)
DROP TABLE IF EXISTS waitlist;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS booking_seates;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS seate;
DROP TABLE IF EXISTS coaches;
DROP TABLE IF EXISTS train_routes;
DROP TABLE IF EXISTS face;
DROP TABLE IF EXISTS trains;
DROP TABLE IF EXISTS stations;

----------------------------------------------------------
-- 1. STATIONS
----------------------------------------------------------
CREATE TABLE stations (
    station_id INT PRIMARY KEY IDENTITY(1,1),
    station_name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL,
    state VARCHAR(50)
);

INSERT INTO stations (station_name, code, state) VALUES
('New Delhi', 'NDLS', 'Delhi'),
('Mumbai Central', 'BCT', 'Maharashtra'),
('Howrah Junction', 'HWH', 'West Bengal'),
('Chennai Central', 'MAS', 'Tamil Nadu'),
('Kanpur Central', 'CNB', 'Uttar Pradesh');

----------------------------------------------------------
-- 2. TRAINS
----------------------------------------------------------
CREATE TABLE trains (
    train_id INT PRIMARY KEY IDENTITY(1,1),
    train_no VARCHAR(20) NOT NULL,
    train_name VARCHAR(100) NOT NULL,
    source_station_id INT,
    destination_station_id INT,
    FOREIGN KEY (source_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES stations(station_id)
);

INSERT INTO trains (train_no, train_name, source_station_id, destination_station_id) VALUES
('12301', 'Rajdhani Express', 1, 2),
('12658', 'Chennai Mail', 4, 3),
('12280', 'Taj Express', 1, 5);

----------------------------------------------------------
-- 3. TRAIN ROUTES
----------------------------------------------------------
CREATE TABLE train_routes (
    route_id INT PRIMARY KEY IDENTITY(1,1),
    train_id INT NOT NULL,
    station_id INT NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    FOREIGN KEY (train_id) REFERENCES trains(train_id),
    FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

INSERT INTO train_routes (train_id, station_id, arrival_time, departure_time) VALUES
(1, 1, '06:00', '06:15'),
(1, 5, '09:30', '09:40'),
(1, 2, '14:00', NULL),
(2, 4, '05:00', '05:20'),
(2, 3, '14:00', NULL),
(3, 1, '07:00', '07:10'),
(3, 5, '10:00', NULL);

----------------------------------------------------------
-- 4. COACHES
----------------------------------------------------------
CREATE TABLE coaches (
    coach_id INT PRIMARY KEY IDENTITY(1,1),
    train_id INT NOT NULL,
    coach_code VARCHAR(10) NOT NULL,
    coach_type VARCHAR(20),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

INSERT INTO coaches (train_id, coach_code, coach_type) VALUES
(1, 'A1', 'AC'),
(1, 'S1', 'Sleeper'),
(2, 'A1', 'AC'),
(3, 'S1', 'Sleeper');

----------------------------------------------------------
-- 5. SEATE
----------------------------------------------------------
CREATE TABLE seate (
    seat_id INT PRIMARY KEY IDENTITY(1,1),
    coach_id INT NOT NULL,
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id)
);

-- Insert 10 seats per coach
INSERT INTO seate (coach_id)
SELECT coach_id FROM coaches CROSS APPLY (SELECT TOP 10 1 AS x FROM sys.objects) o;

----------------------------------------------------------
-- 6. PASSENGERS
----------------------------------------------------------
CREATE TABLE passengers (
    passenger_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    adhar_no VARCHAR(20)
);

INSERT INTO passengers (name, age, gender, adhar_no) VALUES
('Amit Sharma', 35, 'Male', '123456789012'),
('Priya Verma', 29, 'Female', '987654321098'),
('Ravi Kumar', 42, 'Male', '456789123654'),
('Anjali Singh', 31, 'Female', '852741963258');

----------------------------------------------------------
-- 7. BOOKINGS
----------------------------------------------------------
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    pnr VARCHAR(20) UNIQUE NOT NULL,
    booking_time DATETIME DEFAULT GETDATE(),
    u_id INT,
    journey_date DATE,
    train_id INT NOT NULL,
    status VARCHAR(20),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

INSERT INTO bookings (pnr, u_id, journey_date, train_id, status) VALUES
('PNR001', 101, '2025-11-15', 1, 'Confirmed'),
('PNR002', 102, '2025-11-16', 2, 'Pending'),
('PNR003', 103, '2025-11-17', 3, 'Confirmed');

----------------------------------------------------------
-- 8. BOOKING SEATES
----------------------------------------------------------
CREATE TABLE booking_seates (
    booking_seat_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL,
    coach_id INT NOT NULL,
    seat_id INT NOT NULL,
    status VARCHAR(20),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id),
    FOREIGN KEY (seat_id) REFERENCES seate(seat_id)
);

INSERT INTO booking_seates (booking_id, passenger_id, coach_id, seat_id, status) VALUES
(1, 1, 1, 1, 'Confirmed'),
(1, 2, 1, 2, 'Confirmed'),
(2, 3, 3, 21, 'Waiting'),
(3, 4, 4, 31, 'Confirmed');

----------------------------------------------------------
-- 9. FACE (Fare)
----------------------------------------------------------
CREATE TABLE face (
    face_id INT PRIMARY KEY IDENTITY(1,1),
    train_id INT NOT NULL,
    from_station_id INT NOT NULL,
    to_station_id INT NOT NULL,
    coach_type VARCHAR(20),
    FOREIGN KEY (train_id) REFERENCES trains(train_id),
    FOREIGN KEY (from_station_id) REFERENCES stations(station_id),
    FOREIGN KEY (to_station_id) REFERENCES stations(station_id)
);

INSERT INTO face (train_id, from_station_id, to_station_id, coach_type) VALUES
(1, 1, 2, 'AC'),
(1, 1, 2, 'Sleeper'),
(2, 4, 3, 'AC'),
(3, 1, 5, 'Sleeper');

----------------------------------------------------------
-- 10. PAYMENT
----------------------------------------------------------
CREATE TABLE payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    paid_amount DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO payment (booking_id, paid_amount) VALUES
(1, 2550.00),
(2, 1800.00),
(3, 1200.00);

----------------------------------------------------------
-- 11. WAITLIST
----------------------------------------------------------
CREATE TABLE waitlist (
    w_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    coach_type VARCHAR(20),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

INSERT INTO waitlist (booking_id, coach_type) VALUES
(2, 'AC');

----------------------------------------------------------
-- SELECT ALL TABLES
----------------------------------------------------------

SELECT * FROM stations;
SELECT * FROM trains;
SELECT * FROM train_routes;
SELECT * FROM coaches;
SELECT * FROM seate;
SELECT * FROM passengers;
SELECT * FROM bookings;
SELECT * FROM booking_seates;
SELECT * FROM face;
SELECT * FROM payment;
SELECT * FROM waitlist;
