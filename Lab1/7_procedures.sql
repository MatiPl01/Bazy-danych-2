/*
BEFORE PROCEDURES CHANGES
*/
-- 5. a)
CREATE OR REPLACE PROCEDURE addReservation(
    p_trip_id Trips.trip_id%TYPE,
    p_person_id People.person_id%TYPE,
    p_no_places Reservations.no_places%TYPE
)
AS
    l_available_places Reservations.no_places%TYPE;
BEGIN
    IF NOT doesPersonExist(p_person_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'The person with id ' || p_person_id || ' does not exit');
    END IF;

    IF hasTripTakenPlace(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'The trip with id ' || p_trip_id || ' took place before');
    END IF;

    IF p_no_places < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot book less than 1 place for a trip');
    END IF;

    l_available_places := getAvailablePlaces(p_trip_id);

    IF l_available_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are no available places for a trip with id ' || p_trip_id);
    ELSIF l_available_places < p_no_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are only ' || l_available_places ||
                                        ' places available for a trip with id ' || p_trip_id);
    END IF;

    INSERT INTO Reservations (trip_id, person_id, status, no_places)
    VALUES (p_trip_id, p_person_id, 'n', p_no_places);

    COMMIT;
END;

-- tests
SELECT trip_id, getAvailablePlaces(trip_id)
FROM Trips;

-- Trip does not exist
BEGIN
    addReservation(5, 1, 1);
END;

-- Person does not exist
BEGIN
    addReservation(2, 213, 1);
END;

-- Took place before
BEGIN
    addReservation(1, 1, 1);
END;

-- Cannot book less than 1 place
BEGIN
    addReservation(4, 1, 0);
END;

-- No available places
BEGIN
    addReservation(4, 1, 1);
END;

-- Not enough places available
BEGIN
    addReservation(3, 1, 6);
END;

-- Correct
BEGIN
    addReservation(2, 1, 5);
END;

SELECT trip_id, getAvailablePlaces(trip_id)
FROM Trips;

-- 5. b)
CREATE OR REPLACE PROCEDURE modifyReservationStatus(
    p_reservation_id Reservations.reservation_id%TYPE,
    p_status Reservations.status%TYPE
)
AS
    l_curr_status Reservations.status%TYPE;
    l_trip_id Reservations.trip_id%TYPE;
    l_no_places Reservations.no_places%TYPE;
    l_available_places Reservations.no_places%TYPE;
BEGIN
    SELECT
        status,
        trip_id,
        no_places
    INTO
        l_curr_status,
        l_trip_id,
        l_no_places
    FROM Reservations
    WHERE reservation_id = p_reservation_id;

    CASE p_status
    WHEN l_curr_status THEN
        DBMS_OUTPUT.PUT_LINE('The reservation with id ' || p_reservation_id ||
                             ' has already the status: ' || p_status);
        RETURN;
    WHEN 'c' THEN
        NULL;
    WHEN 'n' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot change the status of the reservation with id ' ||
                                        p_reservation_id || ' to: n');
    WHEN 'p' THEN
        -- Check if can make cancelled reservation available (paid) again
        -- (check if there are enough empty places for a trip)
        IF l_curr_status = 'c' THEN
            l_available_places := getAvailablePlaces(l_trip_id);

            IF l_available_places < l_no_places THEN
                RAISE_APPLICATION_ERROR(-20001, 'Not enough places available to update the cancelled reservation status');
            END IF;
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Status: ' || p_status || ' is not a valid reservation status');
    END CASE;

    -- If everything is correct, update teh reservation status
    UPDATE Reservations
    SET status = p_status
    WHERE reservation_id = p_reservation_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'There is no reservation with id ' || p_reservation_id || ' in the database');

    COMMIT;
END;

-- tests
SELECT *
FROM Reservations;

-- Set the same status as the current one
BEGIN
   modifyReservationStatus(1, 'n');
END;

-- [Error] Change paid reservation status to the new status
BEGIN
   modifyReservationStatus(2, 'n');
END;

-- [Error] Change cancelled reservation status to the new status
BEGIN
   modifyReservationStatus(4, 'n');
END;

SELECT *
FROM Reservations
WHERE status = 'c'
    AND getAvailablePlaces(trip_id) < no_places;

-- [Error] Change cancelled reservation to paid when there are not enough places available
BEGIN
   modifyReservationStatus(10, 'p');
END;

-- [Error] Invalid reservation status
BEGIN
   modifyReservationStatus(10, 'z');
END;

