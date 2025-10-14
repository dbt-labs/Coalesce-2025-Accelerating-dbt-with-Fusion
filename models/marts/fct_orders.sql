with 

stg_orders as (
    select * from {{ ref('stg_jaffle_shop__orders')}}
)

select * from stg_orders