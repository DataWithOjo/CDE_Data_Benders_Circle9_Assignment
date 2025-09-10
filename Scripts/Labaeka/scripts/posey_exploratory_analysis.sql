
-- Total business volume and revenue
SELECT 
    COUNT(DISTINCT id) as total_orders,
    SUM(total_amt_usd) as total_revenue,
    AVG(total_amt_usd) as avg_order_value,
    MAX(total_amt_usd) as largest_order
FROM orders;

-- by paper type
SELECT 
    SUM((standard_qty::numeric * standard_amt_usd::numeric)) as standard_revenue,
    SUM((gloss_qty::numeric * gloss_amt_usd::numeric)) as gloss_revenue,
    SUM((poster_qty::numeric * poster_amt_usd::numeric)) as poster_revenue
FROM orders;


-- Top 10 customers by revenue
SELECT 
    a.name as company_name,
    COUNT(o.id) as total_orders,
    SUM(o.total_amt_usd::numeric) as total_revenue,
    AVG(o.total_amt_usd::numeric) as avg_order_value
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_revenue DESC
LIMIT 10;

-- Customer distribution by order frequency
SELECT 
    order_frequency,
    COUNT(*) as customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM (
    SELECT 
        a.name,
        COUNT(o.id) as order_frequency
    FROM accounts a
    LEFT JOIN orders o ON a.id = o.account_id
    GROUP BY a.name
) customer_orders
GROUP BY order_frequency
ORDER BY order_frequency;


-- Sales rep performance
SELECT 
    sr.name as sales_rep,
    r.name as region,
    COUNT(DISTINCT a.id) as accounts_managed,
    COUNT(o.id) as total_orders,
    SUM(o.total_amt_usd) as total_sales,
    ROUND(AVG(o.total_amt_usd), 2) as avg_order_value
FROM sales_reps sr
JOIN region r ON sr.region_id = r.id
JOIN accounts a ON sr.id = a.sales_rep_id
LEFT JOIN orders o ON a.id = o.account_id
GROUP BY sr.name, r.name
ORDER BY total_sales DESC;

-- Regional performance 
SELECT 
    r.name as region,
    COUNT(DISTINCT sr.id) as sales_reps,
    COUNT(DISTINCT a.id) as total_accounts,
    COUNT(o.id) as total_orders,
    SUM(o.total_amt_usd) as total_revenue,
    ROUND(AVG(o.total_amt_usd), 2) as avg_order_value
FROM region r
JOIN sales_reps sr ON r.id = sr.region_id
JOIN accounts a ON sr.id = a.sales_rep_id
LEFT JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY total_revenue DESC;

-- revenue by paper type
SELECT 
    'Standard' as paper_type,
    SUM(standard_qty::numeric) as total_quantity,
    SUM(standard_amt_usd::numeric) as total_revenue,
    COUNT(CASE WHEN standard_qty::numeric > 0 THEN 1 END) as orders_with_product
FROM orders
UNION ALL
SELECT 
    'Gloss' as paper_type,
    SUM(gloss_qty::numeric) as total_quantity,
    SUM(gloss_amt_usd::numeric) as total_revenue,
    COUNT(CASE WHEN gloss_qty::numeric > 0 THEN 1 END) as orders_with_product
FROM orders
UNION ALL
SELECT 
    'Poster' as paper_type,
    SUM(poster_qty::numeric) as total_quantity,
    SUM(poster_amt_usd::numeric) as total_revenue,
    COUNT(CASE WHEN poster_qty::numeric > 0 THEN 1 END) as orders_with_product
FROM orders;


-- website events by channel
SELECT 
    channel,
    COUNT(*) as total_events,
    COUNT(DISTINCT account_id) as unique_accounts
FROM web_events
GROUP BY channel
ORDER BY total_events DESC;
