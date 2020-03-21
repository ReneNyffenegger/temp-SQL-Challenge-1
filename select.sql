.header on
.mode   columns
.width  2 20 2 2 2 2 2 2 2 3

with games_per_team as (
   select
      hometeam   as team,
      homegoals  as goals_for,
      awaygoals  as goals_against,
      round_game as round_game
   from
      games
 union all
   select
      awayteam   as team,
      awaygoals  as goals_for,
      homegoals  as goals_against,
      round_game as round_game
   from
      games
),
calculation as (
   select
      team,
      count(*)                                              as games,
      sum  (case when goals_for < goals_against then 0
                 when goals_for = goals_against then 1
                 when goals_for > goals_against then 3 end) as points,
      count(case when goals_for > goals_against then 1 end) as won,
      count(case when goals_for = goals_against then 1 end) as drawn,
      count(case when goals_for < goals_against then 1 end) as lost,
      sum  (          goals_for                           ) as goals_for,
      sum  (                      goals_against           ) as goals_against
   from
      games_per_team
   where
      round_game <= 400
   group by
      team
)
select
   row_number() over (order by
         points     desc,
         goals_for  desc,
         team       asc
   ) rank,
   team,
   games,
   points,
   won,
   drawn,
   lost,
   goals_for,
   goals_against,
   goals_for - goals_against as goal_difference
from
  calculation
