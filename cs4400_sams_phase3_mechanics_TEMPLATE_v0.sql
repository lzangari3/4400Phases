-- CS4400: Introduction to Database Systems: Monday, March 3, 2025
-- Simple Airline Management System Course Project Mechanics [TEMPLATE] (v0)
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
	returns time reads sql data
begin
	declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);
end //
delimiter ;

-- [1] to [13] stored procedures

-- INSERTED IMPLEMENTATIONS

-- [1] add_airplane()
-- Creates a new airplane associated with a valid airline.
-- Must have a unique tail number for that airline, non-zero seat capacity and speed.
-- Inserts both the airplane and its new, unique location into the database.
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (
    in ip_airlineID varchar(50), in ip_tail_num varchar(50),
    in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_maintenanced boolean, in ip_model varchar(50),
    in ip_neo boolean
)
sp_main: begin
    if ip_airlineID is null or ip_tail_num is null or ip_seat_capacity is null or ip_speed is null or ip_locationID is null then
        leave sp_main;
    end if;
    if ip_seat_capacity <= 0 or ip_speed <= 0 then
        leave sp_main;
    end if;
    if not exists (select 1 from airline where airlineID = ip_airlineID) then -- if airline doesn't exist
        leave sp_main;
    end if;
    if exists (select 1 from airplane where airlineID = ip_airlineID and tail_num = ip_tail_num) then -- does airplane exist
        leave sp_main;
    end if;
    if exists (select 1 from location where locationID = ip_locationID) then -- leave if location alr exists
		leave sp_main;
	end if;
    
    -- insert into location(locationID, city, state, country) values (ip_locationID, null, null, null); -- Check location table
    insert into location(locationID) values (ip_locationID);
    /*
    "airlineID" varchar(50) NOT NULL,
	"tail_num" varchar(50) NOT NULL,
  "seat_capacity" int NOT NULL,
  "speed" int NOT NULL,
  "locationID" varchar(50) DEFAULT NULL,
  "plane_type" varchar(100) DEFAULT NULL,
  "maintenanced" tinyint(1) DEFAULT NULL,
  "model" varchar(50) DEFAULT NULL,
  "neo" tinyint(1) DEFAULT NULL,
    
    */
    insert into airplane(airlineID, tail_num, seat_capacity, speed, locationID, maintenanced, model, neo)
    values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID, ip_maintenanced, ip_model, ip_neo);
end //
delimiter ;

-- [2] add_airport()
-- Creates a new airport with a unique airport ID and a new, unique location.
-- Includes full city, state, and country designation.
-- Adds both airport and location entries.
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (
    in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state varchar(100), in ip_country char(3), in ip_locationID varchar(50)
)
sp_main: begin
    if ip_airportID is null or ip_locationID is null or ip_airport_name is null
		or ip_city is null or ip_state is null or ip_country is null then
        leave sp_main;
    end if;
    if exists (select 1 from airport where airportID = ip_airportID) then -- leave if airportID in use
        leave sp_main;
    end if;
    if exists (select 1 from location where locationID = ip_locationID) then -- leave if locationID in use
        leave sp_main;
    end if;
    insert into location(locationID) values (ip_locationID); -- check location table. 
		/*
		CREATE TABLE "airport" (
	  "airportID" char(3) NOT NULL,
	  "airport_name" varchar(200) DEFAULT NULL,
	  "city" varchar(100) NOT NULL,
	  "state" varchar(100) NOT NULL,
	  "country" char(3) NOT NULL,
	  "locationID" varchar(50) DEFAULT NULL,
	  PRIMARY KEY ("airportID"),
	  KEY "fk2" ("locationID"),
	  CONSTRAINT "fk2" FOREIGN KEY ("locationID") REFERENCES "location" ("locationID")
	)
		*/
    insert into airport(airportID, airport_name, city, state, country, locationID)
    values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_country, ip_locationID);
end //
delimiter ;

