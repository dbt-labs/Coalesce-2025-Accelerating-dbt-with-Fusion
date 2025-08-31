with 

supplies as (

    select * from {{ source('jaffle_shop', 'supplies') }}

),

final as (

    select
        -- surrogate key
        {{dbt_utils.generate_surrogate_key(['id', 'sku'])}} as supply_uuid,

        -- foreign key
        id as supply_id,
        sku as product_id,

        -- details
        name as supply_name,
        cost as supply_cost,

        -- boolean
        perishable as is_perishable_supply

    from supplies

)

select * from final
