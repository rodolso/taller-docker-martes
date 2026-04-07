# Advertising Sales Prediction API

API REST para predecir ventas a partir de inversión en publicidad (TV, radio y prensa), construida con Flask y scikit-learn, lista para desplegar en producción con Docker.

---

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/` | Health check |
| `GET` | `/api/v1/predict` | Predice ventas según inversión publicitaria |
| `GET` | `/api/v1/retrain` | Reentrena el modelo con nuevos datos |

### Predicción

```
GET /api/v1/predict?tv=100&radio=50&newspaper=25
```

```json
{
  "predictions": 17.43
}
```

Los tres parámetros (`tv`, `radio`, `newspaper`) son opcionales — los valores ausentes se imputan con la media del conjunto de entrenamiento.

### Reentrenamiento

```
GET /api/v1/retrain
```

Reentrena el modelo usando `data/Advertising_new.csv` y devuelve las métricas RMSE y MAPE del nuevo modelo.

---

## Modelo

Pipeline de scikit-learn con imputación de valores nulos, escalado estándar y regresión lineal, entrenado sobre el dataset [Advertising](https://www.kaggle.com/datasets/ashydv/advertising-dataset).

| Feature | Descripción |
|---------|-------------|
| `tv` | Inversión en publicidad en TV (miles $) |
| `radio` | Inversión en publicidad en radio (miles $) |
| `newspaper` | Inversión en publicidad en prensa (miles $) |
| `sales` | Ventas (miles de unidades) — variable objetivo |

---

## Ejecución local con Docker

```bash
docker build -t advertising-api .
docker run -p 5000:5000 advertising-api
```

La API quedará disponible en `http://localhost:5000`.

> El modelo se entrena automáticamente durante el `docker build` — no hace falta ningún paso previo.

---

## Despliegue en Render

El repositorio incluye `render.yaml`. Basta con conectar el repo en [Render](https://render.com) y hacer deploy — Render detecta la configuración automáticamente y construye la imagen Docker.
