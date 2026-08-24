# 💳 Fintech SQL Analysis — Transaction Patterns & Fraud Detection



![Python](https://img.shields.io/badge/Python-3.12-blue)



![SQL](https://img.shields.io/badge/SQL-SQLite-orange)



![Pandas](https://img.shields.io/badge/Pandas-Data_Analysis-green)



![License](https://img.shields.io/badge/License-MIT-yellow)

SQL-based transaction pattern analysis and fraud detection on a simulated mobile money dataset (PaySim). Analyzes 100K+ financial transactions to identify user behavior, anomalies, and product metrics relevant to a fintech team.

---

## 🎯 Key Findings

| Metric | Value |
| --- | --- |
| **Total Transactions** | 100,000+ |
| **Fraud Cases Detected** | 8,213 |
| **Transaction Types** | 5 (TRANSFER, CASH_OUT, CASH_IN, PAYMENT, DEBIT) |
| **Fraud Concentrated In** | TRANSFER & CASH_OUT only |

---

## 📊 Analysis Areas

### 1. User Segmentation

- Transaction behavior clustering by frequency, volume, and type
- Temporal patterns: peak hours, daily/weekly cycles
- High-value vs. micro-transaction user profiles

### 2. Fraud Detection Patterns

- Balance anomaly detection (zero-balance post-transaction)
- Flagged vs. actually fraudulent transaction analysis
- Amount thresholds and recipient concentration patterns

### 3. Product Metrics

- DAU (Daily Active Users) estimation
- Revenue attribution by transaction type
- Growth and retention indicators
- Fraud detection efficiency (precision/recall of the flagging system)

---

## 🔧 Tech Stack

| Component | Tool |
| --- | --- |
| Database | SQLite |
| Language | Python 3.12, SQL |
| Data Processing | Pandas |
| Dataset | [PaySim](https://www.kaggle.com/datasets/ealaxi/paysim1) (synthetic mobile money) |

---

## 📦 Dataset

**PaySim** — synthetic dataset modeled after real mobile money transactions from a major African mobile operator.

| Feature | Description |
| --- | --- |
| `type` | TRANSFER, CASH_OUT, CASH_IN, PAYMENT, DEBIT |
| `amount` | Transaction amount |
| `nameOrig` | Sender account |
| `nameDest` | Receiver account |
| `oldbalanceOrg` / `newbalanceOrg` | Sender balance before/after |
| `oldbalanceDest` / `newbalanceDest` | Receiver balance before/after |
| `isFraud` | Ground truth fraud label |
| `isFlaggedFraud` | System-flagged transactions |

---

## 📁 Project Structure

```
fintech-sql-analysis/
├── README.md
├── data/
│   └── transactions.csv           # PaySim sample (100K rows)
├── queries/
│   ├── 01_exploration.sql         # Data overview & schema
│   ├── 02_user_segmentation.sql   # User behavior analysis
│   ├── 03_fraud_detection.sql     # Fraud pattern queries
│   └── 04_product_metrics.sql     # Business KPIs
└── scripts/
    └── analysis.py                # Python orchestration & visualization

```

---

## 🚀 Quick Start

```python
import sqlite3
import pandas as pd

# Load data into SQLite
conn = sqlite3.connect(":memory:")
df = pd.read_csv("data/transactions.csv")
df.to_sql("transactions", conn, index=False)

# Run a query
result = pd.read_sql("""
    SELECT type, COUNT(*) as count, 
           SUM(CASE WHEN isFraud=1 THEN 1 ELSE 0 END) as fraud_count
    FROM transactions 
    GROUP BY type
""", conn)
print(result)

```

---

## 📝 Key Learnings

1. **Fraud is type-specific:** 100% of fraud occurs in TRANSFER and CASH_OUT — other types are clean.
2. **Flagging system is broken:** The `isFlaggedFraud` column catches almost no actual fraud — a rule-based system would significantly outperform it.
3. **Balance anomalies are the strongest signal:** Transactions where sender ends at exactly 0 and receiver balance doesn't increase are highly indicative of fraud.
4. **SQL is powerful for EDA:** Complex fraud patterns can be surfaced with window functions and CTEs before building ML models.

---

## 🔮 Next Steps

- [ ] Build a classification model (Logistic Regression / XGBoost) for fraud prediction
- [ ] Add visualization dashboard (Streamlit or Power BI)
- [ ] Expand to full PaySim dataset (6.3M transactions)
- [ ] Network analysis — identify fraud rings via sender-receiver graphs

---

## 🔗 Links

- 📦 **Dataset:** [PaySim on Kaggle](https://www.kaggle.com/datasets/ealaxi/paysim1)
- 📓 **Related:** [PPE Detection with YOLOv8](https://github.com/rubengm-dev/PPE-Detection-YOLOv8) (Computer Vision project)

---

## 📄 License

MIT License — free for personal and educational use.

---

## 👤 Author

**Rubén García Márquez**

- 🔗 [LinkedIn](https://www.linkedin.com/in/rub%C3%A9n-garc%C3%ADa-m%C3%A1rquez-84ab08238)
- 🐙 [GitHub](https://github.com/rubengm-dev)

