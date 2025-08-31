with 

customers as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

final as (

    select 
        -- primary key
        id as customer_id,

        -- details
        name as customer_name

    from customers

)

select * from final
