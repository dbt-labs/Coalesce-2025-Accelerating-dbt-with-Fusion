with 

order_items as (

    select * from {{ source('jaffle_shop', 'order_items') }}

),
 
final as (

    select
        -- primary key
        id as order_item_id,

        -- foreign key
        order_id,

        -- details
        sku as product_id

    from order_items

)

select * from final