-- [3] add_person()
-- Adds a new person to the system with a unique ID and valid location.
-- Requires first name and handles both pilot and passenger roles depending on attributes.
drop procedure if exists add_person;
delimiter //
create procedure add_person (
    in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_miles integer, in ip_funds integer
)
sp_main: begin
    if ip_personID is null or ip_first_name is null or ip_locationID is null then
        leave sp_main;
    end if;
    if not exists (select 1 from location where locationID = ip_locationID) then -- leave if location not valid
        leave sp_main;
    end if;
    if exists (select 1 from person where personID = ip_personID) then -- leave if personID in use
        leave sp_main;
    end if;
    if ip_taxID is not null then
		if exists (select 1 from pilot where taxID = ip_taxID) then -- leave if pilot taxID in use.
			leave sp_main;
		end if;
	end if;
    -- by the time we arrive here, we're ready to make EITHER a pilot or a passenger
    
		/*
		CREATE TABLE "person" (
	  "personID" varchar(50) NOT NULL,
	  "first_name" varchar(100) NOT NULL,
	  "last_name" varchar(100) DEFAULT NULL,
	  "locationID" varchar(50) NOT NULL,
	  PRIMARY KEY ("personID"),
	  KEY "fk8" ("locationID"),
	  CONSTRAINT "fk8" FOREIGN KEY ("locationID") REFERENCES "location" ("locationID")
	)
		*/
    -- we make a person that gets assigned in the next step
    insert into person values (ip_personID, ip_first_name, ip_last_name, ip_locationID);
    
    -- we check for either a pilot or passenger type and assign the above person as their fk --> person
    if ip_taxID is not null then
		insert into pilot values (ip_personID, ip_taxID, ip_experience, null);
    else
		insert into passenger values (ip_personID, ip_miles, ip_funds);
    end if;
    
    
end //
delimiter ;

-- [4] grant_or_revoke_pilot_license()
-- Toggles a pilot license: adds it if not present, removes it if already exists.
-- Used to manage pilot certification dynamically.
drop procedure if exists grant_or_revoke_pilot_license;
delimiter //
create procedure grant_or_revoke_pilot_license (
    in ip_personID varchar(50), in ip_license varchar(100)
)
sp_main: begin
    if ip_personID is null or ip_license is null then
        leave sp_main;
    end if;
    if not exists (select 1 from pilot where personID = ip_personID) then -- we check if this personID relates to a pilot
		leave sp_main;
	end if;
    if exists (select 1 from pilot where personID = ip_personID and license = ip_license) then
        delete from pilot where personID = ip_personID and license = ip_license; -- remove license if exists
    else
        insert into pilot_license(personID, license) values (ip_personID, ip_license);
    end if;
end //
delimiter ;

-- [5] offer_flight()
-- Creates a new flight with a valid route and (optionally) an assigned airplane.
-- Ensures airplane isn’t already in use and flight starts before final stop.
-- Initializes with ground status and provided next_time and cost.
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (
    in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50),
    in ip_progress integer, in ip_next_time time, in ip_cost integer
)
sp_main: begin
	declare plane_speed int;   
    declare total_leg_distance int;
    
    if ip_flightID is null or ip_routeID is null or ip_next_time is null or ip_cost is null then
        leave sp_main;
    end if;
    if not exists (select 1 from route where routeID = ip_routeID) then -- leave if our route isn't valid
        leave sp_main;
    end if;
    
    if ip_support_airline is not null and ip_support_tail is not null then -- we have a plane to assign
        if exists (select 1 from flight where support_airline = ip_support_airline 
			and support_tail = ip_support_tail and status != 'on_ground') then
            leave sp_main; -- leave if associated plane is still active
        end if;
        if not exists (select 1 from airplane where airlineID = ip_support_airline and 
			tail_num = ip_support_tail) then
				leave sp_main; -- leave if plane parameters are not valid plane.
		end if;
        
        -- still assuming that we're given a valid plane
        -- Goal: Our next time must be < routeID's final stop time
        -- we also have our planes speed time
        select speed into plane_speed from airplane -- save plane speed
			where concat(airlineID, tail_num) = concat(ip_airlineID, ip_tail_num);
            
		SELECT SUM(distance) * 3600 / plane_speed into total_leg_distance
		FROM 
			route r JOIN route_path rp ON r.routeID = rp.routeID
			JOIN leg l ON l.legID = rp.legID
		WHERE 
			rp.routeID = ip_routeID and ip_progress < rp.sequence;
            
		-- SELECT ADDTIME('2025-03-31 10:00:00', '02:15:00') AS new_time;
		if ip_next_time > (select leg_time(total_leg_distance, plane_speed)) then
            leave sp_main; -- leave if our next time is after the stop time
		end if;
            
            
    end if; -- end of nester
    

    -- everything has checked out fine, so we do our insertions
    insert into flight(flightID, routeID, support_airline, support_tail, progress, next_time, cost, status)
    values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail,
		ip_progress, ip_next_time, ip_cost, 'on_ground');
