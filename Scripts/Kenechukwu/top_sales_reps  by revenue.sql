WITH ranked_reps AS (
    SELECT 
        d.name as region_name,
        c.name as sales_rep_name,
        SUM(a.total_amt_usd) as total_revenue,
        ROUND(AVG(a.total_amt_usd), 2) as avg_order_value,
        RANK() OVER (PARTITION BY d.name ORDER BY SUM(a.total_amt_usd) DESC) as rank
    FROM orders a
    JOIN accounts b ON a.account_id = b.id
    JOIN sales_reps c ON b.sales_rep_id = c.id
    JOIN region d ON c.region_id = d.id
    GROUP BY d.name, c.name
)
SELECT 
    region_name,
    sales_rep_name,
    total_revenue,
    avg_order_value
FROM ranked_reps
WHERE rank = 1
ORDER BY region_name;
