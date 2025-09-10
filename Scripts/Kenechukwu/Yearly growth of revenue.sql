 SELECT 
        EXTRACT(YEAR FROM occurred_at) as sales_year,
        sum(total_amt_usd)Total_revenue
    FROM orders
    group by EXTRACT(YEAR FROM occurred_at)
    ORDER BY sales_year
