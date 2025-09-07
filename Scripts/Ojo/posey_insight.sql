-- Which accounts generated the highest revenue, and who are their sales reps?
--This identifies top customers and highlights which sales reps is most valuable for business.

SELECT 
    a.name AS account_name,
    sr.name AS sales_rep,
    SUM(o.total_amt_usd) AS total_revenue
FROM dev.orders o
JOIN dev.accounts a ON o.account_id = a.id
JOIN dev.sales_reps sr ON a.sales_rep_id = sr.id
GROUP BY a.name, sr.name
ORDER BY total_revenue DESC
LIMIT 10;

-- What are the top customer acquisition channels, and how do they vary across regions?
-- Understanding where traffic comes from helps optimize marketing spend and tailor campaigns by region.

WITH sales_region AS (
	SELECT 
		sr.id,
		r.name AS region
	FROM dev.sales_reps sr
	JOIN dev.region r ON sr.region_id = r.id
)
SELECT 
    sre.region,
    we.channel,
    COUNT(we.id) AS event_count
FROM dev.accounts a
JOIN dev.web_events we ON a.id = we.account_id
JOIN sales_region sre ON a.sales_rep_id = sre.id
GROUP BY sre.region, we.channel
ORDER BY sre.region, event_count DESC;
