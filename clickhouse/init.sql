CREATE DATABASE IF NOT EXISTS hw2;

CREATE TABLE IF NOT EXISTS hw2.transactions
(
    state LowCardinality(String),
    category LowCardinality(String),
    amount Decimal(18, 2)
)
ENGINE = MergeTree
ORDER BY state;

CREATE TABLE IF NOT EXISTS hw2.max_transaction_by_state
(
    state LowCardinality(String),
    winner AggregateFunction(argMax, String, Tuple(Decimal(18, 2), String))
)
ENGINE = AggregatingMergeTree
ORDER BY state;

CREATE MATERIALIZED VIEW IF NOT EXISTS hw2.transactions_to_max
TO hw2.max_transaction_by_state
AS
SELECT
    state,
    argMaxState(toString(category), tuple(amount, toString(category))) AS winner
FROM hw2.transactions
GROUP BY state;

CREATE TABLE IF NOT EXISTS hw2.transactions_kafka
(
    state String,
    category String,
    amount Decimal(18, 2)
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'transactions',
    kafka_group_name = 'clickhouse_hw2',
    kafka_format = 'JSONEachRow',
    kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW IF NOT EXISTS hw2.kafka_to_transactions
TO hw2.transactions
AS
SELECT state, category, amount
FROM hw2.transactions_kafka;
