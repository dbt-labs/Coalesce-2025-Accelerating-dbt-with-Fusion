with

stores as (
    select * from {{ ref('stg_jaffle_shop__stores') }}
)

,orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)

,location_orders_summary as (
    select
        o.store_id
        ,count(distinct o.order_id) as count_orders
        ,count(distinct o.customer_id) as count_customers
        ,min(o.ordered_at) as first_order_at
        ,max(o.ordered_at) as last_order_at
        ,sum(o.subtotal) as total_spend_pretax
        ,sum(o.tax_paid) as total_tax_paid
        ,sum(o.order_total) as total_spend
        ,avg(o.order_total) as avg_order_total
    from orders o
    group by store_id
) 

,final as (
    select
        -- primary key
        s.store_id

        -- details
        ,s.store_location

        -- numeric
        ,l.count_orders
        ,l.count_customers
        ,l.total_spend_pretax
        ,l.total_tax_paid
        ,l.total_spend
        ,l.avg_order_total

        -- dates/timestamps
        ,l.first_order_at
        ,l.last_order_at
    from stores s
    left join location_orders_summary l
        on l.store_id = s.store_id
)

select * from final