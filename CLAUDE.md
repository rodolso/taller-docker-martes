# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker workshop project with two Flask APIs and an ML model:

1. **`app.py`** — A simple CRUD REST API that stores user records (name, email) in a flat JSON file (`tmp/data.txt`).
2. **`app_model.py`** — An ML inference API that serves predictions from a pre-trained advertising sales model (`ad_model.pkl`).
3. **`model.py`** — A standalone script that trains the LinearRegression model on `data/Advertising.csv` and serializes it to `ad_model.pkl`.

## Running the Project

### With Docker (recommended)

```bash
# Build and run app.py (the user CRUD API)
docker compose up --build

# Run app_model.py instead (edit CMD in Dockerfile first, or override):
docker run -p 5000:5000 <image> python app_model.py
```

### Without Docker

```bash
pip install -r requirements.txt

# CRUD API
python app.py

# ML model API
python app_model.py

# Retrain the model (generates/overwrites ad_model.pkl)
python model.py
```

## API Endpoints

**app.py** (user CRUD, port 5000):
- `GET /` — health check
- `GET /user/all` — list all users
- `GET /user?name=<name>` — find user by name
- `POST /user` — create user `{"name": "...", "email": "..."}`
- `PUT /user` — append user (same as POST in current impl)
- `DELETE /user` — delete user by name

**app_model.py** (ML API, port 5000):
- `GET /` — health check
- `GET /api/v1/predict?tv=<float>&radio=<float>&newspaper=<float>` — predict sales
- `GET /api/v1/retrain` — retrain model from `data/Advertising_new.csv`

## Architecture Notes

- The Dockerfile targets `app.py` by default (CMD). To serve the ML API in Docker, the CMD must be changed to `python app_model.py`.
- `app.py` requires `tmp/data.txt` to exist and contain a valid JSON array. The Dockerfile seeds this file at build time; locally you must create it manually.
- `ad_model.pkl` is a pre-serialized sklearn `Pipeline` (imputer → scaler → LinearRegression). It must exist before starting `app_model.py`. Run `model.py` to regenerate it.
- The retrain endpoint in `app_model.py` does **not** persist the retrained model to disk (the pickle dump is commented out).
- Training data lives in `data/Advertising.csv`; new data for retraining goes in `data/Advertising_new.csv`.
