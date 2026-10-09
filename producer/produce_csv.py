import argparse
import csv
import json
import os

from kafka import KafkaProducer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("csv_file")
    args = parser.parse_args()

    producer = KafkaProducer(
        bootstrap_servers=os.getenv("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092"),
        value_serializer=lambda row: json.dumps(row).encode("utf-8"),
        acks="all",
    )
    count = 0
    with open(args.csv_file, encoding="utf-8", newline="") as file:
        for row in csv.DictReader(file):
            producer.send("transactions", {
                "state": row["us_state"],
                "category": row["cat_id"],
                "amount": row["amount"],
            })
            count += 1
    producer.flush()
    producer.close()
    print(f"Sent {count} transactions")


if __name__ == "__main__":
    main()
