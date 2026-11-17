FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.lock .
RUN python -m venv /opt/venv && /opt/venv/bin/pip install --no-cache-dir -r requirements.lock
COPY training/ ./training/
RUN cd training && /opt/venv/bin/python train_model.py

FROM python:3.12-slim AS runtime
ENV PATH="/opt/venv/bin:$PATH" PYTHONUNBUFFERED=1 MODEL_DIR=/app/models
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /build/training/saved_models ./models
COPY app/ ./app/
RUN useradd --create-home appuser
USER appuser
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host=0.0.0.0", "--port=8000"]
