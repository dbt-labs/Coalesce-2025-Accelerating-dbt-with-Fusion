with src as (
    select *
    from {{ref('stg_jaffle_shop__stores')}}
)

, customers as (
    select *
    from {{ref('dim_customers')}}
    )

, orders as (
    select *
    from {{ref('stg_jaffle_shop__orders')}}
    )

, customer_orders as (
    select c.customer_name
        , o.*
        
    from customers c 
    join orders o on o.customer_id = c.customer_id
)

, most_pop_customer as (
    select store_id
        , customer_id
        , customer_name
        , count(order_id) as order_cnt
        , dense_rank() over (partition by store_id order by order_cnt desc) as order_rank
    from customer_orders
    group by store_id, customer_id, customer_name
    qualify order_rank = 1
)

select 
    src.store_id
    , opened_at as open_dt
    , store_location as location
    , tax_rate
    , customer_id as most_popular_customer_id
    , customer_name as most_popular_customer
from src
join most_pop_customer m on m.store_id = src.store_id and order_rank = 1
