-- ============================================================
-- 02: User Segmentation
-- Identify behavior patterns based on transaction profiles
-- ============================================================

-- Transaction type distribution by time of day (peak vs off-peak)
SELECT
    CASE
        WHEN step % 24 BETWEEN 9 AND 20 THEN 'peak_hours'
        ELSE 'off_peak'
    END AS time_segment,
    type,
    COUNT(*) AS tx_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_volume
FROM transactions
GROUP BY time_segment, type
ORDER BY time_segment, total_volume DESC;


-- Receiver segmentation: classify by inflow volume
WITH receiver_stats AS (
    SELECT
        receiver_id,
        COUNT(*) AS times_received,
        ROUND(SUM(amount), 2) AS total_received,
        ROUND(AVG(amount), 2) AS avg_received,
        COUNT(DISTINCT type) AS types_received
    FROM transactions
    GROUP BY receiver_id
    HAVING times_received >= 2
)
SELECT
    CASE
        WHEN total_received >= 10000000 THEN 'whale'
        WHEN total_received >= 1000000 THEN 'high_value'
        WHEN total_received >= 100000 THEN 'medium'
        ELSE 'small'
    END AS receiver_segment,
    COUNT(*) AS receiver_count,
    ROUND(AVG(total_received), 2) AS avg_total_inflow,
    ROUND(AVG(times_received), 1) AS avg_tx_received
FROM receiver_stats
GROUP BY receiver_segment
ORDER BY avg_total_inflow DESC;
