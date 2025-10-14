with 

stores as (
    select * from {{ stg_jaffle_shop__stores }} 
), 

customers as (
    select * from {{ stg_jaffle_shop_customers }}
)

select
    *
from stores