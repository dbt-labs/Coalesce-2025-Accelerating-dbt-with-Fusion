{{
  config(
    materialized='incremental',
    unique_key='store_id',
    merge_update_columns=['store_location', 'opened_at', 'tax_rate', 'valid_to', 'updated_at', 'is_active']
  )
}}

with 

stores as (

    select * from {{ ref('stg_jaffle_shop__stores') }}

),

{% if is_incremental() %}

-- Get current active records from the existing table
current_records as (

    select 
        store_id,
        store_location,
        opened_at,
        tax_rate,
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
        s.store_id,
        case 
            when c.store_id is null then 'INSERT'  -- New store
            when (
                s.store_location != c.store_location or
                s.opened_at != c.opened_at or
                s.tax_rate != c.tax_rate
            ) then 'UPDATE'  -- Changed store
            else 'NO_CHANGE'
        end as change_type
    from stores s
    left join current_records c on s.store_id = c.store_id

),

-- Expire old records for changed stores (set valid_to to yesterday PDT)
expired_records as (

    select
        c.store_id,
        c.store_location,
        c.opened_at,
        c.tax_rate,
        c.valid_from,
        date_sub(convert_timezone('America/Los_Angeles', current_date()), 1) as valid_to,
        c.created_at,
        current_timestamp as updated_at,
        false as is_active
    from current_records c
    inner join changed_records ch on c.store_id = ch.store_id
    where ch.change_type = 'UPDATE'

),

-- Create new records for changed and new stores
new_records as (

    select
        s.store_id,
        s.store_location,
        s.opened_at,
        s.tax_rate,
        current_date as valid_from,
        date('2099-12-31') as valid_to,
        coalesce(c.created_at, current_timestamp) as created_at,
        current_timestamp as updated_at,
        true as is_active
    from stores s
    inner join changed_records ch on s.store_id = ch.store_id
    left join current_records c on s.store_id = c.store_id
    where ch.change_type in ('INSERT', 'UPDATE')

),

-- Keep unchanged records as they are
unchanged_records as (

    select
        c.store_id,
        c.store_location,
        c.opened_at,
        c.tax_rate,
        c.valid_from,
        c.valid_to,
        c.created_at,
        c.updated_at,
        c.is_active
    from current_records c
    inner join changed_records ch on c.store_id = ch.store_id
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
        store_id,
        store_location,
        opened_at,
        tax_rate,
        current_date as valid_from,
        date('2099-12-31') as valid_to,
        current_timestamp as created_at,
        current_timestamp as updated_at,
        true as is_active
    from stores

)

{% endif %}

select * from final