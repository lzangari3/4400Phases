create database sams2;
-- ASSUME TABLES NOT COMMITTED
-- Data types need to be checked
create table passenger (
	person_id varchar(255) primary key,
    fname varchar(255) not null,
    lname varchar(255),
    miles double,
    funds double
);

create table vacation (
	sequence varchar(255) not null,
    destination varchar(255) not null,
    passenger_id varchar(255),
    primary key(sequence, destination, passenger_id), -- pkey
    foreign key(passenger_id) references passenger(person_id) 
		on delete cascade on update restrict -- fkey
);

create table pilot (
	person_id varchar(255) primary key,
    tax_id int not null,
    fname varchar(255) not null,
    lname varchar(255) not null,
    experience int not null
);

create table license (
	pilot_id varchar(255) not null,
    license_id varchar(255) not null,
    primary key(pilot_id, license_id),
    foreign key(pilot_id) references pilot(person_id) on delete cascade on update restrict
);

create table location (
	loc_id varchar(255) primary key,
    type varchar(5) not null, -- this will be for like 'port' or 'plane'
    
    -- these are for airplanes --> 'plane' type
    seat_cap int, -- can be null since not required
    speed int, -- can be null
    owning_airline varchar(255),
    filled varchar(1), -- will be calculated as 't' or 'f'
    
    -- these are for airports --> 'port' type
    airport_id varchar(255),
    airport_name varchar(255),
    city varchar(255),
    state varchar(255),
    country varchar(255),

	foreign key(owning_airline) references airline(airline_id) on delete cascade
);

create table airline (
	airline_id varchar(255) primary key,
    revenue double not null
);

SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables
DROP TABLE if exists passenger; -- we can check deletes with this

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

show tables;


