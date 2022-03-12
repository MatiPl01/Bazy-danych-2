/*
BEFORE PROCEDURES CHANGES
*/
-- 6. trigger after reservation insert
CREATE OR REPLACE TRIGGER AI_ReservationInsert
AFTER INSERT
ON Reservations
FOR EACH ROW
BEGIN
    INSERT INTO ReservationsLog (reservation_id, log_date, status, no_places)
    VALUES (:NEW.reservation_id, SYSDATE, :NEW.status, :NEW.no_places);
END;


-- 6. trigger after reservation status change
CREATE OR REPLACE TRIGGER AU_ReservationStatusUpdate
AFTER UPDATE
OF status ON Reservations
FOR EACH ROW
BEGIN
    IF :NEW.status != :OLD.status THEN
        INSERT INTO ReservationsLog (reservation_id, log_date, status, no_places)
        VALUES (:NEW.reservation_id, SYSDATE, :NEW.status, :NEW.no_places);
    END IF;
END;

-- 6. trigger after reservation number of places change
CREATE OR REPLACE TRIGGER AU_ReservationNoPlacesUpdate
AFTER UPDATE
OF no_places ON Reservations
FOR EACH ROW
BEGIN
    IF :NEW.no_places != :OLD.no_places THEN
        INSERT INTO ReservationsLog (reservation_id, log_date, status, no_places)
        VALUES (:NEW.reservation_id, SYSDATE, :NEW.status, :NEW.no_places);
    END IF;
END;


-- tests
SELECT trip_id, trip_date, getAvailablePlacesNum(trip_id)
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

DELETE FROM ReservationsLog;
DELETE FROM Reservations WHERE reservation_id > 11;

/*
AFTER PROCEDURES CHANGES
*/
-- 7. trigger before reservation insert
CREATE OR REPLACE TRIGGER BI_ReservationInsert
BEFORE INSERT
ON Reservations
FOR EACH ROW
DECLARE
    l_available_places Reservations.no_places%TYPE;
BEGIN
    IF NOT doesPersonExist(:NEW.person_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'The person with id ' || :NEW.person_id || ' does not exit');
    END IF;

    IF :NEW.no_places < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot book less than 1 place for a trip');
    END IF;

    l_available_places := getAvailablePlacesNum(:NEW.trip_id);

    IF l_available_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are no available places for a trip with id ' || :NEW.trip_id);
    ELSIF l_available_places < :NEW.no_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are only ' || l_available_places ||
                                        ' places available for a trip with id ' || :NEW.trip_id);
    END IF;
END;

-- 7. trigger before reservation status change
CREATE OR REPLACE TRIGGER BU_ReservationStatusUpdate
BEFORE UPDATE
OF status ON Reservations
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_available_places Reservations.no_places%TYPE;
BEGIN
    CASE :NEW.status
    WHEN :OLD.status THEN
        DBMS_OUTPUT.PUT_LINE('The reservation with id ' || :NEW.reservation_id ||
                             ' has already the status: ' || :NEW.status);
        RETURN;
    WHEN 'c' THEN
        NULL;
    WHEN 'n' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot change the status of the reservation with id ' ||
                                        :NEW.reservation_id || ' to: n');
    WHEN 'p' THEN
        -- Check if can make cancelled reservation available (paid) again
        -- (check if there are enough empty places for a trip)
        IF :OLD.status = 'c' THEN
            l_available_places := getAvailablePlacesNum(:NEW.trip_id);

            IF l_available_places < :NEW.no_places THEN
                RAISE_APPLICATION_ERROR(-20001, 'Not enough places available to update the cancelled reservation status');
            END IF;
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Status: ' || :NEW.status || ' is not a valid reservation status');
    END CASE;
END;

-- 7. trigger before reservation number of places change
CREATE OR REPLACE TRIGGER BU_ReservationNoPlacesUpdate
BEFORE UPDATE
OF no_places ON Reservations
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_available_places Reservations.no_places%TYPE;
BEGIN
    l_available_places := getAvailablePlacesNum(:NEW.trip_id);

    IF :NEW.no_places <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'The number of booked places should be greater than 0');
    ELSIF :NEW.no_places - :OLD.no_places > l_available_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are not enough free places. Max possible number of places to book: ' ||
                                       (l_available_places + :OLD.no_places));
    END IF;
END;

-- 7. trigger before trip max places number change
CREATE OR REPLACE TRIGGER BU_TripMaxNoPlacesUpdate
BEFORE UPDATE
OF max_no_places ON Trips
FOR EACH ROW
DECLARE
    l_booked_places Reservations.no_places%TYPE;
BEGIN
    l_booked_places := getBookedPlacesNum(:NEW.trip_id);

    IF :NEW.max_no_places = :OLD.max_no_places THEN
        DBMS_OUTPUT.PUT_LINE('The trip with id ' || :NEW.trip_id ||
                             ' has already the maximum number of places set to ' || :OLD.max_no_places);
        RETURN;
    END IF;

    IF :NEW.max_no_places < l_booked_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'The maximum number of places (' || :NEW.max_no_places ||
                                        ') cannot be lower than the total number of booked places (' || l_booked_places ||
                                        ') for a trip wit id ' || :NEW.trip_id);
    END IF;
END;
