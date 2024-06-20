-- Hotel Table

CREATE TABLE hotel (
    hotel_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    postal_code VARCHAR(20),
    phone_number VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Room Table

CREATE TABLE Room (
    room_id SERIAL PRIMARY KEY,
    hotel_id INT NOT NULL REFERENCES Hotel(hotel_id) ON DELETE CASCADE,
    room_number VARCHAR(20) NOT NULL,
    type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('available', 'occupied', 'maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (hotel_id, room_number) -- Ensure unique room numbers within each hotel
);
CREATE INDEX idx_room_status ON Room(status);
CREATE INDEX idx_room_price_per_night ON Room(price_per_night);

-- Guest Table

CREATE TABLE Guest (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    postal_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reservation Table

CREATE TABLE Reservation (
    reservation_id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL REFERENCES Guest(guest_id) ON DELETE CASCADE,
    hotel_id INT NOT NULL REFERENCES Hotel(hotel_id) ON DELETE CASCADE,
    room_id INT NOT NULL REFERENCES Room(room_id) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL CHECK (number_of_guests > 0),
    status VARCHAR(50) NOT NULL CHECK (status IN ('confirmed', 'checked-in', 'checked-out', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_reservation_dates ON Reservation(check_in_date, check_out_date);
CREATE INDEX idx_reservation_status ON Reservation(status);

-- Payment Table

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES Reservation(reservation_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('credit card', 'debit card', 'PayPal')),
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'pending', 'failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_payment_date ON Payment(payment_date);
CREATE INDEX idx_payment_status ON Payment(status);

