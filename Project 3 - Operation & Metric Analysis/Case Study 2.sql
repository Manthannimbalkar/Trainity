use Trainity;

# A. User Engagement
SELECT DATEPART(week, occurred_at) as week_no, COUNT(DISTINCT user_id) as no_users
FROM events
WHERE event_type = 'engagement'
GROUP BY DATEPART(week, occurred_at)
ORDER BY no_users desc;

# B. User Growth
SELECT
    DATEPART(year, created_at) AS year,
    DATEPART(week, created_at) AS week_no,
    COUNT(DISTINCT user_id) AS no_users,
    SUM(COUNT(DISTINCT user_id)) OVER (ORDER BY DATEPART(year, created_at), DATEPART(week, created_at)) AS cum_users
FROM users
WHERE state = 'active'
GROUP BY DATEPART(year, created_at), DATEPART(week, created_at)
ORDER BY no_users desc;

# C. Weekly Retention - Query 1

SELECT DATEPART(week, occurred_at) as week_no, 
       COUNT(CASE WHEN event_type = 'engagement' THEN user_id END) as engagement,
       COUNT(CASE WHEN event_type = 'signup_flow' THEN user_id END) as signup
FROM events
GROUP BY DATEPART(week, occurred_at)
ORDER BY signup desc;

# C. Weekly Retention - Query 2
WITH cte1 AS (
    SELECT DISTINCT user_id, DATEPART(week, occurred_at) AS signup_week
    FROM events
    WHERE event_type = 'signup_flow' AND event_name = 'complete_signup' AND DATEPART(week, occurred_at) between 18 and 35
),
cte2 AS (
    SELECT DISTINCT user_id, DATEPART(week, occurred_at) AS engagement_week
    FROM events
    WHERE event_type = 'engagement'
)
SELECT COUNT(user_id) AS total_engaged,
       SUM(CASE WHEN retention_week > 0 THEN 1 ELSE 0 END) AS retained_users
FROM (
    SELECT a.user_id, a.signup_week, b.engagement_week, b.engagement_week - a.signup_week AS retention_week
    FROM cte1 a
    LEFT JOIN cte2 b ON a.user_id = b.user_id
)sub;


# D Weekly Engagement
SELECT DATEPART(month, occurred_at) AS month_no, DATEPART(week, occurred_at) AS week_no, device, COUNT(user_id) as total_users
FROM events
GROUP BY DATEPART(month, occurred_at), DATEPART(week, occurred_at), device
ORDER BY total_users desc;


# E. Email Engagement
SELECT 
    action,
    DATEPART(month, occurred_at) as month_no,
    COUNT(action) as emails 
FROM email_events 
GROUP BY action, DATEPART(month, occurred_at) 
ORDER BY emails desc;