with 

orders as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

final as (

    select
        -- primary key
        id as order_id,

        -- foreign key
        customer as customer_id,
        store_id,
    
        -- numerics 
        subtotal as subtotal_cents,
        tax_paid as tax_paid_cents,
        order_total as order_total_cents,

        {{ cents_to_dollars('subtotal')}} as subtotal,
        {{ cents_to_dollars('tax_paid')}} as tax_paid,
        {{ cents_to_dollars('order_total')}} as order_total,

        -- dates/timestamps 
        ordered_at

    from orders

)

select * from final
