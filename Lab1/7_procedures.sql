-- 5. a)
CREATE OR REPLACE PROCEDURE addReservation(
    p_trip_id Trips.trip_id%TYPE,
    p_person_id People.person_id%TYPE,
    p_no_places Reservations.no_places%TYPE
)
AS
    l_available_places INT;
BEGIN
    IF NOT doesPersonExist(p_person_id) THEN
        RAISE_APPLICATION_ERROR(-20000, 'The person with id ' || p_person_id || ' does not exit');
    END IF;

    IF hasTripTakenPlace(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20000, 'The trip with id ' || p_trip_id || ' took place before');
    END IF;

    IF p_no_places < 1 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Cannot book less than 1 place for a trip');
    END IF;

    l_available_places := getAvailablePlaces(p_trip_id);

    IF l_available_places = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'There are no available places for a trip with id ' || p_trip_id);
    ELSIF l_available_places < p_no_places THEN
        RAISE_APPLICATION_ERROR(-20000, 'There are only ' || l_available_places ||
                                        ' available places for a trip with id ' || p_trip_id);
    END IF;

    INSERT INTO Reservations (trip_id, person_id, status, no_places)
    VALUES (p_trip_id, p_person_id, 'n', p_no_places);
END;


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
    addReservation(1, 1, 3);
END;

-- Correct
BEGIN
    addReservation(2, 1, 5);
END;

SELECT trip_id, getAvailablePlaces(trip_id)
FROM Trips;

ROLLBACK;
