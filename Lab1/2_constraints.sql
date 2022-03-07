-- Trips
ALTER TABLE Trips
ADD CONSTRAINT Trips_chk1 CHECK (max_no_places > 0);

-- Reservations
ALTER TABLE Reservations
ADD CONSTRAINT Reservations_fk1 FOREIGN KEY (person_id)
REFERENCES People(person_id);

ALTER TABLE Reservations
ADD CONSTRAINT Reservations_fk2 FOREIGN KEY (trip_id)
REFERENCES Trips(trip_id);

ALTER TABLE Reservations
ADD CONSTRAINT Reservations_chk1 CHECK (status IN ('n', 'p', 'c'));

ALTER TABLE Reservations
ADD CONSTRAINT Reservations_chk2 CHECK (no_places > 0);

-- ReservationsLog
ALTER TABLE ReservationsLog
ADD CONSTRAINT ReservationLog_chk1 CHECK (status IN ('n', 'p', 'c'));

ALTER TABLE ReservationsLog
ADD CONSTRAINT ReservationsLog_chk2 CHECK (no_places > 0);
