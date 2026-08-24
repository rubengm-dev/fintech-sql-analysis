-- ============================================================
-- 04: Product & Business Metrics
-- KPIs a fintech product team would track
-- ============================================================

-- Daily active senders (DAU proxy, step = 1 hour, day = 24 steps)
SELECT
    step / 24 AS day,
    COUNT(DISTINCT sender_id) AS active_senders,
    COUNT(*) AS tx_count,
    ROUND(SUM(amount), 2) AS daily_volume
FROM transactions
GROUP BY day
ORDER BY day;


-- Transaction success proxy: flagged vs completed
SELECT
    type,
    COUNT(*) AS total,
    SUM(is_flagged_fraud) AS flagged,
    ROUND(100.0 * SUM(is_flagged_fraud) / COUNT(*), 4) AS flag_rate_pct
FROM transactions
GROUP BY type
ORDER BY flag_rate_pct DESC;


-- Revenue estimation (assuming 1% fee on PAYMENT, 0.5% on TRANSFER)
SELECT
    step / 24 AS day,
    ROUND(SUM(CASE WHEN type = 'PAYMENT' THEN amount * 0.01 ELSE 0 END), 2) AS payment_revenue,
    ROUND(SUM(CASE WHEN type = 'TRANSFER' THEN amount * 0.005 ELSE 0 END), 2) AS transfer_revenue,
    ROUND(SUM(
        CASE WHEN type = 'PAYMENT' THEN amount * 0.01
             WHEN type = 'TRANSFER' THEN amount * 0.005
             ELSE 0
        END
    ), 2) AS total_estimated_revenue
FROM transactions
GROUP BY day
ORDER BY day;


-- Weekly growth rate
WITH daily AS (
    SELECT
        step / 24 AS day,
        COUNT(*) AS tx_count,
        SUM(amount) AS volume
    FROM transactions
    GROUP BY day
),
weekly AS (
    SELECT
        day / 7 AS week,
        SUM(tx_count) AS weekly_tx,
        ROUND(SUM(volume), 2) AS weekly_volume
    FROM daily
    GROUP BY week
)
SELECT
    week,
    weekly_tx,
    weekly_volume,
    ROUND(100.0 * (weekly_tx - LAG(weekly_tx) OVER (ORDER BY week))
        / LAG(weekly_tx) OVER (ORDER BY week), 2) AS tx_growth_pct,
    ROUND(100.0 * (weekly_volume - LAG(weekly_volume) OVER (ORDER BY week))
        / LAG(weekly_volume) OVER (ORDER BY week), 2) AS volume_growth_pct
FROM weekly
ORDER BY week;


-- Fraud detection efficiency: flagged vs actual fraud
SELECT
    CASE WHEN is_flagged_fraud = 1 AND is_fraud = 1 THEN 'true_positive'
         WHEN is_flagged_fraud = 1 AND is_fraud = 0 THEN 'false_positive'
         WHEN is_flagged_fraud = 0 AND is_fraud = 1 THEN 'missed_fraud'
         ELSE 'true_negative'
    END AS detection_outcome,
    COUNT(*) AS count,
    ROUND(AVG(amount), 2) AS avg_amount
FROM transactions
GROUP BY detection_outcome
ORDER BY count DESC;
