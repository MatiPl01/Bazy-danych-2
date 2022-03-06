SELECT SEQUENCE_NAME FROM USER_SEQUENCES;
PURGE RECYCLEBIN;


CREATE TABLE People (
    person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    firstname VARCHAR2(50) NOT NULL,
    lastname VARCHAR2(50) NOT NULL,
    CONSTRAINT People_pk PRIMARY KEY (person_id)
);

CREATE TABLE Trips (
    trip_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    name VARCHAR2(100) NOT NULL,
    country VARCHAR2(50) NOT NULL,
    trip_date DATE NOT NULL,
    max_no_places INT NOT NULL,
    CONSTRAINT Trips_pk PRIMARY KEY (trip_id)
);

CREATE TABLE Reservations (
    reservation_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    trip_id INT NOT NULL,
    person_id INT NOT NULL,
    status CHAR(1) NOT NULL,
    no_places INT NOT NULL,
    CONSTRAINT Reservations_pk PRIMARY KEY (reservation_id)
);

CREATE TABLE ReservationsLog (
    log_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    reservation_id INT NOT NULL,
    log_date DATE NOT NULL,
    status CHAR(1) NOT NULL,
    no_places INT NOT NULL,
    CONSTRAINT ReservationsLog_pk PRIMARY KEY (log_id)
);
