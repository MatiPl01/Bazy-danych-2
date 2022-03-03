-- person table
insert into person (firstname, lastname)
values('adam', 'kowalski');

insert into person (firstname, lastname)
values('jan', 'nowak');

insert into person (firstname, lastname)
values('andrzej', 'kowalczyk');

insert into person (firstname, lastname)
values('anna', 'klimek');

insert into person (firstname, lastname)
values('zbigniew', 'zygora');

insert into person (firstname, lastname)
values('rafał', 'noga');

insert into person (firstname, lastname)
values('aleksandra', 'sobczak');

insert into person (firstname, lastname)
values('maryla', 'ordon');

insert into person (firstname, lastname)
values('piotr', 'słota');

insert into person (firstname, lastname)
values('aleks', 'stachowiak');

select * from person;

-- trip table
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do paryza', 'francja', to_date('2021-09-03', 'yyyy-mm-dd'), 3);

insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do krakowa', 'polska', to_date('2022-12-05', 'yyyy-mm-dd'), 2);

insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do warszawy', 'polska', to_date('2022-04-11', 'yyyy-mm-dd'), 4);

insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do madrytu', 'hiszpania', to_date('2022-07-02', 'yyyy-mm-dd'), 5);

select * from trip;

-- reservation table
insert into reservation(trip_id, person_id, no_places, status)
values (1, 1, 1, 'n');

insert into reservation(trip_id, person_id, no_places, status)
values (1, 2, 2, 'p');

insert into reservation(trip_id, person_id, no_places, status)
values (2, 1, 1, 'p');

insert into reservation(trip_id, person_id, no_places, status)
values (2, 2, 1, 'c');

insert into reservation(trip_id, person_id, no_places, status)
values (2, 4, 2, 'n');

insert into reservation(trip_id, person_id, no_places, status)
values (3, 2, 4, 'c');

insert into reservation(trip_id, person_id, no_places, status)
values (3, 3, 3, 'n');

insert into reservation(trip_id, person_id, no_places, status)
values (3, 4, 4, 'p');

insert into reservation(trip_id, person_id, no_places, status)
values (4, 1, 3, 'p');

insert into reservation(trip_id, person_id, no_places, status)
values (4, 3, 5, 'n');

select * from reservation;
