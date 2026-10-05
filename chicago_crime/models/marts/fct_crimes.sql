{{
    config(
        materialized='table',
        partition_by={
            "field": "crime_year",
            "data_type": "int64",
            "range": {"start": 2001, "end": 2031, "interval": 1}
        },
        cluster_by=["district", "primary_type"]
    )
}}

select * from {{ ref('int_crimes_enriched') }}