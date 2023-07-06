SELECT player_id, country,
       SUM(new_time_session) AS duration_of_all_sessions,
       MIN(new_time_session) AS shortest_session,
       MAX(new_time_session) AS longest_session,
       ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(new_time_session) DESC) AS rank_of_the_user
from (
select player_id, 
country,   
SUM(DATEDIFF(minute, start_time, end_time)) AS new_time_session
 from (
SELECT player_id, country, start_time, end_time, LAG(end_time, 1,'1999-09-01') OVER( PARTITION BY player_id
       ORDER BY start_time ASC) AS end_time_back
       from game_sessions 
) as agg_yes_five_minuts
where DATEDIFF(minute, end_time_back, start_time) <=5 or DATEDIFF(minute, end_time_back, start_time) >=11000000
GROUP BY player_id, country
UNION
select player_id, 
country,   
DATEDIFF(minute, start_time, end_time) AS new_time_session
 from (
SELECT player_id, country, start_time, end_time, LAG(end_time, 1,'1999-09-01') OVER( PARTITION BY player_id
       ORDER BY start_time ASC) AS end_time_back
       from game_sessions 
) as agg_no_five_minuts
where DATEDIFF(minute, end_time_back, start_time) > 5 and DATEDIFF(minute, end_time_back, start_time) < 11000000
) as result
GROUP BY player_id, country