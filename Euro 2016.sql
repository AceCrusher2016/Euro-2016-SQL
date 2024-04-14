--1. how many unique soccer venues were used in euro 2016
select count(*)  as total_venues
from soccer_venue
-- 10 stadiums were used in Euro 2016

--2. how many unique countries were in euro 2016
select count(distinct country_id) as no_of_teams 
from soccer_country
-- 29 unique countries in euro 2016

--3. how many goals scored within standard 90 minutes of game play
select count(goal_id) as standard_goals 
from goal_details
where goal_schedule = 'NT' and goal_type = 'N'

--there are 87 goals scored (Not Penalties or Own Goals) within normal time (between 0-90 game minutes)

--4. how many games ended in a W
select count(match_no) no_of_decisive_winners 
from match_mast
where results = 'WIN'
--there were 40 of 51 games that had a winner

--5 how many games ended in a draw
select count(*) as no_of_draws
from match_mast
where results = 'DRAW'
-- there was 11 games that ended in a draw out of 51 games played in Euro 2016

--6 when did the euro 2016 start
select min(play_date) as start_of_euros
from match_mast
--the first game of euro 2016 was played on June 11th, 2016

--7 how many own goals were scored in euro 2016
select count(*) as no_of_own_goals
from goal_details
where goal_type = 'O'
-- there were three own goals scored in the tournament

--7a what teams socred the own goals?
select team_id, country_name from Soccer_team st
join soccer_country sc
on st.ID = sc.ID
where team_id in (1215, 1210, 1212)
-- Iceland, Northern Ireland and the Republic of Ireland were the three countries who scored an own goal in Euro 2016

--8 how many group stage matches had a winner?
select count(*) as group_stage_games_with_winner 
from match_mast
where results = 'WIN' and play_stage = 'G'
--25 games in the group stage had a winner

--9 how many matches ended in a penalty shootout?
select count(*) as games_ending_in_Pens
from match_mast
where decided_by = 'P'
-- 3 games were decided by penalty shoot out (match_no = 37,45,47)

--9a what teams won in the penalty shootout?
select * from match_details
where match_no in (37,45,47) and win_lose = 'W'
-- this gives you three team_id (1213,1214,1208)
select team_id,country_name from soccer_team st
join soccer_country sc
on st.ID = sc.ID
where team_id in (1213,1214,1208)
-- Germany, Poland and Portugal won a game in a Penalty Shootout during Euro 2016

--10 how many round of 16 games ended in shootout
select count(match_no) as games_ended_in_shootout from match_mast
where decided_by = 'P' 
and play_stage = 'R'

--11 regular goals scored in 90 minutes of play
select match_no, count(goal_id) as number_of_goals
from goal_details
where goal_type = 'n'
and goal_schedule = 'nt'
group by match_no
order by match_no
--gives you a breakdown of number of goals per match in normal time

--12 which games had no stoppage time in the first half, and how many goals were scored in those games
select m.match_no, m.play_date, count(g.goal_id) as Number_of_Goals from match_mast m
join goal_details g on
m.match_no = g.match_no
where stop1_sec = 0 and goal_schedule = 'NT'
group by m.match_no, m.play_date
order by m.match_no
-- one match had no stoppage time in the first half and had a goal scored

--13 how many games during group stage ended in a scoreless draw
select count(distinct match_no) as group_stage_scoreless_draws from match_details
where win_lose = 'D'
and play_stage = 'G'
and goal_score = 0
-- there are 4 games during group play that ended in a scoreless draw
 
--14 how many games were won by one goal, not pens in all euro 2016
select count(distinct m.match_no) as one_goal_winners
from match_mast m
join goal_details g
on m.match_no = g.match_no
where m.results = 'WIN'
and m.decided_by <> 'P'
group by m.match_no
having count(g.goal_id) = 1
--total of 13 games had a single goal scored

--15 how many player substitutions occured during euro 2016
select count(in_out) as total_substitutions
from player_in_out
where in_out = 'I'
--There was a total of 293 substitutions in to a game and 293 total players being subbed out. Grand total is 586, which you would get if you remove the where clause

--16 how many player substitutions occured within the standard 90 minute play at euro 2016
select count(*) as substitutions_in_NT from player_in_out
where play_schedule = 'NT'
and in_out = 'I'
--275 substitutions during normal time for the entire euro 2016

