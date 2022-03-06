-- 6. trigger after reservation insert
CREATE OR REPLACE TRIGGER AI_logReservationInsert
AFTER INSERT
ON Reservations
FOR EACH ROW
BEGIN
    INSERT INTO ReservationsLog (reservation_id, log_date, status, no_places)
    VALUES (:NEW.reservation_id, SYSDATE, :NEW.status, :NEW.no_places);
END;

-- 6. trigger after reservation status/places number change
CREATE OR REPLACE TRIGGER AU_logReservationUpdate
AFTER UPDATE
ON Reservations
FOR EACH ROW
BEGIN
    IF :NEW.status != :OLD.status OR :NEW.no_places != :OLD.no_places THEN
        INSERT INTO ReservationsLog (reservation_id, log_date, status, no_places)
        VALUES (:NEW.reservation_id, SYSDATE, :NEW.status, :NEW.no_places);
    END IF;
END;

-- tests
SELECT trip_id, trip_date, getAvailablePlaces(trip_id)
FROM Trips;

-- insert the new reservation
BEGIN
    addReservation(2, 1, 1);
END;

-- change reservation status
DECLARE
    l_reservation_id Reservations.reservation_id%TYPE;
BEGIN
    SELECT MAX(reservation_id)
    INTO l_reservation_id
    FROM Reservations;

    modifyReservationStatus(l_reservation_id, 'p');
END;

-- change reservation number of places
DECLARE
    l_reservation_id Reservations.reservation_id%TYPE;
BEGIN
    SELECT MAX(reservation_id)
    INTO l_reservation_id
    FROM Reservations;

    modifyReservationNoPlaces(l_reservation_id, 2);
END;

SELECT * FROM Reservations;
SELECT * FROM ReservationsLog;

ROLLBACK;