-- [Error] Reservation does not exist
BEGIN
   modifyReservationStatus(12, 'c');
END;

-- Correct modification from paid to cancelled
BEGIN
   modifyReservationStatus(2, 'c');
END;

-- Correct modification from new to cancelled
BEGIN
   modifyReservationStatus(1, 'c');
END;


-- 5. c)
CREATE OR REPLACE PROCEDURE modifyReservationNoPlaces(
    p_reservation_id Reservations.reservation_id%TYPE,
    p_no_places Reservations.no_places%TYPE
)
AS
    l_curr_no_places Reservations.no_places%TYPE;
    l_available_places Reservations.no_places%TYPE;
BEGIN
    SELECT
        no_places,
        getAvailablePlaces(trip_id)
    INTO
        l_curr_no_places,
        l_available_places
    FROM Reservations
    WHERE reservation_id = p_reservation_id;

    IF p_no_places <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'The number of booked places should be greater than 0');
    ELSIF p_no_places - l_curr_no_places > l_available_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'There are not enough free places. Max possible number of places to book: ' ||
                                       (l_available_places + l_curr_no_places));
    END IF;

    UPDATE Reservations
    SET no_places = p_no_places
    WHERE reservation_id = p_reservation_id;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'There is no reservation with id ' || p_reservation_id || ' in the database');

    COMMIT;
END;

-- tests
SELECT reservation_id, no_places, getAvailablePlaces(trip_id) AS available_places
FROM Reservations;

-- [Error] Wrong number of booked places (<= 0)
BEGIN
   modifyReservationNoPlaces(1, 0);
END;

-- [Error] Too many booked places
/*
already booked:              1
available:                   5
can book at most (in total): 6
*/
BEGIN
   modifyReservationNoPlaces(1, 7);
END;

-- Correct
BEGIN
   modifyReservationNoPlaces(1, 6);
END;


-- 5. d)
CREATE OR REPLACE PROCEDURE modifyMaxNoPlaces(
    p_trip_id Trips.trip_id%TYPE,
    p_max_no_places Trips.max_no_places%TYPE
)
AS
    l_booked_places Reservations.no_places%TYPE;
    l_curr_max_no_places Trips.max_no_places%TYPE;
BEGIN
    SELECT
        max_no_places,
        getBookedPlaces(p_trip_id)
    INTO
        l_curr_max_no_places,
        l_booked_places
    FROM Trips
    WHERE trip_id = p_trip_id;

    IF p_max_no_places = l_curr_max_no_places THEN
        DBMS_OUTPUT.PUT_LINE('The trip with id ' || p_trip_id ||
                             ' has already the maximum number of places set to ' || l_curr_max_no_places);
        RETURN;
    END IF;

    IF p_max_no_places < l_booked_places THEN
        RAISE_APPLICATION_ERROR(-20001, 'The maximum number of places (' || p_max_no_places ||
                                        ') cannot be lower than the total number of booked places (' || l_booked_places ||
                                        ') for a trip wit id ' || p_trip_id);
    END IF;

    UPDATE Trips
    SET max_no_places = p_max_no_places
    WHERE trip_id = p_trip_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'There is no trip with id ' || p_trip_id || ' in the database');
    COMMIT;
END;

-- tests
SELECT trip_id, max_no_places, getBookedPlaces(trip_id) AS booked_places
FROM Trips;

-- [Error] New max_no_places is lower than the total booked places for a trip
BEGIN
   modifyMaxNoPlaces(3, 6);
END;

-- [Error] Trip doesn't exist
BEGIN
   modifyMaxNoPlaces(6, 6);
END;

-- Correct (set the same max_no_places as its current value)
BEGIN
   modifyMaxNoPlaces(4, 8);
END;

-- Correct (modify the max_no_places value)
BEGIN
   modifyMaxNoPlaces(3, 7);
END;



/*
AFTER PROCEDURES CHANGES
*/
-- a)
CREATE OR REPLACE PROCEDURE addReservation(
    p_trip_id Trips.trip_id%TYPE,
    p_person_id People.person_id%TYPE,
    p_no_places Reservations.no_places%TYPE
)
AS
BEGIN
    IF hasTripTakenPlace(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'The trip with id ' || p_trip_id || ' took place before');
    END IF;

    INSERT INTO Reservations (trip_id, person_id, status, no_places)
    VALUES (p_trip_id, p_person_id, 'n', p_no_places);

    COMMIT;
END;

-- tests
SELECT trip_id, getAvailablePlaces(trip_id)
FROM Trips;

