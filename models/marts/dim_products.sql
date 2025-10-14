{{
  config(
    materialized='incremental',
    unique_key='product_id',
    merge_update_columns=['valid_to', 'updated_at', 'is_active']
  )
}}

with 

products as (

    select * from {{ ref('stg_jaffle_shop__products') }}

),

{% if is_incremental() %}

-- Get current active records from the existing table
current_records as (

    select 
        product_id,
        product_name,
        product_type,
        product_description,
        product_price,
        valid_from,
        valid_to,
        created_at,
        updated_at,
        is_active
    from {{ this }}
    where is_active = true

),

-- Detect changes by comparing staging data with current records
changed_records as (

    select 
        p.product_id,
        case 
            when c.product_id is null then 'INSERT'  -- New product
            when (
                p.product_name != c.product_name or
                p.product_type != c.product_type or
                p.product_description != c.product_description or
                p.product_price != c.product_price
            ) then 'UPDATE'  -- Changed product
            else 'NO_CHANGE'
        end as change_type
    from products p
    left join current_records c on p.product_id = c.product_id

),

-- Expire old records for changed products (set valid_to to yesterday PDT)
expired_records as (

    select
        c.product_id,
        c.product_name,
        c.product_type,
        c.product_description,
        c.product_price,
        c.valid_from,
        date_sub(convert_timezone('America/Los_Angeles', current_date()), 1) as valid_to,
        c.created_at,
        current_timestamp as updated_at,
        false as is_active
    from current_records c
    inner join changed_records ch on c.product_id = ch.product_id
    where ch.change_type = 'UPDATE'

),

-- Create new records for changed and new products
new_records as (

    select
        p.product_id,
        p.product_name,
        p.product_type,
        p.product_description,
        p.product_price,
        current_date as valid_from,
        date('2099-12-31') as valid_to,
        coalesce(c.created_at, current_timestamp) as created_at,
        current_timestamp as updated_at,
        true as is_active
    from products p
    inner join changed_records ch on p.product_id = ch.product_id
    left join current_records c on p.product_id = c.product_id
    where ch.change_type in ('INSERT', 'UPDATE')

),

-- Keep unchanged records as they are
unchanged_records as (

    select
        c.product_id,
        c.product_name,
        c.product_type,
        c.product_description,
        c.product_price,
        c.valid_from,
        c.valid_to,
        c.created_at,
        c.updated_at,
        c.is_active
    from current_records c
    inner join changed_records ch on c.product_id = ch.product_id
    where ch.change_type = 'NO_CHANGE'

),

final as (

    select * from expired_records
    union all
    select * from new_records
    union all
    select * from unchanged_records

)

{% else %}

-- Initial load logic
final as (

    select
        product_id,
        product_name,
        product_type,
        product_description,
        product_price,
        current_date as valid_from,
        date('2099-12-31') as valid_to,
        current_timestamp as created_at,
        current_timestamp as updated_at,
        true as is_active
    from products

)

{% endif %}

select * from final