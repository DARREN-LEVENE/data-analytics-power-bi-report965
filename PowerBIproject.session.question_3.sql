SELECT ROUND(SUM(orders.product_quantity*dim_product.sale_price)::numeric, 1) AS total_revenue,
        dim_store.store_type

FROM orders

INNER JOIN dim_product ON dim_product.product_code = orders.product_code

INNER JOIN dim_store ON dim_store.store_code = orders.store_code

WHERE 
    dim_store.country_code = 'DE'

GROUP BY
    dim_store.store_type

ORDER BY
    total_revenue DESC;
    