## Zadanie 8: Kontener Dockera z prostym API

## Autor: Hanna Radchenko
## Kurs: Narzędzia i metody inżynierii oprogramowania

---

1. Opis projektu

Celem projektu było przygotowanie w pełni działającego, lekkiego środowiska uruchomieniowego dla prostego API napisanego w Pythonie przy użyciu Dockera.

2. Projekt wykorzystuje:

2.1 Dockerfile w wersji multi-stage

2.2 ocker Compose

2.3 Gunicorn jako produkcyjny serwer aplikacji

2.3 Flask jako API

2.4 .dockerignore do optymalizacji obrazu

2.5 W efekcie powstał minimalny, szybki i poprawnie zorganizowany kontener z API działającym na porcie 8000.

zadanie8_radchenko/
├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── README.md

3. Opis działania API

## Aplikacja to proste API w Flasku zwracające komunikat JSON:

{"message": "Hello from Docker API!"}


3.1 API działa na porcie 8000 wewnątrz kontenera i jest wystawione na hosta poprzez mapowanie portów.

4. Użyte technologie

4.1 Technologia	Zastosowanie

4.2 Python 3.11	Kod aplikacji (Flask)

4.3 Gunicorn	Produkcyjny serwer aplikacji

4.4 Docker	Konteneryzacja

4.5 Docker Compose	Automatyczne uruchamianie środowiska

4.6 python:3.11-slim	Lekki obraz bazowy

4.7 Multi-stage build	Optymalizacja obrazu

5. Pliki projektu

5.1 app.py

5.2 Kod prostego API w Flasku:

from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def home():
    return jsonify({"message": "Hello from Docker API!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

5.3 requirements.txt

6. Zależności projektu:

flask
gunicorn

.dockerignore
__pycache__/
*.pyc
.env
.git/
*.log
node_modules/
uploads/
docker-compose.yml

Dockerfile (multi-stage)

# Multi-stage build
FROM python:3.11-slim as builder

WORKDIR /app

# Instalacja narzędzi do buildowania pakietów Pythona (czasami potrzebne)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt


# Final stage
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8000"]

docker-compose.yml
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - ENV=production
    restart: unless-stopped


Instrukcje instalacji i uruchomienia

1. Zbudowanie obrazu Dockera
docker build -t my-api .

2. Ręczne uruchomienie kontenera
docker run -p 8000:8000 my-api


Po uruchomieniu API będzie dostępne pod adresem:

http://localhost:8000/

3. Uruchomienie przez Docker Compose
Budowa + start:
docker-compose up --build

Uruchomienie w tle:
docker-compose up -d

Sprawdzenie działania:
curl http://localhost:8000/


Powinno zwrócić:

{"message":"Hello from Docker API!"}

Jak zatrzymać kontener?
docker-compose down
