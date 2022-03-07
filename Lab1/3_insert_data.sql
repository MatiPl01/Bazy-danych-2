-- People table
INSERT INTO People (firstname, lastname)
VALUES ('Adam', 'Kowalski');

INSERT INTO People (firstname, lastname)
VALUES ('Jan', 'Nowak');

INSERT INTO People (firstname, lastname)
VALUES ('Andrzej', 'Kowalczyk');

INSERT INTO People (firstname, lastname)
VALUES ('Anna', 'Klimek');

INSERT INTO People (firstname, lastname)
VALUES ('Zbigniew', 'Zygora');

INSERT INTO People (firstname, lastname)
VALUES ('Rafał', 'Noga');

INSERT INTO People (firstname, lastname)
VALUES ('Aleksandra', 'Sobczak');

INSERT INTO People (firstname, lastname)
VALUES ('Maryla', 'Ordon');

INSERT INTO People (firstname, lastname)
VALUES ('Piotr', 'Słota');

INSERT INTO People (firstname, lastname)
VALUES ('Aleks', 'Stachowiak');

COMMIT;

SELECT * FROM People;


-- Trips table
INSERT INTO Trips (name, country, trip_date, max_no_places)
VALUES ('wycieczka do Paryza', 'Francja', TO_DATE('2021-09-03', 'yyyy-mm-dd'), 5);

INSERT INTO Trips (name, country, trip_date, max_no_places)
VALUES ('wycieczka do Krakowa', 'Polska', TO_DATE('2022-12-05', 'yyyy-mm-dd'), 8);

INSERT INTO Trips (name, country, trip_date, max_no_places)
VALUES ('wycieczka do Warszawy', 'Polska', TO_DATE('2022-04-11', 'yyyy-mm-dd'), 12);

INSERT INTO Trips (name, country, trip_date, max_no_places)
VALUES ('wycieczka do Madrytu', 'Hiszpania', TO_DATE('2022-07-02', 'yyyy-mm-dd'), 8);

COMMIT;

SELECT * FROM Trips;


-- Reservations table
INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (1, 1, 1, 'n');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (1, 2, 2, 'p');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (2, 1, 1, 'p');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (2, 2, 1, 'c');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (2, 4, 2, 'n');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (3, 5, 4, 'c');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (3, 5, 3, 'n');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (3, 6, 4, 'p');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (4, 7, 3, 'p');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (4, 9, 1, 'c');

INSERT INTO Reservations (trip_id, person_id, no_places, status)
VALUES (4, 8, 5, 'n');

COMMIT;

-- select trip_id, MAX_NO_PLACES, GETAVAILABLEPLACES(TRIP_ID) from trips;
-- delete from reservations;
-- ALTER TABLE RESERVATIONS MODIFY(RESERVATION_ID GENERATED AS IDENTITY (START WITH 1));

SELECT * FROM Reservations;