end //
delimiter ;

-- [6] flight_landing()
-- Handles a flight landing:
-- Increments flight progress, updates status, and adjusts next_time by 1 hour.
-- Updates passenger miles and pilot experience.
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	declare curr_progress int;
    declare curr_routeID varchar(50);
    
    if ip_flightID is null then leave sp_main; end if;
    if not exists (select 1 from flight where flightID = ip_flightID and status = 'air') then
        leave sp_main; -- leave if flightID isn't valid
    end if;
    
    update flight set status = 'on_ground', next_time = addtime(next_time, '01:00:00'),
		progress = progress + 1
    where flightID = ip_flightID;
    
    select progress into curr_progress from flight where flightID = ip_flightID;
    select routeID into curr_routeID from flight where flightID = ip_flightID;
    
    update pilot set experience = experience + 1 where personID
		in (select personID from pilot where commanding_flight = ip_flightID);
        
    update passenger set miles = miles + (select distance from route_path rp
		join leg l on rp.legID = l.legID where rp.routeID = curr_routeID
			and rp.sequence = curr_progress limit 1);
            
end //
delimiter ;

-- [7] flight_takeoff()
-- Handles takeoff logic based on aircraft type and required number of pilots.
-- If enough pilots: sets flight in air and computes duration using leg_time().
-- Otherwise delays next_time by 30 minutes.
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
    declare v_speed int;
    declare v_distance int;
    declare v_duration time;
    declare plane_type varchar(50);
    
    if ip_flightID is null then leave sp_main; end if;
    if not exists (select 1 from flight where flightID = ip_flightID and status = 'on_ground') then
		leave sp_main; end if; -- leave if invalid flightID or if we're on the ground
        
	-- at this point, ip_flightID is valid
    -- airbus at least one pilot --> has neo variant
    -- boeing at least 2 pilots --> has null neo variant
    
    -- Goal: establish plane type first
    if (select isnull(neo) from flight f join airplane a
		on f.supporting_airline = a.airlineID and f.supporting_tail = a.tail_num) = 1
        then -- plane is boeing
        set plane_type = 'boeing';
        
	else
			set plane_type = 'airbus';
	end if;
			
        
    if (select count(*) from pilot where commanding_flight = ip_flightID) < 1 then
        update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
        leave sp_main;
    end if; -- we do this no matter what plane
    
    if (select count(*) from pilot where commanding_flight = ip_flightID) = 1 and plane_type = 'boeing'
		then
		update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
        leave sp_main;
	end if; -- if boeing wants to take off with 1 < 2 pilots
    
    -- otherwise, we are wanting to take off with 1 or more pilots with boeing being safe.
    -- TODO continue looking here for a correct speed look up. 
    select speed into v_speed from airplane where airlineID = (select support_airline
		from flight where flightID = ip_flightID)
			and tail_num = (select support_tail from flight
			where flightID = ip_flightID);
            
    select distance into v_distance from leg where routeID
		= (select routeID from flight where flightID = ip_flightID)
		and sequence = (select progress from flight where flightID = ip_flightID) + 1;
        
    set v_duration = leg_time(v_distance, v_speed);
    update flight set status = 'air', next_time = addtime(next_time, v_duration)
		where flightID = ip_flightID;
