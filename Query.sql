1. Identify the country which has produced the most F1 drivers.

select *
from
	(select nationality, count(1)as no_racers
	,rank() over(order by count(1) desc) ranking_based_number_of_F1_drivers
	from drivers d
	group by nationality)
where ranking_based_number_of_F1_drivers = 1

2. Which country has produced the most no of F1 circuits

select *
from
	(select country, count(1) as total_no_of_circuits
	 ,rank() over(order by count(1) desc) ranking_based_number_of_circuits
	from circuits c
	group by country)
where ranking_based_number_of_circuits = 1

3. Which countries have produced exactly 5 constructors?

select *
from
	(select nationality, count(1) as total_no_of_constructors
	from constructors c
	group by nationality)
where total_no_of_constructors = 5
 
4. List down the no of races that have taken place each year

select year, count(1) total_no_race
from races r
group by year
order by total_no_race desc

5. Who is the youngest and oldest F1 driver?

select max(case when rn=1 then forename|| ' '|| surname end) as eldest_driver
,max(case when rn=count then forename|| ' '|| surname end) as youngest_driver
from 
	(select *,
	 row_number() over(order by dob) as rn
	,count(*) over() 
	 from drivers d)
where rn = 1 or rn=count

6. List down the no of races that have taken place each year and mentioned which was the first and the last race of each season.

select distinct year, count(1)total_no_of_races,
first_value(year) over() as first_race_of_season
,last_value(year) over(range between unbounded preceding and unbounded following) as last_race_of_season
from races r
group by year

	
7. Which circuit has hosted the most no of races. Display the circuit name, no of races, city and country.

with no_of_circuits as
	(select c.circuitid, count(1) as total_races
	from circuits c 
	join races r on c.circuitid = r.circuitid
	group by c.circuitid
	order by c.circuitid)
select distinct c.name as circuit_name, total_races, c.location as city, c.country
from no_of_circuits
join circuits c on c.circuitid = no_of_circuits.circuitid
join races r on r.circuitid = c.circuitid
order by total_races desc

8. Display the following for 2022 season:
   Year, Race_no, circuit name, driver name, driver race position, driver race points, flag to indicate if winner, constructor name, constructor position, 
   constructor points, , flag to indicate if constructor is winner,
   race status of each driver, flag to indicate fastest lap for which driver, total no of pit stops by each driver

select r.raceid, r.year, r.round as race_no, r.name as circuit_name, concat(d.forename,' ',d.surname) as driver_name
		, ds.position as driver_position, ds.points as driver_points, case when ds.position=1 then 'WINNER' end as winner_flag
		, c.name as constructor_name, cs.position as constructor_position, cs.points as constructor_points
		, case when cs.position=1 then 'WINNER' end as cons_winner_flag, sts.status
		, case when lp.driverid is not null then 'Faster Lap' end as fastest_lap_indi, pt.no_of_stops
		from races r
		join driver_standings ds on ds.raceid=r.raceid
		join drivers d on d.driverid = ds.driverid
		join constructor_standings cs on cs.raceid=r.raceid 
		join constructors c on c.constructorid=cs.constructorid
		join results res on res.raceid=r.raceid and res.driverid=ds.driverid and res.constructorid=cs.constructorid
		join status sts on sts.statusid=res.statusid
		left join (	select lp.raceid, lp.driverid
					from lap_times lp
					join (	select raceid, min(time) as fastest_lap
							from lap_times
							group by raceid) x on x.raceid=lp.raceid and x.fastest_lap=lp.time
				 ) lp on lp.driverid = ds.driverid and lp.raceid=r.raceid
		left join (	select raceid,driverid, count(1) as no_of_stops
					from pit_stops
					group by raceid,driverid) pt on pt.driverid = ds.driverid and pt.raceid=r.raceid
		where year=2022 --and r.raceid=1074
		order by year, race_no, driver_position;


9. List down the names of all F1 champions and the no of times they have won it.

with cte as
		(select r.year, d.forename|| ' '||surname as drivers_name,
		sum(res.points) as tot_points
		,rank() over(partition by r.year order by sum(res.points)desc ) rnk
		from races r
		join driver_standings ds on r.raceid = ds.raceid
		join drivers d on d.driverid = ds.driverid
		join results res on res.driverid = ds.driverid and res.raceid = r.raceid
		group by d.driverid, r.year, d.forename, d.surname),
 	only_rnk_1 as
		(select * from cte where rnk =1)
select drivers_name, count(1) no_of_championship_won
from only_rnk_1
group by drivers_name
order by no_of_championship_won desc

10) Who has won the most constructor championships
	
with cte as		
		(select r.year, c.name as constructor_name,
		sum(cr.points) as tot_points
		,rank() over(partition by r.year order by sum(cr.points) desc) rnk
		from races r
		join constructor_standings cs on r.raceid = cs.raceid	
		join constructors c on c.constructorid = cs.constructorid
		join constructor_results cr on c.constructorid = cr.constructorid and cr.raceid=r.raceid
		group by r.year, c.constructorid, c.name),
	only_rnk_1 as
		(select * from cte where rnk =1)
select constructor_name, count(1) as no_of_championship_won
from only_rnk_1
group by constructor_name
order by no_of_championship_won desc
	
select * from seasons; -- 74
select * from status; -- 139	
select * from circuits; -- 77
select * from races; -- 1102
select * from drivers; -- 857
select * from constructors; -- 211
select * from constructor_results; -- 12170
select * from constructor_standings; -- 12941
select * from driver_standings; -- 33902
select * from lap_times; -- 538121
select * from pit_stops; -- 9634
select * from qualifying; -- 9575
select * from results; -- 25840
select * from sprint_results; -- 120


