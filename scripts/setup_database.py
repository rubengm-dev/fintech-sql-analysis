"""
Database setup script.
Loads raw transaction data, samples 100K rows preserving temporal structure
and fraud cases, and creates a SQLite database with proper schema and indexes.
"""

import sqlite3
import pandas as pd
from pathlib import Path

RAW_DATA_PATH = "data/PS_20174392719_1491204439457_log.csv"
DB_PATH = "data/transactions.db"
SAMPLE_SIZE = 100_000


def create_database():
    """Load raw CSV, sample rows preserving structure, and build SQLite database."""
    print(f"Loading raw data from {RAW_DATA_PATH}...")
    df = pd.read_csv(RAW_DATA_PATH)
    print(f"Total rows: {len(df):,}")

    # Preserve all fraud cases
    fraud = df[df["isFraud"] == 1]
    print(f"Fraud cases: {len(fraud):,}")

    # Sample non-fraud from first 15 days (steps 0-360) to preserve temporal cohorts
    non_fraud = df[(df["isFraud"] == 0) & (df["step"] <= 360)]
    remaining_needed = SAMPLE_SIZE - len(fraud)

    if len(non_fraud) >= remaining_needed:
        non_fraud_sample = non_fraud.sample(n=remaining_needed, random_state=42)
    else:
        # If not enough, add more from later steps
        extra = df[(df["isFraud"] == 0) & (df["step"] > 360)].sample(
            n=remaining_needed - len(non_fraud), random_state=42
        )
        non_fraud_sample = pd.concat([non_fraud, extra])

    sample = pd.concat([fraud, non_fraud_sample]).sort_values("step").reset_index(drop=True)
    print(f"Sample size: {len(sample):,} ({len(fraud):,} fraud cases preserved)")
    print(f"Time range: step {sample['step'].min()} to {sample['step'].max()}")

    # Rename columns for cleaner SQL
    sample = sample.rename(columns={
        "nameOrig": "sender_id",
        "nameDest": "receiver_id",
        "oldbalanceOrg": "sender_balance_before",
        "newbalanceOrig": "sender_balance_after",
        "oldbalanceDest": "receiver_balance_before",
        "newbalanceDest": "receiver_balance_after",
        "isFraud": "is_fraud",
        "isFlaggedFraud": "is_flagged_fraud",
    })

    # Create database
    conn = sqlite3.connect(DB_PATH)
    sample.to_sql("transactions", conn, if_exists="replace", index=False)

    # Create indexes for query performance
    cursor = conn.cursor()
    cursor.execute("CREATE INDEX idx_type ON transactions(type)")
    cursor.execute("CREATE INDEX idx_fraud ON transactions(is_fraud)")
    cursor.execute("CREATE INDEX idx_sender ON transactions(sender_id)")
    cursor.execute("CREATE INDEX idx_receiver ON transactions(receiver_id)")
    cursor.execute("CREATE INDEX idx_step ON transactions(step)")
    conn.commit()
    conn.close()

    print(f"Database created at {DB_PATH}")
    print("Indexes built. Ready for analysis.")


if __name__ == "__main__":
    create_database()
