-- 4. a)
CREATE OR REPLACE TYPE TripParticipantObject AS OBJECT (
    firstname VARCHAR2(50),
    lastname VARCHAR2(50),
    reservation_id INT,
    no_places INT,
    status CHAR(1)
);

CREATE OR REPLACE TYPE TripParticipantsTable IS TABLE OF TripParticipantObject;

-- 4. b)
CREATE OR REPLACE TYPE PersonReservationObject AS OBJECT (
    trip_id INT,
    country VARCHAR2(50),
    trip_date DATE,
    trip_name VARCHAR2(100),
    reservation_id INT,
    no_places INT,
    status CHAR(1)
);

CREATE OR REPLACE TYPE PeopleReservationsTable IS TABLE OF PersonReservationObject;

-- 4. c)
CREATE OR REPLACE TYPE AvailableTripObject AS OBJECT (
    trip_id INT,
    name VARCHAR2(100),
    country VARCHAR2(50),
    trip_date DATE,
    max_no_places INT
);

CREATE OR REPLACE TYPE AvailableTripsTable IS TABLE OF AvailableTripObject;
