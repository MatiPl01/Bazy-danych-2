CREATE TABLE People (
  person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  firstname VARCHAR2(50),
  lastname VARCHAR2(50),
  CONSTRAINT people_pk PRIMARY KEY (person_id)
);

CREATE TABLE Trips (
  trip_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  name VARCHAR2(100),
  country VARCHAR2(50),
  trip_date DATE,
  max_no_places INT,
  CONSTRAINT trips_pk PRIMARY KEY (trip_id)
);

CREATE TABLE Reservations (
  reservation_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  trip_id INT,
  person_id INT,
  status CHAR(1),
  no_places INT,
  CONSTRAINT reservations_pk PRIMARY KEY (reservation_id)
);
