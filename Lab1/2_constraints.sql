ALTER TABLE Reservations
ADD CONSTRAINT reservations_fk1 FOREIGN KEY (person_id)
REFERENCES People(person_id);

ALTER TABLE Reservations
ADD CONSTRAINT reservations_fk2 FOREIGN KEY (trip_id)
REFERENCES Trips(trip_id);

ALTER TABLE Reservations
ADD CONSTRAINT reservations_chk1 CHECK (status IN ('n', 'p', 'c'));
