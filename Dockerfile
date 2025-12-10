# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Zainstaluj wymagane narzędzia systemowe
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Instalacja pakietów Python dla użytkownika
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Final
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000

# Uruchomienie produkcyjnego WSGI
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