end //
delimiter ;
-- [8] passengers_board()
-- Allows passengers at the departure airport to board a grounded flight.
-- Ensures passengers have funds and destination matches next leg.
-- Limits boarding to seat capacity and deducts ticket cost.
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
	declare v_tail varchar(50);
    declare v_airline varchar(50);
    declare v_loc varchar(50);
    declare v_cost int;
    declare v_cap int;
    if ip_flightID is null then leave sp_main; end if;
    if not exists (select 1 from flight where flightID = ip_flightID and status = 'ground') then
        leave sp_main;
    end if;
    select support_tail, support_airline, cost into v_tail, v_airline, v_cost from flight where flightID = ip_flightID;
    select locationID, seat_cap into v_loc, v_cap from airplane where airlineID = v_airline and tail_num = v_tail;
    insert into passenger(flightID, personID)
    select ip_flightID, personID from person
    where locationID = v_loc and funds >= v_cost
    and personID not in (select personID from passenger)
    limit v_cap;
    update person set funds = funds - v_cost
    where personID in (select personID from passenger where flightID = ip_flightID);
end //
delimiter ;

-- [9] passengers_disembark()
-- Removes passengers from a flight after landing at their next destination.
-- Updates each person’s location to the arrival airport.
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
	declare v_rid varchar(50);
    declare v_prog int;
    declare v_dest varchar(3);
    declare v_loc varchar(50);
    if ip_flightID is null then leave sp_main; end if;
    select routeID, progress into v_rid, v_prog from flight where flightID = ip_flightID;
    select arrives into v_dest from leg where routeID = v_rid and sequence = v_prog;
    select locationID into v_loc from airport where airportID = v_dest;
    update person set locationID = v_loc where personID in (select personID from passenger where flightID = ip_flightID);
    delete from passenger where flightID = ip_flightID;
end //
delimiter ;

-- [10] assign_pilot()
-- Assigns a pilot to a grounded flight if they have the correct license and location.
-- Pilot must not already be assigned to another flight.
-- Updates pilot’s location to airplane.
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), in ip_personID varchar(50))
sp_main: begin
	declare v_model varchar(50);
    declare v_loc varchar(50);
    declare v_tail varchar(50);
    declare v_airline varchar(50);
    if ip_flightID is null or ip_personID is null then leave sp_main; end if;
    select support_airline, support_tail into v_airline, v_tail from flight where flightID = ip_flightID;
    select model, locationID into v_model, v_loc from airplane where airlineID = v_airline and tail_num = v_tail;
    if not exists (select 1 from pilot where personID = ip_personID and license = v_model) then leave sp_main; end if;
    if (select locationID from person where personID = ip_personID) != v_loc then leave sp_main; end if;
    if exists (select 1 from crew where personID = ip_personID) then leave sp_main; end if;
    insert into crew(flightID, personID) values (ip_flightID, ip_personID);
    update person set locationID = v_loc where personID = ip_personID;
end //
delimiter ;

