with 

locations as 
(

select * from {{ref('stg_jaffle_shop__stores')}}

)
select STORE_LOCATION from locations