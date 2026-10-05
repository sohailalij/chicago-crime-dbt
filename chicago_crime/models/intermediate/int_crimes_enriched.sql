select
    *,
    date_trunc(crime_date, month) as crime_month,
    extract(hour from crime_timestamp) as crime_hour,
    (
        extract(hour from crime_timestamp) >= 20
        or extract(hour from crime_timestamp) < 6
    ) as is_night
from {{ ref('stg_crimes') }}