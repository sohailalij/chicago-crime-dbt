with by_district as (
    select
        district,
        sum(incidents) as incidents,
        sum(arrests) as arrests,
        sum(night_incidents) as night_incidents
    from {{ ref('mart_district_monthly_kpis') }}
    group by district
)

select
    district,
    incidents,
    round(100 * safe_divide(arrests, incidents), 2) as arrest_rate_pct,
    round(100 * safe_divide(sum(arrests) over (), sum(incidents) over ()), 2) as citywide_arrest_rate_pct,
    round(
        100 * safe_divide(arrests, incidents)
        - 100 * safe_divide(sum(arrests) over (), sum(incidents) over ()),
        2
    ) as arrest_rate_gap_pts,
    round(100 * safe_divide(night_incidents, incidents), 2) as night_share_pct
from by_district