with locations as (

    select 
        distinct store_location as LOCATION_DESC

     from {{ ref('stg_jaffle_shop__stores') }}

)
select  row_number() over (PARTITION BY 1 ORDER BY 1) as LOCATION_ID
         ,LOCATION_DESC
 from locations
