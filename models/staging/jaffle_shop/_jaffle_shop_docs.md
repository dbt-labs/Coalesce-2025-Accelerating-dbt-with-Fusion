## Model Level Descriptions

{% docs stg_jaffle_shop__customers %}
The customers table stores the customer's information such as customer_id and customer_name.
{% enddocs %}

{% docs stg_jaffle_shop__order_items %}
The order items table stores the information about the order item and how it relates to products and orders.
{% enddocs %}

{% docs stg_jaffle_shop__orders %}
The orders table stores information about the order placed and how it relates to stores and customers.
{% enddocs %}

{% docs stg_jaffle_shop__products %}
The products table stores information about the product details.
{% enddocs %}

{% docs stg_jaffle_shop__stores %}
The stores table stores information about the store details.
{% enddocs %}

{% docs stg_jaffle_shop__supplies %}
The supplies table stores information about the supply details.
{% enddocs %}

## Column Level Descriptions

### Shared Descriptions

{% docs stg_jaffle_shop__customer_id %}
Identifier of the customer.
{% enddocs %}

{% docs stg_jaffle_shop__product_id %}
Identifier of the product.
{% enddocs %}

{% docs stg_jaffle_shop__order_id %}
Identifier of the order.
{% enddocs %}

{% docs stg_jaffle_shop__store_id %}
Identifier of the store.
{% enddocs %}

### Customers Descriptions

{% docs stg_jaffle_shop__customers__customer_name %}
The full name of the customer.
{% enddocs %}

### Order Items Descriptions

{% docs stg_jaffle_shop__order_items__order_item_id %}
Identifier of the item.
{% enddocs %}

### Orders Descriptions

{% docs stg_jaffle_shop__orders__subtotal %}
The subtotal of the amount in dollars.
{% enddocs %}

{% docs stg_jaffle_shop__tax_paid %}
The tax paid amount in dollars.
{% enddocs %}

{% docs stg_jaffle_shop__order_total %}
The total amount of the order in dollars.
{% enddocs %}