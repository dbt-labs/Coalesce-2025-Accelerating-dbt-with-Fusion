with stg_stores as (

    select * from {{ ref('stg_jaffle_shop__stores') }}

)


, stg_customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

)


, stg_orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

)


, most_frequent_customer as (

    select 

        o.store_id,
        o.customer_id,
        c.customer_name,
        count(o.order_id) as order_count,
        row_number() over (partition by o.store_id order by order_count desc) as row_num

    from stg_orders o 
    join stg_customers c 
        on o.customer_id = c.customer_id
    group by all
    -- qualify row_num = 1
    order by 1, 4 desc

)


, final as (

    select

        s.store_id,
        s.store_location,
        s.opened_at,
        s.tax_rate,
        count(distinct c.customer_id) as unique_customers,
        sum(o.subtotal) as total_pretax_sales,
        sum(o.order_total) as total_sales,
        mfc.customer_name as most_frequent_customer

    from stg_stores s 
    left join stg_orders o 
        on s.store_id = o.store_id
    left join stg_customers c 
        on o.customer_id = c.customer_id
    left join most_frequent_customer mfc 
        on s.store_id = mfc.store_id

    group by all

)


select * from final