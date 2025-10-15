with

products as (
    select * from {{ ref('stg_jaffle_shop__products') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

order_items as (
    select * from {{ ref('stg_jaffle_shop__order_items') }}
),

product_orders_summary as (
    select order_items.product_id
    , min(orders.ordered_at) as first_order
    , max(orders.ordered_at) as most_recent_order
    , count(order_items.*) as order_count
    from order_items
    left join orders using (order_id)
    group by product_id
),

final as (
    select 

    --primary key
    products.product_id

    -- details
    , products.product_name
    , products.product_type
    , products.product_price

    -- metrics
    , first_order
    , most_recent_order
    , order_count
    , order_count * product_price as product_revenue

    from products
    left join product_orders_summary using (product_id)
)

select * from final