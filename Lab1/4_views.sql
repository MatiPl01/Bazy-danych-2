-- 3. a) reservations
CREATE OR REPLACE VIEW ReservationsView
AS
SELECT
    t.trip_id,
    t.country,
    t.trip_date,
    t.name AS trip_name,
    p.person_id,
    p.firstname,
    p.lastname,
    r.reservation_id,
    r.no_places,
    r.status
FROM Trips t
INNER JOIN Reservations r
ON r.trip_id = t.trip_id
INNER JOIN People p
on p.person_id = r.person_id;

SELECT * FROM ReservationsView;


-- 3. b) trips
CREATE OR REPLACE VIEW TripsView
AS
SELECT
    trip_id,
    country,
    trip_date,
    name AS trip_name,
    max_no_places,
    getAvailablePlaces(trip_id) AS no_available_places
FROM Trips;

SELECT * FROM TripsView;


-- 3. c) available_trips
CREATE OR REPLACE VIEW AvailableTripsView
AS
SELECT *
FROM TripsView
WHERE trip_date > SYSDATE
    AND no_available_places > 0;

SELECT * FROM AvailableTripsView;
