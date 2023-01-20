 -- 1. How many olympics games have been held? --
 select count(distinct Games)
 from athlete_events;
 
 -- 2.List down all Olympics games held so far. --
 select distinct Games,Year,City
 from athlete_events;
 
 -- 3. Mention the total no of nations who participated in each olympics game? --
 
 select 
 count(distinct noc_regions.region),
 athlete_events.Games
 from athlete_events
 join noc_regions
 on athlete_events.NOC = noc_regions.NOC
 group by athlete_events.Games
 order by Games, noc_regions.region;
 
 -- 4. Which year saw the highest and lowest no of countries participating in olympics --
 select 
 count(distinct noc_regions.region),
 athlete_events.Games
 from athlete_events
 join noc_regions
 on athlete_events.NOC = noc_regions.NOC
 group by athlete_events.Games
 order by count(distinct noc_regions.region), Games;
 
 -- 5). Which nation has participated in all of the olympic games? --
 
 
 select region_game.region, count(distinct region_game.Games) as freq 
 from 
 (select noc_regions.NOC,
 noc_regions.region,
 athlete_events.Games
 from athlete_events
 join noc_regions
 on athlete_events.NOC = noc_regions.NOC ) as region_game
 group by region_game.region;
 
 -- 6. Identify the sport which was played in all summer olympics. --
 

 with Q1 as
 
 (select Sport, count(distinct Games) as freq_games
 from athlete_events
 where season = 'Summer'
 group by Sport
 order by Sport),
 
 Q2 as
 
 (select count(distinct Games) as total_games
 from athlete_events
 where Season = 'Summer')
 
 select * from Q1 
 join Q2 
 on Q1.freq_games = Q2.total_games;
 
-- 7. Which Sports were just played only once in the olympics.--

with q1 as (
select Sport, count(distinct(games)) as freq from athlete_events
group by Sport
order by freq ),

q2 as (select min(freq) as min_value 
from q1)

select * from q1
join q2
on q1.freq = q2.min_value;

-- OR --
select Sport, count(distinct(games)) as freq
from athlete_events
group by Sport
order by freq;

-- Fetch the total no of sports played in each olympic games. --

select  Games, count(distinct sport) as no_of_sports
from athlete_events
group by Games
order by Games;

-- Fetch oldest athletes to win a gold medal. --
with Q1 as (
select Name, Age, Games, Medal
from athlete_events
where medal = 'Gold' 
order by age desc),

Q2 as (
select max(age) as maximum_age
from Q1)

select * from Q1
join Q2
on Q1.Age = Q2.maximum_age;

-- Find the Ratio of male and female athletes participated in all olympic games. --

with male_count as 
(select Games, count(distinct Name) as no_of_males
from athlete_events
where sex = 'M'
group by Games),

female_count as
(select games,count(distinct Name) as no_of_females
from athlete_events
where sex = 'F'
group by Games)

select * from male_count
join female_count
on male_count.games = female_count.games;

-- Fetch the top 5 athletes who have won the most gold medals. --

select name, count(medal) as no_of_gold_medals
from athlete_events
where medal = 'gold' 
group by name
order by no_of_gold_medals desc;

-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won. --

select distinct athlete_events.NOC, noc_regions.region, count(medal) as count_of_medals
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal in ('gold','silver', 'bronze')
group by noc_regions.region
order by count_of_medals desc;

-- List down total gold, silver and bronze medals won by each country. --

with gold as
(select distinct athlete_events.NOC, noc_regions.region as country, count(medal) as gold_medal
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'gold'
group by country),

silver as
(select distinct athlete_events.NOC, noc_regions.region as country, count(medal) as silver_medal
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'silver'
group by country),

bronze as
(select distinct athlete_events.NOC, noc_regions.region as country, count(medal) as bronze_medal
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'bronze'
group by country)

select gold.country, gold_medal, silver_medal, bronze_medal
from gold
join silver 
on gold.country = silver.country
join bronze
on silver.country = bronze.country
order by country;

-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games. --

with gold as
(select athlete_events.Games, noc_regions.region as country, count(athlete_events.Medal) as no_of_gold_medals
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'Gold'
group by noc_regions.region
order by games),

silver as
(select athlete_events.Games, noc_regions.region as country, count(athlete_events.Medal) as no_of_silver_medals
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'silver'
group by noc_regions.region
order by games),

Bronze as
(select athlete_events.Games, noc_regions.region as country, count(athlete_events.Medal) as no_of_bronze_medals
from athlete_events
join noc_regions
on athlete_events.NOC = noc_regions.NOC
where medal = 'bronze'
group by noc_regions.region
order by games)

select gold.games, gold.country, no_of_gold_medals, no_of_silver_medals, no_of_bronze_medals
from gold
join silver 
on gold.country = silver.country
left join bronze
on silver.country = bronze.country
order by games;












