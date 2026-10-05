select
    unique_key as crime_id,
    case_number,
    `date` as crime_timestamp,
    date(`date`) as crime_date,
    year as crime_year,
    primary_type,
    description as crime_description,
    location_description,
    arrest as is_arrest,
    domestic as is_domestic,
    district,
    ward,
    community_area,
    latitude,
    longitude
from {{ source('chicago_crime', 'crime') }}