select week, max(rooms_used) as number_of_rooms
from (
  select CONCAT(date_part('year', date_rage_new), '-',date_part('week', date_rage_new)) as week, count(*) as rooms_used
  from (
    select *, 
      generate_series(check_in_date,
                      check_out_date - 1,
                      interval '1 day')::date as date_rage_new
    from reservations
  ) first_agg
  group by date_rage_new
) once_agg
group by week
