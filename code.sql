SELECT COUNT(DISTINCT utm_campaign) AS number_of_distinct_campaigns
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS number_of_distinct_sources
FROM page_visits;

SELECT DISTINCT utm_campaign AS campaign, 
	utm_source AS source
FROM page_visits;

SELECT DISTINCT page_name AS pages
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY 1),
ft_attribution AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
 )
SELECT ft_attribution.utm_source AS source,
	ft_attribution.utm_campaign AS campaign, 
	COUNT(*) as number_of_first_touches
FROM ft_attribution
GROUP BY 2
ORDER BY 3 DESC;

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY 1),
lt_attribution AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
 )
SELECT lt_attribution.utm_source AS source,
	lt_attribution.utm_campaign AS campaign, 
	COUNT(*) as number_of_last_touches
FROM lt_attribution
GROUP BY 2
ORDER BY 3 DESC;

SELECT COUNT(DISTINCT user_id) AS number_of_purchasing_vistors
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY 1),
lt_attribution AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign,
  	pv.page_name
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
 )
SELECT lt_attribution.utm_source AS source,
	lt_attribution.utm_campaign AS campaign, 
	COUNT(*) as number_of_purchases
FROM lt_attribution
WHERE lt_attribution.page_name = '4 - purchase'
GROUP BY 2
ORDER BY 3 DESC;