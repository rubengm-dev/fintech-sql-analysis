-- ============================================================
-- 03: Fraud Detection Patterns
-- Analyze characteristics of fraudulent transactions
-- ============================================================

-- Fraud rate by transaction type
SELECT
    type,
    COUNT(*) AS total_tx,
    SUM(is_fraud) AS fraud_count,
    ROUND(100.0 * SUM(is_fraud) / COUNT(*), 4) AS fraud_rate_pct,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2) AS avg_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 0 THEN amount END), 2) AS avg_legit_amount
FROM transactions
GROUP BY type
ORDER BY fraud_rate_pct DESC;


-- Fraud vs legitimate: balance behavior comparison
SELECT
    is_fraud,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(AVG(sender_balance_before), 2) AS avg_sender_bal_before,
    ROUND(AVG(sender_balance_after), 2) AS avg_sender_bal_after,
    ROUND(AVG(receiver_balance_before), 2) AS avg_receiver_bal_before
FROM transactions
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY is_fraud;


-- Red flag: sender balance drops to zero after transaction
SELECT
    type,
    is_fraud,
    COUNT(*) AS zero_balance_count,
    ROUND(AVG(amount), 2) AS avg_amount
FROM transactions
WHERE sender_balance_after = 0
  AND sender_balance_before > 0
GROUP BY type, is_fraud
ORDER BY type, is_fraud;


-- Fraud amount distribution by percentile
SELECT
    type,
    ROUND(MIN(amount), 2) AS min_fraud,
    ROUND(AVG(amount), 2) AS avg_fraud,
    ROUND(MAX(amount), 2) AS max_fraud,
    COUNT(*) AS fraud_count
FROM transactions
WHERE is_fraud = 1
GROUP BY type;
