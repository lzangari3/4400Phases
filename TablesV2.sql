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

SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables
DROP TABLE if exists passenger; -- we can check deletes with this

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

show tables;


