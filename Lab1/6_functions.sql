/*
SCALAR FUNCTIONS
*/
CREATE OR REPLACE FUNCTION getBookedPlaces(
    p_trip_id Trips.trip_id%TYPE
)
RETURN Reservations.no_places%TYPE
AS
    l_booked_places Reservations.no_places%TYPE;
BEGIN
    SELECT NVL(SUM(no_places), 0)
    INTO l_booked_places
    FROM Reservations
    WHERE trip_id = p_trip_id
        AND status != 'c';

    RETURN l_booked_places;
END;


CREATE OR REPLACE FUNCTION getAvailablePlaces(
    p_trip_id Trips.trip_id%TYPE
)
RETURN Reservations.no_places%TYPE
AS
    l_available_places Trips.max_no_places%TYPE;
BEGIN
    SELECT max_no_places - getBookedPlaces(trip_id)
    INTO l_available_places
    FROM Trips
    WHERE trip_id = p_trip_id;

    RETURN l_available_places;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Trip with id: ' || p_trip_id || ' does not exist');
            RETURN NULL;
END;

-- BEGIN
--     DBMS_OUTPUT.PUT_LINE(GetAvailablePlaces(6));
-- END;

CREATE OR REPLACE FUNCTION doesTripExist(
    p_trip_id Trips.trip_id%TYPE
)
RETURN BOOLEAN
AS
    exist NUMBER;
BEGIN
   SELECT
        CASE
            WHEN EXISTS(SELECT * FROM Trips WHERE trip_id = p_trip_id) THEN 1
            ELSE 0
        END
   INTO exist
   FROM Dual;

   IF exist = 1 THEN
       RETURN TRUE;
   ELSE
       RETURN FALSE;
   END IF;
END;


CREATE OR REPLACE FUNCTION doesPersonExist(
    p_person_id People.person_id%TYPE
)
RETURN BOOLEAN
AS
    exist NUMBER;
BEGIN
   SELECT
        CASE
            WHEN EXISTS(SELECT * FROM People WHERE person_id = p_person_id) THEN 1
            ELSE 0
        END
   INTO exist
   FROM Dual;

   IF exist = 1 THEN
       RETURN TRUE;
   ELSE
       RETURN FALSE;
   END IF;
END;


CREATE OR REPLACE FUNCTION doesReservationExist(
    p_reservation_id Reservations.reservation_id%TYPE
)
RETURN BOOLEAN
AS
    exist NUMBER;
BEGIN
   SELECT
        CASE
            WHEN EXISTS(SELECT * FROM Reservations WHERE reservation_id = p_reservation_id) THEN 1
            ELSE 0
        END
   INTO exist
   FROM Dual;

   IF exist = 1 THEN
       RETURN TRUE;
   ELSE
       RETURN FALSE;
   END IF;
END;


CREATE OR REPLACE FUNCTION hasTripTakenPlace(
    p_trip_id Trips.trip_id%TYPE,
    p_date DATE DEFAULT SYSDATE
)
RETURN BOOLEAN
AS
    l_trip_date DATE;
BEGIN
    IF NOT doesTripExist(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20000, 'There is no trip with id ' || p_trip_id || ' in the database');
    END IF;

    SELECT trip_date
    INTO l_trip_date
    FROM Trips
    WHERE trip_id = p_trip_id;

    IF l_trip_date <= p_date THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

/*
TABLE FUNCTIONS
*/
-- 4. a)
CREATE OR REPLACE FUNCTION getTripParticipants(
    p_trip_id Trips.trip_id%TYPE
)
RETURN TripParticipantsTable
AS
    l_result TripParticipantsTable;
BEGIN
    IF NOT doesTripExist(p_trip_id) THEN
        RAISE_APPLICATION_ERROR(-20000, 'There are is no trip with id ' || p_trip_id || ' in the database');
    END IF;

    SELECT TripParticipantObject(
        firstname,
        lastname,
        reservation_id,
        no_places,
        status
    )
    BULK COLLECT INTO l_result
    FROM ReservationsView
    WHERE trip_id = p_trip_id
        AND status != 'c';

    RETURN l_result;
END;

SELECT * FROM getTripParticipants(1);
SELECT * FROM getTripParticipants(2);
SELECT * FROM getTripParticipants(3);
SELECT * FROM getTripParticipants(4);
SELECT * FROM getTripParticipants(5);


-- 4. b)
CREATE OR REPLACE FUNCTION getPersonReservations(
    p_person_id People.person_id%TYPE
)
RETURN PeopleReservationsTable
AS
    l_result PeopleReservationsTable;
BEGIN
    IF NOT doesPersonExist(p_person_id) THEN
        RAISE_APPLICATION_ERROR(-20000, 'There is no person with id ' || p_person_id || ' in the database');
    END IF;

    SELECT PersonReservationObject(
        trip_id,
        country,
        trip_date,
        trip_name,
        reservation_id,
        no_places,
        status
    )
    BULK COLLECT INTO l_result
    FROM ReservationsView
    WHERE person_id = p_person_id;

    RETURN l_result;
END;

SELECT * FROM getPersonReservations(1);
SELECT * FROM getPersonReservations(2);
SELECT * FROM getPersonReservations(3);
SELECT * FROM getPersonReservations(4);
SELECT * FROM getPersonReservations(5);  -- this person has no trips
SELECT * FROM getPersonReservations(11); -- there is no person with id 11


-- 4. c) (When there are no remaining places, a trip is considered unavailable - see France below)
CREATE OR REPLACE FUNCTION getAvailableTripsTo(
    p_country_name Trips.country%TYPE,
    p_from_date DATE,
    p_to_date DATE
)
RETURN AvailableTripsTable
AS
    l_result AvailableTripsTable;
BEGIN
    SELECT AvailableTripObject(
        trip_id,
        trip_name,
        country,
        trip_date,
        max_no_places
    )
    BULK COLLECT
    INTO l_result
    FROM AvailableTripsView
    WHERE country = p_country_name
        AND trip_date BETWEEN p_from_date AND p_to_date;

    RETURN l_result;
END;

SELECT * FROM getAvailableTripsTo('Polska', '2020-01-01', '2022-12-31');
SELECT * FROM getAvailableTripsTo('Francja', '2020-01-01', '2022-12-31');
SELECT * FROM getAvailableTripsTo('Chiny', '2020-01-01', '2022-12-31');
SELECT * FROM getAvailableTripsTo('Polska', '2022-06-01', '2022-12-31');
