# HW2. Kafka и ClickHouse

Нужны Docker и Docker Compose. Скачайте `train.csv` из [датасета Kaggle](https://www.kaggle.com/t/1918f3f6435300327d38d6c596f97394) и положите его в `producer/teta-ml-1-2025/`.

## Запуск

В папке HW2 выполните:

```bash
docker compose up -d kafka kafka-setup clickhouse
docker compose build producer
docker compose run --rm producer /data/train.csv
```

## Проверка

Дождитесь, пока число строк станет равно `786431`:

```bash
docker compose exec -T clickhouse clickhouse-client --user hw2 --password hw2_local --query 'SELECT count() FROM hw2.transactions'
```

Выполните запрос и сохраните CSV:

```bash
docker compose exec -T clickhouse clickhouse-client --user hw2 --password hw2_local --format CSVWithNames < clickhouse/max_transaction_by_state.sql > results/max_transaction_by_state.csv
```

Результат содержит 51 штат. Для повторной загрузки сначала выполните `docker compose down -v`.

Таблицы описаны в `clickhouse/init.sql`. Агрегированная таблица хранит максимум по каждому штату для быстрого выполнения запроса.
