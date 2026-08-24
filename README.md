# Fintech SQL Analysis

Transaction pattern analysis and fraud detection on a simulated mobile money dataset.

## Overview

Analysis of 100K+ financial transactions to identify:
- **User segmentation** based on transaction behavior and temporal patterns
- **Fraud detection patterns** using balance anomalies and transaction characteristics
- **Product metrics** a fintech team would track (DAU, revenue, growth, detection efficiency)

## Dataset

[PaySim](https://www.kaggle.com/datasets/ealaxi/paysim1) — synthetic dataset modeled after real mobile money transactions. Contains transfers, payments, cash-ins, cash-outs, and debits with labeled fraud cases.

- **100,000 transactions** sampled preserving all fraud cases and temporal structure
- **8,213 confirmed fraud cases** across TRANSFER and CASH_OUT types
- **5 transaction types**: TRANSFER, CASH_OUT, CASH_IN, PAYMENT, DEBIT

## Project Structure

```
├── queries/
│   ├── 01_exploration.sql      # Volume, distribution, top transactions
│   ├── 02_segmentation.sql     # Time-based behavior & receiver profiles
│   ├── 03_fraud_detection.sql  # Fraud patterns & red flags
│   └── 04_product_metrics.sql  # DAU, revenue, growth, detection efficiency
├── scripts/
│   ├── setup_database.py       # Data loading & SQLite setup
│   └── run_analysis.py         # Execute queries & display results
├── data/                       # Database (not tracked in git)
└── README.md
```

## Setup

```bash
pip install pandas
python scripts/setup_database.py
python scripts/run_analysis.py
```

## Key Findings

### Fraud Detection
- Fraud occurs exclusively in **TRANSFER** (34.8% fraud rate) and **CASH_OUT** (11.3%)
- Fraudulent transactions average **€1.47M** vs **€315K** for legitimate (4.6x larger)
- Sender balance dropping to zero is a strong fraud indicator (4,078 fraudulent cash-outs exhibit this)
- Current flagging system catches only **16 out of 8,213** fraud cases (0.2% recall) — significant gap for ML improvement

### User Segmentation
- **47 whale receivers** average €12M in total inflow
- **Off-peak transfers** are 21% larger than peak-hour transfers on average
- Peak hours (9:00–20:00) concentrate 85% of all transaction volume

### Product Metrics
- Week-over-week growth: +45% tx volume in week 1, indicating network effects
- Estimated daily revenue peaks at **€8.8M** (fee model: 1% payments + 0.5% transfers)
- Clear weekday/weekend pattern in DAU (10K weekday vs 300 weekend)

## SQL Techniques Used

- Common Table Expressions (CTEs)
- Window functions (`LAG` for growth calculation)
- Conditional aggregation (`CASE WHEN`)
- Index optimization for query performance
- Cohort analysis and temporal segmentation

## Tech Stack

- **SQLite** — lightweight analytical database
- **Python** — data loading and query execution
- **pandas** — result formatting
