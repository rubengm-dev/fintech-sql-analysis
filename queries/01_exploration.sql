-- ============================================================
-- 01: Data Exploration
-- Overview of transaction volume, types, and value distribution
-- ============================================================

-- Transaction count and total volume by type
SELECT
    type,
    COUNT(*) AS tx_count,
    ROUND(SUM(amount), 2) AS total_volume,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(MIN(amount), 2) AS min_amount,
    ROUND(MAX(amount), 2) AS max_amount
FROM transactions
GROUP BY type
ORDER BY total_volume DESC;


-- Hourly transaction distribution (step = 1 hour)
SELECT
    step % 24 AS hour_of_day,
    COUNT(*) AS tx_count,
    ROUND(SUM(amount), 2) AS volume
FROM transactions
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- Top 10 highest value transactions
SELECT
    type,
    sender_id,
    receiver_id,
    amount,
    is_fraud
FROM transactions
ORDER BY amount DESC
LIMIT 10;


-- Balance change distribution after transactions
SELECT
    type,
    ROUND(AVG(sender_balance_before - sender_balance_after), 2) AS avg_sender_delta,
    ROUND(AVG(receiver_balance_after - receiver_balance_before), 2) AS avg_receiver_delta
FROM transactions
GROUP BY type;