--17 how many substitutions occured in stoppage time
select count(*) as stop_time_subs
from player_in_out
where play_schedule = 'ST'
and in_out = 'I'
-- 9 subs occured during stoppage time

--18 how many first half player subs happened during euro 2016
select count(*) as first_half_subs 
from player_in_out
where play_half = 1
and in_out = 'I'
and play_schedule <> 'ET'
-- 2 first half subs during euro 2016

--19 how many games ended in goalless draws
select count(distinct match_no) as goalless_draws from match_details
where win_lose = 'D' 
and goal_score = 0
-- there were 4 goalless draws during euro 2016

--20 how many player substitutions occured in extra time
select count(*) as total_ET_subs from player_in_out
where play_schedule = 'ET'
and in_out = 'I'
-- there were 9 total substitutions happening in etra time during Euro 2016

--21 provide a breakdown of player subs per round
select m.play_stage, count(*) as total_sub_per_round
from player_in_out p
join match_details m
on p.match_no = m.match_no
where p.in_out = 'I'
group by m.play_stage
order by total_sub_per_round desc

--22 how many shots were taken during penalty shootouts were taken during euro 2016
select count(*) as total_penalty_shots
from penalty_shootout

--23 how many shots during penalty shootouts resulted in a goal
select count(*) as successful_penalty_shots
from penalty_shootout
where score_goal = 'Y'

--24 how many shots were missed or saved during penalty shootouts
select count(*) as missed_penalty_shots
from penalty_shootout
where score_goal = 'N'

--25 which players took penalty shots during euro 2016, include their country
select p.player_name as player,
c.country_name as country,
count(s.player_id) as shots_taken
 from penalty_shootout s
join player_mast p on
s.player_id = p.player_id
join soccer_country c on
p.team_id = c.country_id
group by p.player_name, c.country_name
order by shots_taken desc, player

--26 how many penalty shots were taken by team
select c.country_name as country,
count(s.kick_id) as shots_taken
from soccer_country c
join penalty_shootout s
on c.country_id = s.team_id
group by c.country_name
order by shots_taken desc

--27 how many bookings occured during each half of play in euro 2016
select
	case 
		when play_half = 1 then 'first_half'
		else 'second_half'
end as half_of_play,
count(*) as number_of_bookings
from player_booked
group by play_half

--28 how many bookings occured during stoppage time
select count(*) as stoppage_time_bookings
from player_booked
where play_schedule = 'ST'

--29 how many bookings occured during extra time
select count(*) as extra_time_bookings
from player_booked
where play_schedule = 'ET'

--30 retrieve the top 5 teams per goals scored
select top(5) c.country_name, count(g.team_id) as goals_per_team
from goal_details g
join soccer_country c on
g.team_id = c.country_id
group by c.country_name
order by goals_per_team desc
-- france scored the most goals with 13

--31 list the players with more than one booking at euro 2016
select p.player_name, count(*) as bookings from player_booked b
join player_mast p on
b.player_id = p.player_id
group by p.player_name
having count(*) > 1
order by bookings desc

--32 who are the coaches of the top 5 scoring teams from Euro 2016
select top(6) c.country_name, m.coach_name, count(g.team_id) as goals_per_team
from goal_details g
join soccer_country c on
g.team_id = c.country_id
join team_coaches t on
c.country_id = t.team_id
join coach_mast m on
t.coach_id = m.coach_id
group by c.country_name, m.coach_name
order by goals_per_team desc, country_name
--we did top 6 as iceland had a duo of coaches, so the top 5 teams are France, wales, Portugal, iceland and Belgium, with 6 coaches for the 5 teams

--33 list the venues by the number of matches it held in euro 2016
select v.venue_name, count(*) as total_hosted_games from soccer_venue v
join match_mast m on
v.venue_id = m.venue_id
group by v.venue_name
order by total_hosted_games desc

--34 average number of substitutions in the second half per team
select avg(sub_count) as avg_subs
from (
select match_no, team_id, count(player_id) as sub_count
from player_in_out
where in_out = 'I'
and play_half = 2
group by match_no, team_id
) as subs
--34a how many subs did each team perform in the second half during euro 2016
select c.country_name, count(*) as number_of_2nd_half_subs from player_in_out p 
join soccer_country c on
p.team_id = c.country_id
where in_out = 'I'
and play_half = 2
group by c.country_name
order by number_of_2nd_half_subs desc;

