create database gapsisland;
use gapsisland;

-- Using customer_activity, find the previous activity date for each customer using LAG().
select * from customer_activity;

select activity_id,customer_id, activity_date
from(
   select activity_id,customer_id, activity_date,
   lag(activity_date) over(partition by customer_id order by activity_date) as previous_activity
   from customer_activity
 ) t;
 
 
--  For each customer, calculate the number of days between the current activity_date and the previous activity date.

select customer_id,
     activity_date,
     previous_activity,
     datediff(activity_date, previous_activity) as gap_days
from(  
    select customer_id, activity_date, 
    lag(activity_date) over(partition by customer_id order by activity_date) as  previous_activity
    from customer_activity
) as t;


-- Find the maximum gap between activities for each customer.

with activity_gaps as(
 select customer_id,
     activity_date,
     lag(activity_date) over(partition by customer_id order by activity_date) as previous_activity
     from customer_activity
),
gap_cal as (
 select customer_id,
  activity_date,
  previous_activity,
  datediff(activity_date, previous_activity) as gap_days
  from activity_gaps
)
select customer_id,
  max(gap_days) as max_gap_days
  from gap_cal
  group by customer_id;
  
  
--   Find customers whose maximum activity gap was greater than 5 days.


with activity_gaps as(
 select customer_id,
     activity_date,
     lag(activity_date) over(partition by customer_id order by activity_date) as previous_activity
     from customer_activity
),
gap_cal as (
 select customer_id,
  activity_date,
  previous_activity,
  datediff(activity_date, previous_activity) as gap_days
  from activity_gaps
)
select customer_id,
  max(gap_days) as max_gap_days
  from gap_cal
  group by customer_id
  having max_gap_days > 5;
  
  
--   For each customer, identify groups of consecutive activity dates

with activity_status as(
    select customer_id, activity_date,
    lag(activity_date) over(partition by customer_id order by activity_date) as previous_activity
    from customer_activity
    ),
    marked as (select 
          customer_id, activity_date,
          case when previous_activity is null
             or datediff(activity_date, previous_activity) > 1
             then 1
             else 0
             end as new_group
             from activity_status
    ),
    grouped as(
       select customer_id, activity_date,
       sum(new_group) over(partition by customer_id order by activity_date) as activity_group
       from marked
    )
    select customer_id, activity_date, activity_group
    from grouped
    order by customer_id, activity_date;


-- 
##For each `customer_id + activity_group`:

-- - `island_start` → first activity date 
-- - `island_end` → last activity date 
-- - `island_days` → number of calendar days in the island


with activity_status as (
   select customer_id, activity_date,
   lag(activity_date) over(partition by customer_id order by activity_date) as previous_date
   from customer_activity
),
marked as(
   select customer_id, activity_date,
   case when previous_date is null
   or datediff(activity_date, previous_date) >1
   then 1
   else 0
   end as new_group
   from activity_status
),
grouped as (
select customer_id,activity_date,
sum(new_group) over(partition by customer_id order by activity_date) as activity_group
from marked 
)
select customer_id, activity_group,
min(activity_date) as island_start,
max(activity_date) as island_end,
datediff(
    max(activity_date),
    min(activity_date)
) + 1 as island_days
from grouped
group by customer_id,
activity_group
order by  customer_id,
activity_group;
