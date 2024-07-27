select * from reservation;
-- checking for duplicates
select Booking_ID, count(*) from reservation Res
group by Booking_ID
having count(*) >1;

-- Format the arrival_date
update reservation 
set arrival_date = str_to_date(arrival_date, '%d-%m-%Y');

-- Add column 
alter table reservation
add column Booking_Date date;
update reservation
set Booking_Date = date_sub(arrival_date,interval lead_time Day);

-- 1. What is the total number of reservations in the dataset?
select count(*) as Total_Reservations from reservation;

-- 2. Which meal plan is the most popular among guests?
select type_of_meal_plan, 
count(type_of_meal_plan) as count from reservation
Where booking_status = "Not_Canceled"
group by type_of_meal_plan
order by count desc
limit 1;

-- 3. What is the average price per room for reservations involving children? 
select avg(avg_price_per_room) as 
overall_average_price__per_room_for_children from reservation
where no_of_children > 0;

-- 4. How many reservations were made for the year 20XX (replace XX with the desired year)?
alter table reservation
add column Booking_Date date;
update reservation
set Booking_Date = date_sub(arrival_date,interval lead_time Day);
select year(Booking_Date) as Year, 
count(year(Booking_Date)) as Reservations_in_year from reservation
where year(Booking_Date) = "2018"
group by year(Booking_Date);


-- 5. What is the most commonly booked room type? 
select room_type_reserved, count(room_type_reserved) as count from reservation 
group by room_type_reserved
order by count desc
limit 1;

-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)? 
select count(*) as weekend_reservations
from reservation
where no_of_weekend_nights > 0;

-- 7. What is the highest and lowest lead time for reservations? 
select max(lead_time) as Highest_lead_time,
 min(lead_time) as Lowest_lead_time
from reservation;

-- 8.  What is the most common market segment type for reservations?
select market_segment_type, count(market_segment_type) as count from reservation
group by market_segment_type
order by count desc
limit 1;

-- 9.  How many reservations have a booking status of "Confirmed"? 
select count(*) as confirmed_reservation from reservation
where booking_status = "Not_Canceled";

-- 10.  What is the total number of adults and children across all reservations?
select sum(no_of_Adults) as Total_Adults,
 sum(no_of_children) as Total_children,
 sum(no_of_adults + no_of_children) as Total_Number_of_Adults_and_Children 
 from reservation;

-- 11.  What is the average number of weekend nights for reservations involving children? 
select avg(no_of_weekend_nights) as Averge_Weekend_Nights from reservation
where no_of_children > 0;

set sql_safe_updates = 0;
update reservation set arrival_date = str_to_date(arrival_date, '%d-%m-%Y'); 
-- 12.  How many reservations were made in each month of the year?
select month(Booking_Date) as month_Number, monthname(Booking_Date) as month,
count(*) as count_of_reservation from reservation
group by month(Booking_Date),monthname(Booking_Date)
order by month_Number;

-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type? 
select room_type_reserved,
 avg(no_of_week_nights+no_of_weekend_nights) as avg_nights from reservation
where booking_status = "Not_Canceled"
group by room_type_reserved
order by avg_nights desc;

-- 14. For reservations involving children, what is the most common room type, and what is the average  price for that room type?
select room_type_reserved,count(*) as room_type, 
avg(avg_price_per_room) as average_price from reservation
where no_of_children > 0
group by room_type_reserved
order by room_type desc
limit 1;

-- 15.  Find the market segment type that generates the highest average price per room.
select market_segment_type,avg(avg_price_per_room) as average_price from reservation
group by market_segment_type
order by average_price desc
limit 1;
