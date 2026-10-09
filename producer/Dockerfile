FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY produce_csv.py .

ENTRYPOINT ["python", "produce_csv.py"]
