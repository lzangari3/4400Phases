create database sams2;
use sams2;
-- ASSUME TABLES NOT COMMITTED
-- Data types need to be checked

create table airline (
    airlineID varchar(50) primary key,
    revenue double not null
);

create table location (
	locID varchar(50) primary key
);

create table passenger (
	personID varchar(50) primary key,
    fname varchar(100) not null,
    lname varchar(100),
    miles int not null,
    funds double not null,
    locID varchar(50) not null,
    
    foreign key(locID) references location(locID)
);

create table vacation (
	sequence varchar(50) not null,
    destination varchar(50) not null,
    passengerID varchar(50) not null,
    
    primary key(sequence, destination, passengerID),
    
    foreign key(passengerID) references passenger(personID)
);

create table pilot (
	personID varchar(50) not null primary key,
    taxID varchar(50) not null,
    fname varchar(100) not null,
    lname varchar(100) not null,
    experience int not null,
    locID varchar(50) not null,
    flightID varchar(50),
    
    foreign key(locID) references location(locID),
    foreign key(flightID) references flight(flightID)
);

create table license (
	aircraft_name varchar(50) not null,
    pilotID varchar(50) not null,
    
    primary key(aircraft_name, pilotID),
    
    foreign key(pilotID) references pilot(personID)
);

create table airplane (
	tail_num varchar(50) not null,
    airlineID varchar(50) not null,
    speed int not null,
    seat_cap int not null,
    filled bool not null,
    locID varchar(50) not null,
    
    foreign key(airlineID) references airline(airlineID),
    foreign key(locID) references location(locID),
    primary key(tail_num, airlineID)
);

create table boeing (
	tail_num varchar(50) not null,
    airlineID varchar(50) not null,
    model varchar(50) not null,
    maintained bool not null,
    
    foreign key(tail_num, airlineID) references airplane(tail_num, airlineID),
    primary key(tail_num, airlineID)
);

create table airbus (
	tail_num varchar(50) not null,
    airlineID varchar(50) not null,
    variant varchar(50) not null,
    
    primary key(tail_num, airlineID),
    
    foreign key(tail_num, airlineID) references airplane(tail_num, airlineID)
);

create table supports (
	progress varchar(50) not null,
    flight_status varchar(50) not null,
    next_time datetime not null,
    flightID varchar(50) not null primary key,
    tail_num varchar(50) not null,
    airlineID varchar(50) not null,
    
    foreign key(flightID) references flight(flightID),
    foreign key(tail_num, airlineID) references airplane(airlineID, tail_num)
);

create table flight (
	flightID varchar(50) not null primary key,
    cost double not null,
    routeID varchar(50) not null,
    
    foreign key(routeID) references route(routeID)
);

create table route_contains_legs (
	routeID varchar(50) not null,
    legID varchar(50) not null,
    sequence varchar(100) not null,
    
    primary key(routeID, legID),
    
    foreign key(routeID) references route(routeID),
    foreign key(legID) references leg(legID)
);

create table leg (
	legID varchar(50) not null primary key,
    distance int not null,
    departing_airportID varchar(50) not null,
    arriving_airportID varchar(50) not null,
    
    foreign key(departing_airportID) references airport(airportID),
    foreign key(arriving_airportID) references airport(airportID)
);

create table airport (
	airportID varchar(50) not null primary key,
    name varchar(100) not null,
    city varchar(100) not null,
    state varchar(100) not null,
    country varchar(100) not null,
    travelers int not null,
    locID varchar(50) not null,
    
    foreign key(locID) references location(locID)
);

create table route (
	routeID varchar(50) not null primary key,
    total_distance varchar(100) not null
);
-- Remember to comment these out
/*
SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables
DROP TABLE if exists passenger; -- we can check deletes with this

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

show tables;
*/

