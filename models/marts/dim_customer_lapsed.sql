with

dim_customers as (

   select * from {{ ref('dim_customers') }}

),

lapsed as (

   select
       customer_id,
       first_ordered_at,
       last_ordered_at,
       number_of_orders,
       total_spend,
       is_return_customer,
       datediff('day', last_ordered_at, current_date) as days_since_last_order

   from dim_customers

   where
       last_ordered_at is not null
       and datediff('day', last_ordered_at, current_date) > 90

)

select * from lapsed
order by days_since_last_order desc