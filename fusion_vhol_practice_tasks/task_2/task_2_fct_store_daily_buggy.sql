with orders as (

    select
        order_id,
        store_id,
        orderedat,
        date_trunc('day', ordered_at) as order_date,
        sub_total,
        tax_paid,
        order_total
    from {{ ref('stg_jaffle_shop__order') }}

),

stores as (

    select
        store_id,
        store_locaton,
        taxrate,
        opened_at,
        is_open
    from {{ ref('stg_jaffle_shop__stores') }}

),

daily_rollup as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        orders.order_date,

        count(orders.order_id) as orders_count,
        sum(coalesce(orders.subtotal)) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,

        daily_order_total / orders_count as avg_order_total,

        datediff('day', orders.ordered_at, stores.opened_at) as days_since_store_open

    from orders
    left join stores
        on orders.store_id = stores.store_id

    group by
        orders.store_id,
        orders.order_date

)

select *
from daily_rollup
order by order_date desc, store_id
