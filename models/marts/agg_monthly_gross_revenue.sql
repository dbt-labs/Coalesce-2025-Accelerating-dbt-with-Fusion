with orders as
(
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

agg_monthly_gross_revenue as
(
    select 
        date_trunc('month', ordered_at) as order_month,
        sum(order_total) as month_total_price
    from orders

    group by 1
)


select * from agg_monthly_gross_revenue