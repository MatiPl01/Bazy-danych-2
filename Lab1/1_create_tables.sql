--tables
create table person (
  person_id int generated always as identity not null,
  firstname varchar2(50),
  lastname varchar2(50),
  constraint person_pk primary key (person_id)
  enable
);

create table trip (
  trip_id int generated always as identity not null,
  name varchar2(100),
  country varchar2(50),
  trip_date date,
  max_no_places int,
  constraint trip_pk primary key (trip_id)
  enable
);

create table reservation(
  reservation_id int generated always as identity not null,
  trip_id int,
  person_id int,
  status char(1),
  no_places int,
  constraint reservation_pk primary key (reservation_id)
  enable
);

alter table reservation
add constraint reservation_fk1 foreign key (person_id)
references person(person_id)
enable;

alter table reservation
add constraint reservation_fk2 foreign key (trip_id)
references trip(trip_id)
enable;

alter table reservation
add constraint reservation_chk1 check (status in ('n','p','c'))
enable;
