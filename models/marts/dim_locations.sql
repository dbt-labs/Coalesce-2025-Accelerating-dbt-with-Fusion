with 

stores as (

    select * from {{ source('jaffle_shop', 'stores') }}

),
