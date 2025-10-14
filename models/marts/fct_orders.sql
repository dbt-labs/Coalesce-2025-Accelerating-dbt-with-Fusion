with

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)

select * from orders