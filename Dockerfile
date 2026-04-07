FROM python:3.12-slim

WORKDIR /app

RUN adduser --disabled-password --gecos '' appuser && chown appuser /app

COPY requirements.txt .

USER appuser

RUN pip install --no-cache-dir --user -r requirements.txt

ENV PATH="/home/appuser/.local/bin:$PATH"

COPY --chown=appuser:appuser . .

RUN python model.py

EXPOSE 5000

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-5000} --workers 2 app_model:app"]
