with yearly as (
    select
        crime_year,
        primary_type,
        count(*) as incidents,
        countif(is_arrest) as arrests,
        countif(is_night) as night_incidents
    from {{ ref('fct_crimes') }}
    where crime_year < (select max(crime_year) from {{ ref('fct_crimes') }})
    group by crime_year, primary_type
)

select
    y.crime_year,
    y.primary_type,
    y.incidents,
    round(100 * safe_divide(y.arrests, y.incidents), 2) as arrest_rate_pct,
    round(100 * safe_divide(y.night_incidents, y.incidents), 2) as night_share_pct,
    round(100 * safe_divide(y.incidents, sum(y.incidents) over (partition by y.crime_year)), 2) as share_of_year_pct,
    round(100 * safe_divide(y.incidents - p.incidents, p.incidents), 2) as yoy_change_pct
from yearly y
left join yearly p
    on y.primary_type = p.primary_type
    and p.crime_year = y.crime_year - 1