--35 who are the top 3 teams who are the most succesful penalty takers
with pks as
(
select soccer_country.country_name,
case 
	when score_goal = 'y' then 'success'
	else 'missed'
end as penalty_attempt,
count(*) as number_of_attempts
from penalty_shootout
join soccer_country on
penalty_shootout.team_id = soccer_country.country_id
group by soccer_country.country_name, penalty_shootout.score_goal
),
total as
( 
select country_name,  sum(number_of_attempts) as total from pks
group by country_name
)
select top(3) t.country_name, p.number_of_attempts as penalty_success, t.total as total_kicks, round(cast(p.number_of_attempts as float(5))/cast(t.total as float(5)), 3)* 100 as conversion_pct from total t
join pks p
on t.country_name = p.country_name
where p.penalty_attempt = 'success'
order by conversion_pct desc

--36 referees who officiated the most matches in euro 2016
select r.referee_name, count(m.match_no) as matches_officiated from match_mast m
join referee_mast r on
m.referee_id = r.referee_id
group by r.referee_name
order by 2 desc

--37 top 5 in goal scoring for euro 2016
select top(5) p.player_name, count(g.goal_id) from goal_details g
join player_mast p on
g.player_id = p.player_id
group by p.player_name
order by 2 desc

--38 top 3 teams with most bookings
select top(3)c.country_name, count(b.team_id) no_of_bookings from player_booked b 
join soccer_country c on
b.team_id = c.country_id
group by c.country_name
order by no_of_bookings desc

--39 who were the most substituted players in euro 2016
select p.player_name, count(player_name) as no_of_subs from player_in_out i
join player_mast p on
i.player_id = p.player_id
group by p.player_name
order by no_of_subs desc

--40 highest average age of teams in euro 2016
select c.country_name, round(avg(p.age), 2) as avg_age from player_mast p
join soccer_country c on
p.team_id = c.country_id
group by c.country_name
order by avg_age desc

--41 find the highest attendance for the venues at euro 2016
select v.venue_name, sum(m.audence) as total_attendance from soccer_venue v
join match_mast m on
v.venue_id = m.venue_id
group by v.venue_name
order by total_attendance desc

--42 highest number of bookings per match
select match_no, count(id) as bookings_per_game from player_booked b
group by match_no
order by bookings_per_game desc

--43 players who played the most minutes at euro
select m.player_name, 
sum(case
	when io.in_out = 'I' then 45
	when io.in_out = 'O' then 45
	else 90
	end 
	) as "total_time_played"
	from player_in_out io
join player_mast m on
io.player_id = m.player_id
group by m.player_name
order by total_time_played desc


--44 find the top goal scorer for regular time, extra time and penalty shootouts
select * from goal_details
order by goal_time desc, play_stage desc;
with top_scorer as
(
select player_id,
case
	when goal_time <= 90 then 'Regular Time'
	when goal_time between 90 and 120 then 'Extra Time'
	else 'Penalties'
end as match_phase,
count(goal_id) as goals_scored
from goal_details
group by player_id, goal_time
)

select p.player_name, t.match_phase, count(t.player_id) as goals 
from top_scorer t
join player_mast p on
t.player_id = p.player_id
group by t.match_phase, p.player_name
order by t.match_phase, goals desc, p.player_name 

--45 find the players who have scored goals and had a booking
select p.player_name, count(b.ID) as bookings, count(g.goal_id) as goals from player_booked b
left join goal_details g on
b.player_id = g.player_id
join player_mast p on
g.player_id = p.player_id
group by p.player_name
order by goals desc, bookings desc

--46, what teams had the most bookings in euro 2016
select c.country_name as country, count(c.country_id) as bookings_per_team from player_booked b
join soccer_country c on 
b.team_id = c.country_id
group by c.country_name
order by bookings_per_team desc;

--47 what venue had the highest average goals scored
with venues as
(
select v.venue_name as venue, sum(d.goal_score) as total_goals, count(v.venue_id) as matches_hosted from match_mast m
join match_details d on
m.match_no = d.match_no
join soccer_venue v on
m.venue_id = v.venue_id
group by v.venue_name
)
select venue,  round((total_goals / matches_hosted),2) as avg_goals_per_venue from venues
order by avg_goals_per_venue desc