-- Trip does not exist
BEGIN
    addReservation(5, 1, 1);
END;

-- Person does not exist
BEGIN
    addReservation(2, 213, 1);
END;

-- Took place before
BEGIN
    addReservation(1, 1, 1);
END;

-- Cannot book less than 1 place
BEGIN
    addReservation(4, 1, 0);
END;

-- No available places
BEGIN
    addReservation(4, 1, 1);
END;

-- Not enough places available
BEGIN
    addReservation(2, 1, 6);
END;

-- Correct
BEGIN
    addReservation(2, 1, 5);
END;

SELECT trip_id, getAvailablePlaces(trip_id)
FROM Trips;

DELETE FROM Reservations
WHERE reservation_id = (SELECT MAX(reservation_id) FROM Reservations);


-- b)
CREATE OR REPLACE PROCEDURE modifyReservationStatus(
    p_reservation_id Reservations.reservation_id%TYPE,
    p_status Reservations.status%TYPE
)
AS
BEGIN
    IF NOT doesReservationExist(p_reservation_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'There is no reservation with id ' || p_reservation_id || ' in the database');
    END IF;

    -- If everything is correct, update teh reservation status
    UPDATE Reservations
    SET status = p_status
    WHERE reservation_id = p_reservation_id;

    COMMIT;
END;

-- tests
SELECT *
FROM Reservations;

-- Set the same status as the current one
BEGIN
   modifyReservationStatus(1, 'n');
END;

-- [Error] Change paid reservation status to the new status
BEGIN
   modifyReservationStatus(2, 'n');
END;

-- [Error] Change cancelled reservation status to the new status
BEGIN
   modifyReservationStatus(4, 'n');
END;

SELECT *
FROM Reservations
WHERE status = 'c'
    AND getAvailablePlaces(trip_id) < no_places;

-- [Error] Change cancelled reservation to paid when there are not enough places available
BEGIN
   modifyReservationStatus(10, 'p');
END;

-- [Error] Invalid reservation status
BEGIN
   modifyReservationStatus(10, 'z');
END;

-- [Error] Reservation does not exist
BEGIN
   modifyReservationStatus(12, 'c');
END;

-- Correct modification from paid to cancelled
BEGIN
   modifyReservationStatus(2, 'c');
END;

-- Correct modification from new to cancelled
BEGIN
   modifyReservationStatus(1, 'c');
END;

-- c)
CREATE OR REPLACE PROCEDURE modifyReservationNoPlaces(
    p_reservation_id Reservations.reservation_id%TYPE,
    p_no_places Reservations.no_places%TYPE
)
AS
BEGIN
    IF NOT doesReservationExist(p_reservation_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'There is no reservation with id ' || p_reservation_id || ' in the database');
    END IF;

    UPDATE Reservations
    SET no_places = p_no_places
    WHERE reservation_id = p_reservation_id;

    COMMIT;
END;

-- tests
SELECT reservation_id, no_places, getAvailablePlaces(trip_id) AS available_places
FROM Reservations;

-- [Error] Wrong number of booked places (<= 0)
BEGIN
   modifyReservationNoPlaces(1, 0);
END;

-- [Error] Too many booked places
/*
already booked:              1
can book at most (in total): 5
*/
BEGIN
   modifyReservationNoPlaces(1, 6);
END;

-- Correct
BEGIN
   modifyReservationNoPlaces(1, 3);
END;


-- d)
CREATE OR REPLACE PROCEDURE modifyMaxNoPlaces(
    p_trip_id Trips.trip_id%TYPE,
    p_max_no_places Trips.max_no_places%TYPE
)
AS
BEGIN
    IF NOT doesTripExist(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'There is no trip with id ' || p_trip_id || ' in the database');
    END IF;

    UPDATE Trips
    SET max_no_places = p_max_no_places
    WHERE trip_id = p_trip_id;
END;


-- tests
SELECT trip_id, max_no_places, getBookedPlaces(trip_id) AS booked_places
FROM Trips;

-- [Error] New max_no_places is lower than the total booked places for a trip
BEGIN
   modifyMaxNoPlaces(3, 6);
END;

-- [Error] Trip doesn't exist
BEGIN
   modifyMaxNoPlaces(6, 6);
END;

-- Correct (set the same max_no_places as its current value)
BEGIN
   modifyMaxNoPlaces(4, 8);
END;

-- Correct (modify the max_no_places value)
BEGIN
   modifyMaxNoPlaces(3, 7);
END;
