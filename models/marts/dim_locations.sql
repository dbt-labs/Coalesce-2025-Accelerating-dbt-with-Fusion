with 

locations as (
    select * from {{ ref('stg_jaffle_shop__stores')}}
)

select * from locations
