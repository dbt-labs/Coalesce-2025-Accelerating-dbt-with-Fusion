with PRODUCTS as (

    select 
        PRODUCT_ID
        ,PRODUCT_NAME AS PRODUCT_DESC
        ,PRODUCT_PRICE
        ,PRODUCT_TYPE

     from {{ ref('stg_jaffle_shop__products') }}

)
SELECT * FROM PRODUCTS;
