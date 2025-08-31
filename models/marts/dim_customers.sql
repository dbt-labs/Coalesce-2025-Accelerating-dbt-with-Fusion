with 

customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

customer_orders_summary as (

    select 

        orders.customer_id,
        min(orders.ordered_at) as first_ordered_at,
        max(orders.ordered_at) as last_ordered_at,
        count(distinct orders.order_id) > 1 as is_return_customer,
        count(orders.store_id) as total_location_visits,
        count(distinct orders.store_id) as count_unique_location_visits,
        sum(orders.subtotal) as total_spend_pretax,
        sum(orders.tax_paid) as total_tax_paid,
        sum(orders.order_total) as total_spend


    from orders

    group by orders.customer_id

),

final as (

    select
    
        -- primary key
        customers.customer_id,

        -- details
        customers.customer_name,

        -- numerics
        total_location_visits,
        count_unique_location_visits,
        total_spend_pretax,
        total_tax_paid,
        total_spend,

        -- boolean
        is_return_customer,

        -- dates/timestamps
        first_ordered_at,
        last_ordered_at

    from customers

    left join customer_orders_summary
        on customers.customer_id = customer_orders_summary.customer_id

)

select * from final
