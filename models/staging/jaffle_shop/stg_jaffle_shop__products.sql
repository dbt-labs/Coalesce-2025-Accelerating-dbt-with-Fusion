with 

products as (

    select * from {{ source('jaffle_shop', 'products') }}

),

final as (

    select        
        -- primary key
        sku as product_id,

        -- details
        name as product_name,
        type as product_type,
        description as product_description,

        -- numerics
        {{ cents_to_dollars('price')}} as product_price

    from products

)

select * from final
