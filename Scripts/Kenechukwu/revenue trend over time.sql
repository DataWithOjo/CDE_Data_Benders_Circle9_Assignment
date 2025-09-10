 SELECT 
        CAST(occurred_at AS DATE) as date_occurred,
        total_amt_usd
    FROM orders
    ORDER BY date_occurred
