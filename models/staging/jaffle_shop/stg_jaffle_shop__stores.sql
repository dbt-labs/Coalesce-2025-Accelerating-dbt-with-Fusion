with 

stores as (

    select * from {{ source('jaffle_shop', 'stores') }}

),

final as (

    select
        -- primary key
        id as store_id,

        -- details
        name as store_location,
        opened_at,

        -- numeric
        tax_rate

    from stores

)

select * from final
