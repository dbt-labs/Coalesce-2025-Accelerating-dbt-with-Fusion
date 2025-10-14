with

    locations as  (
        
        select * from {{ ref("stg_jaffle_shop__stores") }}
        
    ),

    orders as (
    
        select * from {{ ref("stg_jaffle_shop__orders") }}
    
    ),

    store_orders_summary as (

        select

            orders.store_id,
            min(orders.ordered_at) as first_ordered_at,
            max(orders.ordered_at) as last_ordered_at,
            count(distinct orders.order_id) / count(1) as return_rate,
            count(orders.store_id) as total_orders,
            count(distinct orders.customer_id) as count_unique_customer_visits,
            avg(orders.order_total) as avg_order_amount,
            sum(orders.subtotal) as total_revenue_pretax,
            sum(orders.tax_paid) as total_tax_paid,
            sum(orders.order_total) as total_location_spend

        from orders

        group by 1

    ),

    final as (

        select

            -- primary key
            locations.store_id,

            -- details
            locations.store_location,

            -- numerics
            total_orders,
            count_unique_customer_visits,
            avg_order_amount,
            total_revenue_pretax,
            total_tax_paid,
            total_location_spend,
            return_rate,

            -- dates/timestamps
            first_ordered_at,
            last_ordered_at

        from locations

        left join
            store_orders_summary on locations.store_id = store_orders_summary.store_id

    )

select *
from final