-- [11] recycle_crew()
-- Releases all crew members from a flight if there are no passengers onboard.
-- Called when a flight ends and needs to return pilots to airport.
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
	declare flight_location varchar(50);
    declare airport_location varchar(50);
    
    if ip_flightID is null then leave sp_main; end if; -- leave if id null
    
    -- if exists (select 1 from passenger where flightID = ip_flightID)
		-- then leave sp_main; end if;
        
	if not exists (select 1 from flight where flightID = ip_flightID) then
		leave sp_main; -- leave if the id is not valid
	end if;
	
    if (select airplane_status from flight where flightID = ip_flightID) != 'on_ground' then
		leave sp_main; -- we leave if flight is not on ground
	end if;
    
    -- we now store the location of the airplane
    select locationID into flight_location from flight f join airplane a on
		f.support_airline = a.airlineID and f.support_tail = a.tail_num join location l on 
        a.locationID = l.locationID where f.flightID = ip_flightID;
        
	-- now we go through the pilot table and free pilots from this flight. 
    update pilot set commanding_flight = null where personID in 
		(select personID from pilot where commanding_flight = ip_flightID);
        
	-- we need to store the location of the airport the plane just got to
    select arrival into airport_location from flight f join route_path rp on
		f.routeID = rp.routeID join leg le on le.legID = rp.legID where
		rp.sequence = (select progress from flight where flightID = ip_flightID);
    -- we also need to update the location values for recycled crew
    update person set locationID = airport_location where personID in 
		(select personID from pilot where commanding_flight = ip_flightID);
    
end //
delimiter ;

-- [12] retire_flight()
-- Retires a flight that is on the ground, at the start or end of its route,
-- and has no passengers or crew left onboard.
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
	declare v_status varchar(10);
    declare v_prog int;
    declare v_max int;
    if ip_flightID is null then leave sp_main; end if;
    select status, progress into v_status, v_prog from flight where flightID = ip_flightID;
    select max(sequence) into v_max from leg where routeID = (select routeID from flight where flightID = ip_flightID);
    if v_status != 'on_ground' then leave sp_main; end if;
    if v_prog != 0 and v_prog != v_max then leave sp_main; end if;
    if exists (select 1 from passenger where flightID = ip_flightID) then leave sp_main; end if;
    if exists (select 1 from crew where flightID = ip_flightID) then leave sp_main; end if;
    update flight set status = 'ended' where flightID = ip_flightID;
end //
delimiter ;

-- [13] simulation_cycle()
-- Advances simulation by processing the flight with the earliest next_time.
-- If in air: lands and disembarks. If grounded: boards and takes off.
-- If flight has ended: recycles crew and retires the flight.
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin
    declare v_flightID varchar(50);
    declare v_status varchar(10);
    select flightID, status into v_flightID, v_status
    from flight
    where next_time = (select min(next_time) from flight where status != 'ended')
    order by field(status, 'air', 'ground'), flightID limit 1;
    if v_status = 'air' then
        call flight_landing(v_flightID);
        call passengers_disembark(v_flightID);
    else
        call passengers_board(v_flightID);
        call flight_takeoff(v_flightID);
    end if;
    if exists (
        select 1 from flight
        where flightID = v_flightID and status = 'ground'
          and progress = (select max(sequence) from leg where routeID = (select routeID from flight where flightID = v_flightID))
    ) then
        call recycle_crew(v_flightID);
        call retire_flight(v_flightID);
    end if;
end //
delimiter ;

-- [14] to [19] views

-- [14] flights_in_the_air()
-- Displays flights currently in the air.
-- Shows departure and arrival airports, number of flights, flight IDs,
-- airplane IDs, and earliest/latest arrival times grouped by route.
create or replace view flights_in_the_air as
select l.depart as departing_from,
       l.arrives as arriving_at,
       count(distinct f.flightID) as num_flights,
       group_concat(distinct f.flightID order by f.flightID) as flight_list,
       min(f.next_time) as earliest_arrival,
       max(f.next_time) as latest_arrival,
       group_concat(distinct f.support_tail order by f.support_tail) as airplane_list
from flight f
join route r on f.routeID = r.routeID
join leg l on r.routeID = l.routeID and l.sequence = f.progress + 1
where f.status = 'air'
group by l.depart, l.arrives;

