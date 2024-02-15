SELECT 
    ROUND(SUM(orders.product_quantity*dim_product.sale_price)::numeric, 1) AS total_revenue,
    EXTRACT(MONTH FROM order_date::date) AS MONTH

FROM 
    orders

INNER JOIN
    dim_product ON dim_product.product_code = orders.product_code

WHERE
    EXTRACT(YEAR FROM orders.order_date::date) = 2022


GROUP BY
    EXTRACT(MONTH FROM orders.order_date::date)

ORDER BY
    total_revenue DESC;
