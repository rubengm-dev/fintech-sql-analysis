"""
Run all SQL queries against the transactions database and display results.
"""

import sqlite3
import pandas as pd
from pathlib import Path

DB_PATH = "data/transactions.db"
QUERIES_DIR = "queries"


def extract_queries(filepath):
    """Parse a .sql file and extract individual executable queries."""
    content = Path(filepath).read_text(encoding="utf-8")
    lines = content.split("\n")

    current = []
    queries = []

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("--"):
            continue
        current.append(line)
        if ";" in stripped:
            query = "\n".join(current).replace(";", "").strip()
            if query:
                queries.append(query)
            current = []

    remaining = "\n".join(current).strip()
    if remaining:
        queries.append(remaining)

    return queries


def main():
    conn = sqlite3.connect(DB_PATH)
    query_files = sorted(Path(QUERIES_DIR).glob("*.sql"))

    for qf in query_files:
        print(f"\n{'='*60}")
        print(f" {qf.stem.replace('_', ' ').upper()}")
        print(f"{'='*60}")

        queries = extract_queries(qf)

        for i, query in enumerate(queries, 1):
            try:
                df = pd.read_sql_query(query, conn)
                print(f"\n--- Result {i} ---")
                print(df.to_string(index=False))
                print()
            except Exception as e:
                print(f"\n--- Result {i} [ERROR] ---")
                print(f"  {e}")
                print(f"  Query: {query[:80]}...")

    conn.close()
    print("\nDone.")


if __name__ == "__main__":
    main()