-- [15] flights_on_the_ground()
-- Displays flights currently on the ground.
-- Shows departing airport, number of flights, flight IDs,
-- airplane IDs, and earliest/latest scheduled arrivals.
create or replace view flights_on_the_ground as
select l.depart as departing_from,
       count(distinct f.flightID) as num_flights,
       group_concat(distinct f.flightID order by f.flightID) as flight_list,
       min(f.next_time) as earliest_arrival,
       max(f.next_time) as latest_arrival,
       group_concat(distinct f.support_tail order by f.support_tail) as airplane_list
from flight f
join route r on f.routeID = r.routeID
join leg l on r.routeID = l.routeID and l.sequence = f.progress + 1
where f.status = 'ground'
group by l.depart;

-- [16] people_in_the_air()
-- Shows who is currently in the air.
-- Includes route info, airplane IDs, flight IDs, arrival times,
-- number of pilots, number of passengers, and full passenger list.
create or replace view people_in_the_air as
select l.depart as departing_from,
       l.arrives as arriving_at,
       count(distinct a.locationID) as num_airplanes,
       group_concat(distinct a.locationID order by a.locationID) as airplane_list,
       group_concat(distinct f.flightID order by f.flightID) as flight_list,
       min(f.next_time) as earliest_arrival,
       max(f.next_time) as latest_arrival,
       count(distinct pc.personID) as num_pilots,
       count(distinct pp.personID) as num_passengers,
       count(distinct p.personID) as joint_pilots_passengers,
       group_concat(distinct p.personID order by p.personID) as person_list
from flight f
join route r on f.routeID = r.routeID
join leg l on r.routeID = l.routeID and l.sequence = f.progress + 1
join airplane a on a.airlineID = f.support_airline and a.tail_num = f.support_tail
left join crew pc on pc.flightID = f.flightID
left join passenger pp on pp.flightID = f.flightID
left join person p on p.personID = pc.personID or p.personID = pp.personID
where f.status = 'air'
group by l.depart, l.arrives;

-- [17] people_on_the_ground()
-- Shows people located at airports on the ground.
-- Lists airport details, city/state/country, counts of passengers and pilots,
-- and the full list of people by ID.
create or replace view people_on_the_ground as
select ap.airportID as departing_from,
       ap.locationID as airport,
       ap.name as airport_name,
       l.city,
       l.state,
       l.country,
       sum(case when p.personID in (select personID from crew) then 1 else 0 end) as num_pilots,
       sum(case when p.personID in (select personID from passenger) then 1 else 0 end) as num_passengers,
       count(p.personID) as joint_pilots_passengers,
       group_concat(distinct p.personID order by p.personID) as person_list
from person p
join location l on p.locationID = l.locationID
join airport ap on ap.locationID = l.locationID
group by ap.airportID, ap.locationID, ap.name, l.city, l.state, l.country;

-- [18] route_summary()
-- Summarizes every route by showing number of legs, total distance,
-- airport sequence, leg path summary, and associated flights.
create or replace view route_summary as
select r.routeID as route,
       count(l.legID) as num_legs,
       group_concat(concat(l.sequence, ':', l.depart, '->', l.arrives) order by l.sequence) as leg_sequence,
       sum(l.distance) as route_length,
       count(distinct f.flightID) as num_flights,
       group_concat(distinct f.flightID order by f.flightID) as flight_list,
       group_concat(distinct l.depart order by l.sequence) as airport_sequence
from route r
join leg l on r.routeID = l.routeID
left join flight f on r.routeID = f.routeID
group by r.routeID;

-- [19] alternative_airports()
-- Identifies cities/states that have more than one airport.
-- Lists all airport codes and names in those locations.
create or replace view alternative_airports as
select l.city, l.state, l.country,
       count(distinct a.airportID) as num_airports,
       group_concat(distinct a.airportID order by a.airportID) as airport_code_list,
       group_concat(distinct a.name order by a.name) as airport_name_list
from airport a
join location l on a.locationID = l.locationID
group by l.city, l.state, l.country
having count(distinct a.airportID) > 1;
