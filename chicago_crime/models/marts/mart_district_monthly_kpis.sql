with monthly as (
    select
        district,
        crime_month,
        count(*) as incidents,
        countif(is_arrest) as arrests,
        countif(is_domestic) as domestic_incidents,
        countif(is_night) as night_incidents
    from {{ ref('fct_crimes') }}
    where district is not null
    group by district, crime_month
)

select
    m.district,
    m.crime_month,
    m.incidents,
    m.arrests,
    m.domestic_incidents,
    m.night_incidents,
    round(100 * safe_divide(m.arrests, m.incidents), 2) as arrest_rate_pct,
    round(100 * safe_divide(m.domestic_incidents, m.incidents), 2) as domestic_share_pct,
    round(100 * safe_divide(m.night_incidents, m.incidents), 2) as night_share_pct,
    round(100 * safe_divide(m.incidents - p.incidents, p.incidents), 2) as yoy_change_pct
from monthly m
left join monthly p
    on m.district = p.district
    and p.crime_month = date_sub(m.crime_month, interval 12 month)